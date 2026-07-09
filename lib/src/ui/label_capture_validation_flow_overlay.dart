/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_validation_flow_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/label_result_update_type.dart';

abstract class LabelCaptureValidationFlowListener {
  void didCaptureLabelWithFields(List<LabelField> fields);
}

abstract class LabelCaptureValidationFlowExtendedListener extends LabelCaptureValidationFlowListener {
  void didSubmitManualInputForField(LabelField field, String? oldValue, String newValue);
  Future<void> didUpdateValidationFlowResult(
    LabelResultUpdateType type,
    int asyncId,
    List<LabelField> fields,
    Future<FrameData?> Function() getFrameData,
  );
}

class LabelCaptureValidationFlowOverlay extends DataCaptureOverlay
    with ViewAttachable, _LabelCaptureValidationFlowOverlayViewAttachable {
  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureValidationFlowSettings? _settings;

  bool _shouldHandleKeyboardInsetsInternally = true;
  bool get shouldHandleKeyboardInsetsInternally => _shouldHandleKeyboardInsetsInternally;
  set shouldHandleKeyboardInsetsInternally(bool value) {
    _shouldHandleKeyboardInsetsInternally = value;
    _controller?.updateValidationFlowOverlay();
  }

  LabelCaptureValidationFlowOverlay._(this._mode) : super('validationFlow');

  LabelCaptureValidationFlowOverlay(LabelCapture mode) : this._(mode);

  @override
  DataCaptureView? get view => attachedView;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      attachedView?.unregisterAttachable(this);
      return;
    }

    newValue.registerAttachable(this);
  }

  LabelCaptureValidationFlowListener? _listener;

  LabelCaptureValidationFlowListener? get listener => _listener;

  set listener(LabelCaptureValidationFlowListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> applySettings(LabelCaptureValidationFlowSettings settings) {
    _settings = settings;
    return _controller?.updateValidationFlowOverlay() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    final json = super.toMap();
    json['hasListener'] = listener != null;
    json['settings'] = _settings?.toMap();
    json['modeId'] = _mode.toMap()['modeId'];
    json['shouldHandleKeyboardInsetsInternally'] = shouldHandleKeyboardInsetsInternally;
    return json;
  }
}

/// Holds the [ViewAttachable] lifecycle for [LabelCaptureValidationFlowOverlay].
///
/// These callbacks are kept in a (private) mixin rather than on the overlay class on
/// purpose: the docs signature collector only inspects class declarations, so methods
/// declared here are not mistaken for public API. (Mirrors `PrivateZoomGesture` in core.)
///
/// [SDC-30872] The listener is registered in [onViewInitialized] — only once the view's
/// controller is ready and the viewId is valid — and re-registered when the view is
/// recreated. Registering eagerly (while viewId is still -1) makes the iOS native side
/// fail to resolve the overlay and silently leave the delegate unset, so
/// didCaptureLabelWithFields never fires and scanning stays continuous.
mixin _LabelCaptureValidationFlowOverlayViewAttachable on ViewAttachable {
  _LabelCaptureValidationFlowOverlayController? _controller;

  @override
  void onAttachToView(DataCaptureView view) {
    super.onAttachToView(view);
    _controller ??= _LabelCaptureValidationFlowOverlayController(this as LabelCaptureValidationFlowOverlay);
  }

  @override
  void onViewInitialized(int viewId) {
    if ((this as LabelCaptureValidationFlowOverlay)._listener != null) {
      _controller?.subscribeListener();
    }
  }

  @override
  void onDetachFromView() {
    _controller?.dispose();
    _controller = null;
    super.onDetachFromView();
  }
}

class _LabelCaptureValidationFlowOverlayController extends BaseController {
  StreamSubscription<dynamic>? _overlaySubscription;
  late final LabelMethodHandler labelMethodHandler;

  final LabelCaptureValidationFlowOverlay overlay;

  bool _isRegistered = false;

  _LabelCaptureValidationFlowOverlayController(this.overlay) : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
  }

  void subscribeListener() {
    if (_isRegistered) return;
    _isRegistered = true;
    labelMethodHandler
        .registerListenerForValidationFlowEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void unsubscribeListener() {
    if (!_isRegistered) return;
    _isRegistered = false;
    _overlaySubscription?.cancel();
    _overlaySubscription = null;
    labelMethodHandler
        .unregisterListenerForValidationFlowEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => null, onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.asFlutterEvents().listen((event) async {
      if (overlay._listener == null) return;

      if (event.isEvent('LabelCaptureValidationFlowListener.didCaptureLabelWithFields')) {
        final fieldsJson = event.payload['fields'];
        final fields = (fieldsJson as List).map((e) => LabelField.fromJSON(jsonDecode(e))).toList();
        overlay._listener?.didCaptureLabelWithFields(fields);
      } else if (event.isEvent('LabelCaptureValidationFlowListener.didSubmitManualInputForField')) {
        final listener = overlay._listener;
        if (listener is LabelCaptureValidationFlowExtendedListener) {
          final fieldsJson = event.payload['fields'];
          final field = LabelField.fromJSON(jsonDecode((fieldsJson as List).first));
          final oldValue = event.payload['oldValue'] as String?;
          final newValue = event.payload['newValue'] as String;
          listener.didSubmitManualInputForField(field, oldValue, newValue);
        }
      } else if (event.isEvent('LabelCaptureValidationFlowListener.didUpdateValidationFlowResult')) {
        final listener = overlay._listener;
        if (listener is LabelCaptureValidationFlowExtendedListener) {
          final type = LabelResultUpdateType.fromJSON(event.payload['type']);
          final asyncId = event.payload['asyncId'];
          final frameId = event.payload['frameId'];
          final fieldsJson = event.payload['fields'];
          final fields = (fieldsJson as List).map((e) => LabelField.fromJSON(jsonDecode(e))).toList();

          await listener.didUpdateValidationFlowResult(type, asyncId, fields, () => _getLastFrameData(frameId));
        }

        labelMethodHandler.finishValidationFlowResultUpdateEvent();
      }
    });
  }

  Future<FrameData> _getLastFrameData(String frameId) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  Future<void> updateValidationFlowOverlay() {
    return labelMethodHandler
        .updateLabelCaptureValidationFlowOverlay(
            dataCaptureViewId: overlay._dataCaptureViewId, overlayJson: jsonEncode(overlay.toMap()))
        .then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
