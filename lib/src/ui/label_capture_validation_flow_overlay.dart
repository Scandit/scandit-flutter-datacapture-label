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
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_validation_flow_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';

abstract class LabelCaptureValidationFlowListener {
  void didCaptureLabelWithFields(List<LabelField> fields);
}

class LabelCaptureValidationFlowOverlay extends DataCaptureOverlay {
  _LabelCaptureValidationFlowOverlayController? _controller;

  DataCaptureView? _view;

  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureValidationFlowSettings? _settings;

  LabelCaptureValidationFlowOverlay._(this._mode) : super('validationFlow');

  LabelCaptureValidationFlowOverlay(LabelCapture mode) : this._(mode);

  @Deprecated('Use LabelCaptureValidationFlowOverlay() instead')
  factory LabelCaptureValidationFlowOverlay.withLabelCapture(LabelCapture labelCapture, {DataCaptureView? view}) {
    final overlay = LabelCaptureValidationFlowOverlay._(labelCapture);
    view?.addOverlay(overlay);
    return overlay;
  }

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      _view = null;
      _controller?.dispose();
      _controller = null;
      return;
    }

    _view = newValue;
    _controller ??= _LabelCaptureValidationFlowOverlayController(this);
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
    return json;
  }
}

class _LabelCaptureValidationFlowOverlayController extends BaseController {
  StreamSubscription<dynamic>? _overlaySubscription;

  final LabelCaptureValidationFlowOverlay overlay;

  _LabelCaptureValidationFlowOverlayController(this.overlay) : super('com.scandit.datacapture.label/method_channel') {
    initialize();
  }

  void initialize() {
    if (overlay._listener != null) {
      subscribeListener();
    }
  }

  void subscribeListener() {
    methodChannel.invokeMethod('registerListenerForValidationFlowEvents', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => _listenToEvents(), onError: onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _overlaySubscription = null;
    methodChannel.invokeMethod('unregisterListenerForValidationFlowEvents', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => null, onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.listen((event) async {
      if (overlay._listener == null) return;
      final json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case 'LabelCaptureValidationFlowListener.didCaptureLabelWithFields':
          final fieldsJson = json['fields'];
          final fields = (fieldsJson as List).map((e) => LabelField.fromJSON(jsonDecode(e))).toList();
          overlay._listener?.didCaptureLabelWithFields(fields);
          break;
      }
    });
  }

  Future<void> updateValidationFlowOverlay() {
    return methodChannel.invokeMethod('updateLabelCaptureValidationFlowOverlay', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
      'overlayJson': jsonEncode(overlay.toMap())
    }).then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
