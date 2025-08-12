// ignore_for_file: use_function_type_syntax_for_parameters

/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';

abstract class LabelCaptureListener {
  Future<void> didUpdateSession(
      LabelCapture labelCapture, LabelCaptureSession session, Future<FrameData?> getFrameData());
}

class LabelCapture extends DataCaptureMode {
  final List<LabelCaptureListener> _listeners = [];
  bool _enabled = true;
  final DataCaptureContext _context;
  LabelCaptureSettings _settings;
  late _LabelCaptureController _controller;

  final _modeId = Random().nextInt(0x7FFFFFFF);

  LabelCapture._(this._context, this._settings) {
    _controller = _LabelCaptureController.forLabelCapture(this);
    _context.addMode(this);
  }

  factory LabelCapture.forContext(DataCaptureContext context, LabelCaptureSettings settings) {
    return LabelCapture._(context, settings);
  }

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

  static CameraSettings get recommendedCameraSettings {
    var defaults = LabelCaptureDefaults.cameraSettingsDefaults;
    return CameraSettings(defaults.preferredResolution, defaults.zoomFactor, defaults.focusRange,
        defaults.focusGestureStrategy, defaults.zoomGestureZoomFactor,
        properties: defaults.properties, shouldPreferSmoothAutoFocus: defaults.shouldPreferSmoothAutoFocus);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'labelCapture',
      'settings': _settings.toMap(),
      'modeId': _modeId,
      'hasListeners': _listeners.isNotEmpty,
      'enabled': _enabled,
    };
  }
}

class _LabelCaptureController {
  final MethodChannel _methodChannel = const MethodChannel('com.scandit.datacapture.label/method_channel');

  final LabelCapture _labelCapture;
  StreamSubscription<dynamic>? _labelCaptureSubscription;

  _LabelCaptureController.forLabelCapture(this._labelCapture);

  void subscribeListeners() {
    _methodChannel.invokeMethod('addLabelCaptureListener', {'modeId': _labelCapture._modeId}).then(
        (value) => _setupLabelCaptureSubscription(),
        onError: _onError);
  }

  void _setupLabelCaptureSubscription() {
    _labelCaptureSubscription = LabelPluginEvents.labelEventStream.listen((event) {
      if (_labelCapture._listeners.isEmpty) return;

      var payload = jsonDecode(event);
      if (payload['event'] as String != 'LabelCaptureListener.didUpdateSession' || !payload.containsKey('session')) {
        return;
      }

      var session = LabelCaptureSession.fromJSON(jsonDecode(payload['session']));

      _notifyListenersOfDidUpateSession(session).then((value) {
        _methodChannel
            .invokeMethod('finishLabelCaptureListenerDidUpdateSession', {"isEnabled": _labelCapture.isEnabled})
            // ignore: unnecessary_lambdas
            .then((value) => null, onError: (error) => developer.log(error.toString()));
      });
    });
  }

  void setModeEnabledState(bool newValue) {
    final args = {
      'modeId': _labelCapture._modeId,
      'enabled': newValue,
    };
    _methodChannel.invokeMethod('setLabelCaptureModeEnabledState', args).then((value) => null, onError: _onError);
  }

  Future<void> updateMode() {
    return _methodChannel.invokeMethod('updateLabelCaptureMode', {
      'modeId': _labelCapture._modeId,
      'modeJson': jsonEncode(_labelCapture.toMap())
    }).then((value) => null, onError: _onError);
  }

  Future<void> applyNewSettings(LabelCaptureSettings settings) {
    final args = {
      'modeId': _labelCapture._modeId,
      'settings': jsonEncode(settings.toMap()),
    };
    return _methodChannel.invokeMethod('applyLabelCaptureModeSettings', args).then((value) => null, onError: _onError);
  }

  void unsubscribeListeners() {
    _labelCaptureSubscription?.cancel();
    _methodChannel.invokeMethod('removeLabelCaptureListener', {
      'modeId': _labelCapture._modeId,
    }).then((value) => null, onError: _onError);
  }

  Future<void> _notifyListenersOfDidUpateSession(LabelCaptureSession session) async {
    for (var listener in _labelCapture._listeners) {
      await listener.didUpdateSession(_labelCapture, session, () => _getLastFrameData(session));
    }
  }

  Future<FrameData> _getLastFrameData(LabelCaptureSession session) {
    return _methodChannel
        .invokeMethod('getLastFrameData', session.frameId)
        .then((value) => DefaultFrameData.fromJSON(Map<String, dynamic>.from(value as Map)), onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
