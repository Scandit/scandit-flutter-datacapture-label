/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// ignore: avoid_classes_with_only_static_members
class LabelCaptureDefaults {
  static MethodChannel channel = const MethodChannel('com.scandit.datacapture.label/method_channel');

  static late CameraSettingsDefaults _cameraSettingsDefaults;
  static late LabelCaptureBasicOverlayDefaults _labelCaptureBasicOverlayDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static LabelCaptureBasicOverlayDefaults get labelCaptureBasicOverlayDefaults => _labelCaptureBasicOverlayDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod('getLabelCaptureDefaults');
    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _labelCaptureBasicOverlayDefaults = LabelCaptureBasicOverlayDefaults.fromJSON(json['LabelCaptureBasicOverlay']);

    _isInitialized = true;
  }
}

@immutable
class LabelCaptureBasicOverlayDefaults {
  final Brush defaultLabelBrush;
  final Brush defaultCapturedFieldBrush;
  final Brush defaultPredictedFieldBrush;

  const LabelCaptureBasicOverlayDefaults(
      this.defaultLabelBrush, this.defaultCapturedFieldBrush, this.defaultPredictedFieldBrush);

  factory LabelCaptureBasicOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    final defaultLabelBrush = BrushDefaults.fromJSON(json['DefaultLabelBrush']).toBrush();
    final defaultCapturedFieldBrush = BrushDefaults.fromJSON(json['DefaultCapturedFieldBrush']).toBrush();
    final defaultPredictedFieldBrush = BrushDefaults.fromJSON(json['DefaultPredictedFieldBrush']).toBrush();
    return LabelCaptureBasicOverlayDefaults(defaultLabelBrush, defaultCapturedFieldBrush, defaultPredictedFieldBrush);
  }
}
