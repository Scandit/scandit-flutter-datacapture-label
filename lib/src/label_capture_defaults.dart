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
  static late LabelCaptureValidationFlowOverlayDefaults _labelCaptureValidationFlowOverlayDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static LabelCaptureBasicOverlayDefaults get labelCaptureBasicOverlayDefaults => _labelCaptureBasicOverlayDefaults;

  static LabelCaptureValidationFlowOverlayDefaults get labelCaptureValidationFlowOverlayDefaults =>
      _labelCaptureValidationFlowOverlayDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    var result = await channel.invokeMethod('getLabelCaptureDefaults');
    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
    _labelCaptureBasicOverlayDefaults = LabelCaptureBasicOverlayDefaults.fromJSON(json['LabelCaptureBasicOverlay']);
    _labelCaptureValidationFlowOverlayDefaults =
        LabelCaptureValidationFlowOverlayDefaults.fromJSON(json['LabelCaptureValidationFlowOverlay']);

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

@immutable
class LabelCaptureValidationFlowOverlayDefaults {
  final LabelCaptureValidationFlowSettingsDefaults settings;

  const LabelCaptureValidationFlowOverlayDefaults(this.settings);

  factory LabelCaptureValidationFlowOverlayDefaults.fromJSON(Map<String, dynamic> json) {
    final settings = LabelCaptureValidationFlowSettingsDefaults.fromJSON(json['Settings']);
    return LabelCaptureValidationFlowOverlayDefaults(settings);
  }
}

@immutable
class LabelCaptureValidationFlowSettingsDefaults {
  final String missingFieldsHintText;
  final String standbyHintText;
  final String validationHintText;
  final String validationErrorText;
  final String requiredFieldErrorText;
  final String manualInputButtonText;

  const LabelCaptureValidationFlowSettingsDefaults(this.missingFieldsHintText, this.standbyHintText,
      this.validationHintText, this.validationErrorText, this.requiredFieldErrorText, this.manualInputButtonText);

  factory LabelCaptureValidationFlowSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final missingFieldsHintText = json['missingFieldsHintText'];
    final standbyHintText = json['standbyHintText'];
    final validationHintText = json['validationHintText'];
    final validationErrorText = json['validationErrorText'];
    final requiredFieldErrorText = json['requiredFieldErrorText'];
    final manualInputButtonText = json['manualInputButtonText'];
    return LabelCaptureValidationFlowSettingsDefaults(missingFieldsHintText, standbyHintText, validationHintText,
        validationErrorText, requiredFieldErrorText, manualInputButtonText);
  }
}
