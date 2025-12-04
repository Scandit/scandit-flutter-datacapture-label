/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_validation_flow_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';

abstract class LabelCaptureValidationFlowListener {
  void didCaptureLabelWithFields(List<LabelField> fields);
}

class LabelCaptureValidationFlowOverlay extends DataCaptureOverlay {
  late final _LabelCaptureValidationFlowOverlayController _controller;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureValidationFlowSettings? _settings;

  LabelCaptureValidationFlowOverlay._() : super('validationFlow') {
    _controller = _LabelCaptureValidationFlowOverlayController(this);
  }

  factory LabelCaptureValidationFlowOverlay.withLabelCapture(LabelCapture labelCapture, {DataCaptureView? view}) {
    final overlay = LabelCaptureValidationFlowOverlay._()..view = view;
    if (view != null) {
      view.addOverlay(overlay);
    }
    return overlay;
  }

  @override
  DataCaptureView? view;

  LabelCaptureValidationFlowListener? _listener;

  LabelCaptureValidationFlowListener? get listener => _listener;

  set listener(LabelCaptureValidationFlowListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> applySettings(LabelCaptureValidationFlowSettings settings) {
    _settings = settings;
    return _controller.updateValidationFlowOverlay();
  }

  @override
  Map<String, dynamic> toMap() {
    final json = super.toMap();
    json['hasListener'] = listener != null;
    json['settings'] = _settings?.toMap();
    return json;
  }
}

class _LabelCaptureValidationFlowOverlayController {
  final MethodChannel _methodChannel = const MethodChannel('com.scandit.datacapture.label/method_channel');

  StreamSubscription<dynamic>? _overlaySubscription;

  _LabelCaptureValidationFlowOverlayController(this.overlay);

  final LabelCaptureValidationFlowOverlay overlay;

  void subscribeListener() {
    _methodChannel.invokeMethod('registerListenerForValidationFlowEvents', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => _listenToEvents(), onError: _onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _methodChannel.invokeMethod('unregisterListenerForValidationFlowEvents', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => null, onError: _onError);
  }

  void _listenToEvents() {
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
    return _methodChannel.invokeMethod('updateLabelCaptureValidationFlowOverlay', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
      'overlayJson': jsonEncode(overlay.toMap())
    }).then((value) => null, onError: _onError);
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
