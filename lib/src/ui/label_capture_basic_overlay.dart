/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';

abstract class LabelCaptureBasicOverlayListener {
  Future<Brush?> brushForFieldOfLabel(LabelCaptureBasicOverlay overlay, LabelField field, CapturedLabel label);
  Future<Brush?> brushForLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label);
  void didTapLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label);
}

class LabelCaptureBasicOverlay extends DataCaptureOverlay {
  static Brush get defaultPredictedFieldBrush =>
      LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultPredictedFieldBrush;

  static Brush get defaultCapturedFieldBrush =>
      LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultCapturedFieldBrush;

  static Brush get defaultLabelBrush => LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultLabelBrush;

  late final _LabelCaptureBasicOverlayController _controller;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureBasicOverlay._() : super('labelCaptureBasic') {
    _controller = _LabelCaptureBasicOverlayController(this);
  }

  factory LabelCaptureBasicOverlay.withLabelCapture(LabelCapture labelCapture, {DataCaptureView? view}) {
    final overlay = LabelCaptureBasicOverlay._()..view = view;
    if (view != null) {
      view.addOverlay(overlay);
    }
    return overlay;
  }

  @override
  DataCaptureView? view;

  Brush? _predictedFieldBrush;
  Brush? get predictedFieldBrush => _predictedFieldBrush;
  set predictedFieldBrush(Brush? newBrush) {
    _predictedFieldBrush = newBrush;
    _controller.updateBasicOverlay();
  }

  Brush? _capturedFieldBrush;
  Brush? get capturedFieldBrush => _capturedFieldBrush;
  set capturedFieldBrush(Brush? newBrush) {
    _capturedFieldBrush = newBrush;
    _controller.updateBasicOverlay();
  }

  Brush? _labelBrush;
  Brush? get labelBrush => _labelBrush;
  set labelBrush(Brush? newBrush) {
    _labelBrush = newBrush;
    _controller.updateBasicOverlay();
  }

  bool _shouldShowScanAreaGuides = false;
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;
  set shouldShowScanAreaGuides(bool shouldShow) {
    _shouldShowScanAreaGuides = shouldShow;
    _controller.updateBasicOverlay();
  }

  Viewfinder? _viewfinder;
  Viewfinder? get viewfinder => _viewfinder;
  set viewfinder(Viewfinder? newViewfinder) {
    _viewfinder = newViewfinder;
    _controller.updateBasicOverlay();
  }

  Future<void> setBrushForFieldOfLabel(Brush? brush, LabelField field, CapturedLabel label) {
    final fieldId = '${label.trackingId}§${field.name}';
    return _controller.setBrushForFieldOfLabel(brush, fieldId);
  }

  Future<void> setBrushForLabel(Brush? brush, CapturedLabel label) {
    return _controller.setBrushForLabel(brush, label);
  }

  LabelCaptureBasicOverlayListener? _listener;

  LabelCaptureBasicOverlayListener? get listener => _listener;

  set listener(LabelCaptureBasicOverlayListener? newValue) {
    _controller.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller.subscribeListener();
    }

    _listener = newValue;
  }

  @override
  Map<String, dynamic> toMap() {
    final json = super.toMap();
    json['viewfinder'] = viewfinder?.toMap();
    json['fieldBrushes'] = {
      'captured': capturedFieldBrush?.toMap(),
      'predicted': predictedFieldBrush?.toMap(),
    };
    json['labelBrush'] = labelBrush?.toMap();
    json['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    json['hasListener'] = _listener != null;
    return json;
  }
}

class _LabelCaptureBasicOverlayController {
  final MethodChannel _methodChannel = const MethodChannel('com.scandit.datacapture.label/method_channel');

  StreamSubscription<dynamic>? _overlaySubscription;

  _LabelCaptureBasicOverlayController(this.overlay);

  final LabelCaptureBasicOverlay overlay;

  void subscribeListener() {
    _methodChannel.invokeMethod('addLabelCaptureBasicOverlayListener', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => _listenToEvents(), onError: _onError);
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _methodChannel.invokeMethod('removeLabelCaptureBasicOverlayListener', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
    }).then((value) => null, onError: _onError);
  }

  void _listenToEvents() {
    _overlaySubscription = LabelPluginEvents.labelEventStream.listen((event) async {
      if (overlay._listener == null) return;
      final json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case 'LabelCaptureBasicOverlayListener.brushForLabel':
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          var brush = await overlay._listener?.brushForLabel(overlay, capturedLabel);
          if (brush == null) {
            break;
          }
          await _methodChannel.invokeMethod(
              'setLabelCaptureBasicOverlayBrushForLabel',
              jsonEncode({
                'brush': jsonEncode(brush.toMap()),
                'identifier': capturedLabel.trackingId,
                'dataCaptureViewId': overlay._dataCaptureViewId,
              }));
          break;
        case 'LabelCaptureBasicOverlayListener.brushForFieldOfLabel':
          var labelField = LabelField.fromJSON(jsonDecode(json['field']));
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          var brush = await overlay._listener?.brushForFieldOfLabel(overlay, labelField, capturedLabel);
          if (brush == null) {
            break;
          }
          final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
          await _methodChannel.invokeMethod(
              'setLabelCaptureBasicOverlayBrushForFieldOfLabel',
              jsonEncode({
                'brush': jsonEncode(brush.toMap()),
                'identifier': labelFieldId,
                'dataCaptureViewId': overlay._dataCaptureViewId,
              }));
          break;
        case 'LabelCaptureBasicOverlayListener.didTapLabel':
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          overlay._listener?.didTapLabel(overlay, capturedLabel);
          break;
      }
    });
  }

  Future<void> updateBasicOverlay() {
    return _methodChannel.invokeMethod('updateLabelCaptureBasicOverlay', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
      'basicOverlayJson': jsonEncode(overlay.toMap())
    }).then((value) => null, onError: _onError);
  }

  Future<void> setBrushForFieldOfLabel(Brush? brush, String fieldId) {
    return _methodChannel.invokeMethod(
        'setLabelCaptureBasicOverlayBrushForFieldOfLabel',
        jsonEncode({
          'brush': brush != null ? jsonEncode(brush.toMap()) : null,
          'identifier': fieldId,
          'dataCaptureViewId': overlay._dataCaptureViewId,
        }));
  }

  Future<void> setBrushForLabel(Brush? brush, CapturedLabel label) {
    return _methodChannel.invokeMethod(
        'setLabelCaptureBasicOverlayBrushForLabel',
        jsonEncode({
          'brush': brush != null ? jsonEncode(brush.toMap()) : null,
          'identifier': label.trackingId,
          'dataCaptureViewId': overlay._dataCaptureViewId,
        }));
  }

  void _onError(Object? error, StackTrace? stackTrace) {
    if (error == null) return;
    throw error;
  }
}
