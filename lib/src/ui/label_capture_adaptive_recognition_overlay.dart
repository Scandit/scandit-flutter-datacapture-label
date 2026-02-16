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
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_adaptive_recognition_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/receipt_scanning_result.dart';

abstract class LabelCaptureAdaptiveRecognitionListener {
  void didRecognize(AdaptiveRecognitionResult result);
  void didFail();
}

class LabelCaptureAdaptiveRecognitionOverlay extends DataCaptureOverlay {
  _LabelCaptureAdaptiveRecognitionOverlayController? _controller;

  DataCaptureView? _view;

  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureAdaptiveRecognitionSettings? _settings;

  LabelCaptureAdaptiveRecognitionOverlay._(this._mode) : super('receiptScanning');

  LabelCaptureAdaptiveRecognitionOverlay(LabelCapture mode) : this._(mode);

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
    _controller ??= _LabelCaptureAdaptiveRecognitionOverlayController(this);
  }

  LabelCaptureAdaptiveRecognitionListener? _listener;

  LabelCaptureAdaptiveRecognitionListener? get listener => _listener;

  set listener(LabelCaptureAdaptiveRecognitionListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  Future<void> applySettings(LabelCaptureAdaptiveRecognitionSettings settings) {
    _settings = settings;
    return _controller?.applyAdaptiveRecognitionSettings() ?? Future.value();
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

class _LabelCaptureAdaptiveRecognitionOverlayController extends BaseController {
  StreamSubscription<dynamic>? _overlaySubscription;
  late final LabelMethodHandler labelMethodHandler;

  final LabelCaptureAdaptiveRecognitionOverlay overlay;

  _LabelCaptureAdaptiveRecognitionOverlayController(this.overlay)
      : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
    initialize();
  }

  void initialize() {
    if (overlay._listener != null) {
      subscribeListener();
    }
  }

  void subscribeListener() {
    labelMethodHandler
        .registerListenerForAdaptiveRecognitionOverlayEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _overlaySubscription = null;
    labelMethodHandler
        .unregisterListenerForAdaptiveRecognitionOverlayEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => null, onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.listen((event) async {
      if (overlay._listener == null) return;
      final json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case 'LabelCaptureAdaptiveRecognitionListener.recognized':
          final resultJson = json['result'] as Map<String, dynamic>;
          final result = ReceiptScanningResult.fromJSON(resultJson);
          overlay._listener?.didRecognize(result);
          break;
        case 'LabelCaptureAdaptiveRecognitionListener.failure':
          overlay._listener?.didFail();
          break;
      }
    });
  }

  Future<void> applyAdaptiveRecognitionSettings() {
    return labelMethodHandler
        .applyLabelCaptureAdaptiveRecognitionSettings(
            dataCaptureViewId: overlay._dataCaptureViewId, overlayJson: jsonEncode(overlay.toMap()))
        .then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
