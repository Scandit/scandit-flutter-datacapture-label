// ignore_for_file: use_function_type_syntax_for_parameters

/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';

abstract class LabelCaptureListener {
  Future<void> didUpdateSession(
    LabelCapture labelCapture,
    LabelCaptureSession session,
    Future<FrameData?> getFrameData(),
  );
}

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

  LabelCapture(LabelCaptureSettings settings) : this._(settings);

  @override
  // ignore: unnecessary_overrides
  DataCaptureContext? get context => super.context;

  @override
  bool get isEnabled => _enabled;

  @override
  set isEnabled(bool newValue) {
    _enabled = newValue;
    _controller.setModeEnabledState(newValue);
  }

  Future<void> applySettings(LabelCaptureSettings settings) {
    _settings = settings;
    return _controller.applyNewSettings(settings);
  }

  void addListener(LabelCaptureListener listener) {
    if (_listeners.isEmpty) {
      _controller.subscribeListeners();
    }
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(LabelCaptureListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _controller.unsubscribeListeners();
    }
  }

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
    );
  }

  LabelCaptureFeedback get feedback => _feedback;

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
      'hasListeners': _listeners.isNotEmpty,
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

  void subscribeListeners() {
    labelMethodHandler
        .addLabelCaptureListener(modeId: _labelCapture._modeId)
        .then((value) => _setupLabelCaptureSubscription(), onError: onError);
  }

  void _setupLabelCaptureSubscription() {
    _labelCaptureSubscription = LabelPluginEvents.labelEventStream.listen((event) {
      if (_labelCapture._listeners.isEmpty) return;

      var payload = jsonDecode(event);

      // Check if this event is for our mode
      if (payload['modeId'] != _labelCapture._modeId) {
        return;
      }

      if (payload['event'] as String != 'LabelCaptureListener.didUpdateSession' || !payload.containsKey('session')) {
        return;
      }

      var session = LabelCaptureSession.fromJSON(jsonDecode(payload['session']));

      _notifyListenersOfDidUpateSession(session).then((value) {
        labelMethodHandler
            .finishLabelCaptureListenerDidUpdateSession(
                modeId: _labelCapture._modeId, isEnabled: _labelCapture.isEnabled)
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: onError);
      });
    });
  }

  void setModeEnabledState(bool newValue) {
    labelMethodHandler
        .setLabelCaptureModeEnabledState(modeId: _labelCapture._modeId, isEnabled: newValue)
        .then((value) => null, onError: onError);
  }

  Future<void> updateMode() {
    return labelMethodHandler
        .updateLabelCaptureMode(modeJson: _labelCapture.toMap())
        .then((value) => null, onError: onError);
  }

  Future<void> applyNewSettings(LabelCaptureSettings settings) {
    return labelMethodHandler
        .updateLabelCaptureSettings(modeId: _labelCapture._modeId, settingsJson: settings.toMap())
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
