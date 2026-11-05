/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart'
    show LabelCaptureListenerDidUpdateSession;
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'tolerant_payload_parser.dart';

/// Interface to be implemented by listeners that want to observe a label capture mode ([LabelCapture]) and get informed whenever new labels have been captured, existing labels have been updated or lost.
///
/// This listener is essential to the Smart Label Capture workflow, providing callbacks for handling label recognition events and processing captured field data. Best practices include disabling the capture mode after successful recognition and using background processing for result handling.
///
/// Key responsibilities include:
///
/// - **Handling captured labels** - Process complete labels and their field data
/// - **Managing capture lifecycle** - Disable mode after successful capture to prevent duplicate results
/// - **Providing user feedback** - Give immediate feedback on successful captures
/// - **Optional field handling** - Process both mandatory and optional fields gracefully
///
/// Added in version 7.2.0
abstract class LabelCaptureListener {
  /// Invoked after label capture has processed a frame. The *session* contains a list of the currently captured labels, including both complete and incomplete labels being tracked. The list may be empty when no labels are currently detected.
  ///
  /// Use this callback to:
  ///
  /// - Check for newly completed labels using [CapturedLabel.isComplete]
  /// - Extract data from captured label fields
  /// - Implement application-specific logic for handling captured labels
  ///
  /// Added in version 7.2.0
  Future<void> didUpdateSession(
    LabelCapture labelCapture,
    LabelCaptureSession session,
    Future<FrameData?> Function() getFrameData,
  );
}

/// Smart Label Capture enables simultaneous scanning of multiple barcodes and printed text on labels, streamlining data entry and reducing errors. This data capture mode combines barcode recognition with OCR to extract contextually relevant data fields from labels with structured layouts.
///
/// Smart Label Capture intelligently identifies label information using multiple recognition approaches:
///
/// - **Content analysis** of texts and barcodes for validation
/// - **Barcode symbology** detection for field identification
/// - **Relative field positioning** within the label layout
/// - **Textual context** to understand field relationships
///
/// Primary use cases include:
///
/// - **Retail product scanning** with price verification
/// - **Smart device label scanning** for IMEI and serial numbers
/// - **Shelf price label verification** for retail operations
/// - **Vehicle identification number (VIN) capture** from automotive labels
///
/// Unlike [BarcodeCapture] which focuses on individual barcodes, Smart Label Capture provides contextual intelligence to extract multiple data types simultaneously and supports flexible field definitions for diverse label layouts.
///
/// The key components of Label Capture are:
///
/// - **Label Definitions**: Define the structure and expected fields of labels
/// - **Field Definitions**: - Define individual data fields (barcodes, text, dates, etc.)
/// - **Captured Labels**: - Represent successfully scanned labels with all their field data
///
/// Label Capture can track labels across multiple frames, allowing for progressive scanning where fields are captured over time until the complete label is assembled.
///
/// It cannot be used together with other capture modes that require the same capabilities, e.g. [BarcodeCapture] or [BarcodeBatch].
///
/// Added in version 7.2.0
class LabelCapture extends DataCaptureMode {
  final List<LabelCaptureListener> _listeners = [];
  bool _enabled = true;
  LabelCaptureSettings _settings;
  late _LabelCaptureController _controller;

  LabelCaptureFeedback _feedback = LabelCaptureFeedback.defaultFeedback;

  final _modeId = Random().nextInt(0x7FFFFFFF);

  LabelCapture._(this._settings) {
    _controller = _LabelCaptureController(this);
    _feedback.addListener(_onFeedbackChanged);
  }

  /// Constructs a new LabelCapture instance with the provided settings.
  ///
  /// Added in version 7.6.0
  LabelCapture(LabelCaptureSettings settings) : this._(settings);

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.context].
  ///
  /// Added in version 7.2.0
  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 7.2.0
  @override
  bool get isEnabled => _enabled;

  /// Implemented from [DataCaptureMode]. See [DataCaptureMode.isEnabled].
  ///
  /// Added in version 7.2.0
  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  /// Asynchronously apply the new settings to label capture. This allows you to modify label definitions, change field configurations, or update recognition parameters at runtime.
  ///
  /// When not in validation flow, if label capture is currently running, the task will complete when the next frame is processed, and will use the new settings for that frame. If label capture is currently *not* running, the task will complete as soon as the settings have been stored and won’t wait until the next frame is going to be processed.
  ///
  /// When in validation flow, calls to this method will be ignored.
  ///
  /// Added in version 7.2.0
  Future<void> applySettings(LabelCaptureSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  /// Adds the listener to this label capture instance to observe the label capture mode and get notified when a label or some of its fields got scanned.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 7.2.0
  void addListener(LabelCaptureListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  /// Removes a previously added listener from this label capture instance.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 7.2.0
  void removeListener(LabelCaptureListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

  /// Returns the recommended camera settings for use with label capture.
  ///
  /// Added in version 7.6.0
  static CameraSettings createRecommendedCameraSettings() {
    var defaults = LabelCaptureDefaults.cameraSettingsDefaults;
    return CameraSettings(
      defaults.preferredResolution,
      defaults.zoomFactor,
      defaults.focusRange,
      defaults.focusGestureStrategy,
      defaults.zoomGestureZoomFactor,
      properties: defaults.properties,
      shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus,
      torchLevel: defaults.torchLevel,
      macroMode: defaults.macroMode,
      adaptiveExposure: defaults.adaptiveExposure,
    );
  }

  /// Instance of [LabelCaptureFeedback] that is used to configure the vibration and sound to be used when a label is captured.
  ///
  /// The default feedback will have both sound and vibration enabled. The default beep sound will be used for the sound feedback.
  ///
  /// Added in version 7.6.0
  LabelCaptureFeedback get feedback => _feedback;

  /// Instance of [LabelCaptureFeedback] that is used to configure the vibration and sound to be used when a label is captured.
  ///
  /// The default feedback will have both sound and vibration enabled. The default beep sound will be used for the sound feedback.
  ///
  /// Added in version 7.6.0
  set feedback(LabelCaptureFeedback newValue) {
    _feedback.removeListener(_onFeedbackChanged);
    _feedback = newValue;
    _controller.updateFeedback(newValue);
    _feedback.addListener(_onFeedbackChanged);
  }

  void _onFeedbackChanged() {
    _controller.updateFeedback(_feedback);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'labelCapture',
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'enabled': _enabled,
      'feedback': _feedback.toMap(),
    };
  }
}

class _LabelCaptureController extends BaseController {
  final LabelCapture _labelCapture;
  StreamSubscription<dynamic>? _labelCaptureSubscription;
  late final LabelMethodHandler labelMethodHandler;

  _LabelCaptureController(this._labelCapture) : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
  }

  @override
  void dispose() {
    unsubscribeListeners();
    super.dispose();
  }

  void subscribeListeners() {
    labelMethodHandler
        .addLabelCaptureListener(modeId: _labelCapture._modeId)
        .then((value) => _setupLabelCaptureSubscription(), onError: onError);
  }

  void _setupLabelCaptureSubscription() {
    _labelCaptureSubscription =
        LabelPluginEvents.labelEventStream.asFlutterEvents().forMode(_labelCapture._modeId).listen((event) async {
      // A different event on this stream owes no ack, so this is the only check that may sit
      // outside the try. A payload with no `session` key at all — exactly what the reject fixtures
      // model — still owes the ack, so it is handled below rather than short-circuited here.
      // (`_listeners.isEmpty` is likewise checked inside: native gates its emit on
      // `emitter.hasListenersForEvent(...)`, which is not the same set.)
      if (!event.isEvent('LabelCaptureListener.didUpdateSession')) return;

      // ACK-owing: native blocks on finishLabelCaptureListenerDidUpdateSession, so a throwing
      // (or schema-rejected) payload must still ack. Do the work in `try`, ack in `finally`.
      try {
        if (_labelCapture._listeners.isEmpty) return;
        final payload = parsePayloadTolerantly<LabelCaptureListenerDidUpdateSession>(
          event.payload,
          (raw) => LabelCaptureListenerDidUpdateSession.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `session` is required and cannot be reconstructed from a missing/invalid value
            // (an empty placeholder would silently report a bogus session), so decline.
            if (map['session'] is! String) return null;
            return LabelCaptureListenerDidUpdateSession(
              session: map['session'] as String,
              frameId: map['frameId'] is String ? map['frameId'] as String : null,
              // The stream is already filtered by `.forMode(_labelCapture._modeId)`, so this
              // mode is a fact rather than a sentinel when the wire value is missing.
              modeId: map['modeId'] is int ? map['modeId'] as int : _labelCapture._modeId,
              event: 'LabelCaptureListener.didUpdateSession',
            );
          },
          'didUpdateSession',
          'LabelCaptureController',
        );
        // Decline: bail out of the try, but the `finally` below still runs the ack.
        if (payload == null) return;
        var session = LabelCaptureSession.fromJSON({'session': payload.session, 'frameId': payload.frameId});
        await _notifyListenersOfDidUpateSession(session);
      } catch (error) {
        developer.log('LabelCaptureController didUpdateSession failed: $error');
      } finally {
        await labelMethodHandler
            .finishLabelCaptureListenerDidUpdateSession(
              modeId: _labelCapture._modeId,
              isEnabled: _labelCapture.isEnabled,
            )
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: onError);
      }
    });
  }

  void setModeEnabledState(bool newValue) {
    labelMethodHandler
        .setLabelCaptureModeEnabledState(modeId: _labelCapture._modeId, isEnabled: newValue)
        .then((value) => null, onError: onError);
  }

  Future<void> updateMode() {
    return labelMethodHandler
        .updateLabelCaptureMode(modeJson: jsonEncode(_labelCapture.toMap()))
        .then((value) => null, onError: onError);
  }

  Future<void> applyNewSettings(LabelCaptureSettings settings) {
    return labelMethodHandler
        .updateLabelCaptureSettings(modeId: _labelCapture._modeId, settingsJson: jsonEncode(settings.toMap()))
        .then((value) => null, onError: onError);
  }

  void unsubscribeListeners() {
    _labelCaptureSubscription?.cancel();
    labelMethodHandler
        .removeLabelCaptureListener(modeId: _labelCapture._modeId)
        .then((value) => null, onError: onError);
  }

  Future<void> _notifyListenersOfDidUpateSession(LabelCaptureSession session) async {
    try {
      // Iterate backwards to avoid allocation and handle concurrent modifications safely
      // This is called frequently so we avoid creating a copy
      for (var i = _labelCapture._listeners.length - 1; i >= 0; i--) {
        if (i < _labelCapture._listeners.length) {
          await _labelCapture._listeners[i].didUpdateSession(_labelCapture, session, () => _getLastFrameData(session));
        }
      }
    } catch (e) {
      onError(e, StackTrace.current);
    }
  }

  Future<FrameData> _getLastFrameData(LabelCaptureSession session) {
    return getCoreMethodHandler()
        .getLastFrameOrNullAsMap(frameId: session.frameId)
        .then((value) => DefaultFrameData.fromJSON(value), onError: onError);
  }

  Future<void> updateFeedback(LabelCaptureFeedback feedback) {
    return labelMethodHandler
        .updateLabelCaptureFeedback(modeId: _labelCapture._modeId, feedbackJson: jsonEncode(feedback.toMap()))
        .then((value) => null, onError: onError);
  }
}
