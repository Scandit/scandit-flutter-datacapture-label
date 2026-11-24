/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart'
    show
        LabelCaptureValidationFlowListenerDidCaptureLabelWithFields,
        LabelCaptureValidationFlowListenerDidSubmitManualInputForField,
        LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult;
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_validation_flow_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/label_result_update_type.dart';
import '../tolerant_payload_parser.dart';

/// Interface to be implemented by listeners that want to observe a [LabelCaptureValidationFlowOverlay] and get informed when a new label have been completely captured and validated by the end user.
///
/// Added in version 7.5.0
abstract class LabelCaptureValidationFlowListener {
  /// Invoked when the validation flow has finished and the end user has validated a label capture. The method receives a list of all the captured fields and their values. Before this method is called, the LabelCapture mode will be automatically disabled and the camera will be paused. To continue scanning, the mode should be enabled again and the camera should be turned on.
  ///
  /// Added in version 7.5.0
  void didCaptureLabelWithFields(List<LabelField> fields);
}

/// Extended interface for validation flow events. Implement this interface instead of the base listener to receive manual input callbacks.
///
/// Added in version 8.2.0
abstract class LabelCaptureValidationFlowExtendedListener extends LabelCaptureValidationFlowListener {
  /// Invoked when the user manually submits a value for a field through the validation flow UI.
  ///
  /// Added in version 8.2.0
  void didSubmitManualInputForField(LabelField field, String? oldValue, String newValue);
  /// Invoked when the validation flow results are updated. This callback provides information about label field updates.
  ///
  /// For synchronous scanning, this method is invoked once with type = [LabelResultUpdateType.sync] and asyncId = -1.
  ///
  /// For asynchronous scanning, this method is invoked twice:
  ///
  /// - First invocation: type = [LabelResultUpdateType.asyncStarted] with frameData available and asyncId set to the unique identifier of the asynchronous operation
  /// - Second invocation: type = [LabelResultUpdateType.asyncFinished] with frameData as *null* and asyncId matching the identifier from the first invocation
  ///
  /// The asyncId parameter allows you to correlate the start and finish events of the same asynchronous operation.
  ///
  /// Added in version 8.4.0
  Future<void> didUpdateValidationFlowResult(
    LabelResultUpdateType type,
    int asyncId,
    List<LabelField> fields,
    Future<FrameData?> Function() getFrameData,
  );
}

/// Specialized overlay that provides a guided scanning experience with validation flow capabilities. This overlay enables multi-step scanning for complete label capture, allowing users to scan label fields progressively across multiple scans and providing a user-friendly data review and correction interface.
///
/// Key features of the validation flow:
///
/// - **Multi-step scanning** - Capture several label fields across multiple scans
/// - **Field-by-field validation** - Validate individual fields as they are captured
/// - **User review interface** - Allow users to review and correct captured data
/// - **Configurable hint messages** - Guide users through different scanning stages
/// - **Manual input support** - Enable manual entry for fields that cannot be scanned
///
/// The validation flow ensures complete and accurate results by aggregating captured fields into a complete label which is reported through the [LabelCaptureValidationFlowListener].
///
/// This overlay focuses on validation flow and does not provide barcode or field highlighting. For visual feedback during scanning, use [LabelCaptureBasicOverlay] alongside this overlay.
///
/// The validation flow overlay only works with a single label definition. This label definition can contain multiple barcodes, text fields, expiry dates, and other field types.
///
/// Added in version 7.5.0
class LabelCaptureValidationFlowOverlay extends DataCaptureOverlay
    with ViewAttachable, _LabelCaptureValidationFlowOverlayViewAttachable {
  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureValidationFlowSettings? _settings;

  bool _shouldHandleKeyboardInsetsInternally = true;
  /// In the past, the window insets for ime were automatically handled by the system, but from android 15 and the edge-to-edge enforcement they need to be handled.
  ///
  /// Applications should apply insets in a parent of the [DataCaptureView] this overlay is attached to, either through android:fitsSystemWindows=”true” in xml, some kind of WindowInsetsListener + padding or a Modifier.imePadding() in compose.
  ///
  /// The following [guide by the Android team](https://developer.android.com/develop/ui/views/layout/edge-to-edge) explains how to implement edge-to-edge and handle insets in modern android versions.
  ///
  /// If an application needs to handle insets differently from that and runs into a visual issue where the input fields are behind the keyboard, setting this flag to true will instruct the overlay to manually handle insets internally.
  ///
  /// Defaults to false on Android. Defaults to true on cross-platform frameworks (React Native, Flutter, Capacitor, Cordova), since their view containers do not handle keyboard insets by default.
  ///
  /// Added in version 8.3.0
  bool get shouldHandleKeyboardInsetsInternally => _shouldHandleKeyboardInsetsInternally;
  /// In the past, the window insets for ime were automatically handled by the system, but from android 15 and the edge-to-edge enforcement they need to be handled.
  ///
  /// Applications should apply insets in a parent of the [DataCaptureView] this overlay is attached to, either through android:fitsSystemWindows=”true” in xml, some kind of WindowInsetsListener + padding or a Modifier.imePadding() in compose.
  ///
  /// The following [guide by the Android team](https://developer.android.com/develop/ui/views/layout/edge-to-edge) explains how to implement edge-to-edge and handle insets in modern android versions.
  ///
  /// If an application needs to handle insets differently from that and runs into a visual issue where the input fields are behind the keyboard, setting this flag to true will instruct the overlay to manually handle insets internally.
  ///
  /// Defaults to false on Android. Defaults to true on cross-platform frameworks (React Native, Flutter, Capacitor, Cordova), since their view containers do not handle keyboard insets by default.
  ///
  /// Added in version 8.3.0
  set shouldHandleKeyboardInsetsInternally(bool value) {
    _shouldHandleKeyboardInsetsInternally = value;
    _controller?.updateValidationFlowOverlay();
  }

  LabelCaptureValidationFlowOverlay._(this._mode) : super('validationFlow');

  /// Constructs a new LabelCaptureValidationFlowOverlay. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  LabelCaptureValidationFlowOverlay(LabelCapture mode) : this._(mode);

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 7.5.0
  @override
  DataCaptureView? get view => attachedView;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 7.5.0
  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      attachedView?.unregisterAttachable(this);
      return;
    }

    newValue.registerAttachable(this);
  }

  LabelCaptureValidationFlowListener? _listener;

  /// Sets the listener to this overlay instance to observe the label capture mode and get notified when a label has been validated and accepted by the end user.
  ///
  /// Added in version 7.5.0
  LabelCaptureValidationFlowListener? get listener => _listener;

  /// Sets the listener to this overlay instance to observe the label capture mode and get notified when a label has been validated and accepted by the end user.
  ///
  /// Added in version 7.5.0
  set listener(LabelCaptureValidationFlowListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  /// Applies the new settings to the validation flow overlay.
  ///
  /// Added in version 7.5.0
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
      // didUpdateValidationFlowResult owes an ack, so its listener check lives inside the try
      // below (see label_capture.dart); the other two branches owe nothing and can return here.
      if (overlay._listener == null &&
          !event.isEvent('LabelCaptureValidationFlowListener.didUpdateValidationFlowResult')) {
        return;
      }

      if (event.isEvent('LabelCaptureValidationFlowListener.didCaptureLabelWithFields')) {
        final payload = parsePayloadTolerantly<LabelCaptureValidationFlowListenerDidCaptureLabelWithFields>(
          event.payload,
          (raw) => LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `fields` is required and its entries are fed into jsonDecode below; an empty
            // placeholder would silently report zero fields, so decline when it's missing.
            final fields = _coerceStringList(map['fields']);
            if (fields == null) return null;
            return LabelCaptureValidationFlowListenerDidCaptureLabelWithFields(
              fields: fields,
              event: 'LabelCaptureValidationFlowListener.didCaptureLabelWithFields',
            );
          },
          'didCaptureLabelWithFields',
          'LabelCaptureValidationFlowOverlay',
        );
        if (payload == null) return;
        final fields = payload.fields.map((e) => LabelField.fromJSON(jsonDecode(e))).toList();
        overlay._listener?.didCaptureLabelWithFields(fields);
      } else if (event.isEvent('LabelCaptureValidationFlowListener.didSubmitManualInputForField')) {
        final listener = overlay._listener;
        if (listener is LabelCaptureValidationFlowExtendedListener) {
          final payload = parsePayloadTolerantly<LabelCaptureValidationFlowListenerDidSubmitManualInputForField>(
            event.payload,
            (raw) => LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fromJson(raw),
            (raw) {
              final map = raw is Map ? raw : const <String, dynamic>{};
              // `fields` (fed into jsonDecode below, via .first) and `newValue` are required;
              // decline rather than fabricate an empty list / ''. `oldValue` is nullable on the
              // wire (no prior value to compare against), so null is a legitimate value.
              final fields = _coerceStringList(map['fields']);
              if (fields == null || fields.isEmpty || map['newValue'] is! String) return null;
              return LabelCaptureValidationFlowListenerDidSubmitManualInputForField(
                fields: fields,
                oldValue: map['oldValue'] is String ? map['oldValue'] as String : null,
                newValue: map['newValue'] as String,
                event: 'LabelCaptureValidationFlowListener.didSubmitManualInputForField',
              );
            },
            'didSubmitManualInputForField',
            'LabelCaptureValidationFlowOverlay',
          );
          if (payload == null) return;
          final field = LabelField.fromJSON(jsonDecode(payload.fields.first));
          // oldValue is nullable on the wire (no prior value to compare against); pass it
          // through as-is rather than coercing it to a placeholder.
          listener.didSubmitManualInputForField(field, payload.oldValue, payload.newValue);
        }
      } else if (event.isEvent('LabelCaptureValidationFlowListener.didUpdateValidationFlowResult')) {
        // ACK-owing: native blocks a background thread on every didUpdateValidationFlowResult
        // emit until finishValidationFlowResultUpdateEvent comes back. Whatever the listener
        // does — including a schema-parse failure — must not skip the ack, or native pays the
        // full per-frame timeout. Do the work in `try`, ack in `finally`. [SDC-33042]
        try {
          final listener = overlay._listener;
          if (listener is LabelCaptureValidationFlowExtendedListener) {
            final payload = parsePayloadTolerantly<LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult>(
              event.payload,
              (raw) => LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fromJson(raw),
              (raw) {
                final map = raw is Map ? raw : const <String, dynamic>{};
                // `type` and `fields` are required; a fabricated 'Sync' would misreport a real
                // AsyncStarted payload as synchronous, and an empty `fields` placeholder would
                // silently drop data, so decline on either. `frameId` is nullable on the wire.
                final fields = _coerceStringList(map['fields']);
                if (fields == null || map['type'] is! String || map['asyncId'] is! int) return null;
                // An unknown `type` string would reach fromJSON's bare firstWhere and throw
                // `No element`, which names nothing. Decline here so the log names the value.
                if (!LabelResultUpdateType.values.any((e) => e.toString() == map['type'])) return null;
                return LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult(
                  fields: fields,
                  type: map['type'] as String,
                  asyncId: map['asyncId'] as int,
                  frameId: map['frameId'] is String ? map['frameId'] as String : null,
                  event: 'LabelCaptureValidationFlowListener.didUpdateValidationFlowResult',
                );
              },
              'didUpdateValidationFlowResult',
              'LabelCaptureValidationFlowOverlay',
            );
            // Decline: bail out of the try, but the `finally` below still runs the ack.
            if (payload == null) return;
            final type = LabelResultUpdateType.fromJSON(payload.type);
            final fields = payload.fields.map((e) => LabelField.fromJSON(jsonDecode(e))).toList();
            final frameId = payload.frameId;

            await listener.didUpdateValidationFlowResult(
              type,
              payload.asyncId,
              fields,
              () => frameId != null ? _getLastFrameData(frameId) : Future.value(),
            );
          }
        } catch (error) {
          developer.log('LabelCaptureValidationFlowOverlay didUpdateValidationFlowResult listener failed: $error');
        } finally {
          await labelMethodHandler.finishValidationFlowResultUpdateEvent();
        }
      }
    });
  }

  // Every entry feeds `jsonDecode`, so a non-string entry must not be stringified into something
  // that then throws; return null to decline the whole payload instead.
  static List<String>? _coerceStringList(Object? value) {
    if (value is! List) return null;
    if (value.any((e) => e is! String)) return null;
    return value.cast<String>();
  }

  Future<FrameData> _getLastFrameData(String frameId) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  Future<void> updateValidationFlowOverlay() {
    return labelMethodHandler
        .updateLabelCaptureValidationFlowOverlay(
          dataCaptureViewId: overlay._dataCaptureViewId,
          overlayJson: jsonEncode(overlay.toMap()),
        )
        .then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
