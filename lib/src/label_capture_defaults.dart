/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import 'generated/label_generated_defaults.dart';

// Picks the platform-split value of a generated default. Kept private: a
// small per-package helper, mirroring core's and id's, so this package
// doesn't need a cross-package dependency just for this.
T _platformDefault<T>({required T android, required T ios}) => Platform.isIOS ? ios : android;

// Builds a Brush from a generated flat {fillColor, strokeColor, strokeWidth}
// default literal - the shape the wrappers actually emit - matching the native
// getDefaults() snapshot at
// scripts/defaults_generator/defaults/generated/expected_defaults_*.json.
Brush _buildStaticBrush(Map<String, Object?> json) {
  final fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String? ?? '#00000000');
  final strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String? ?? '#00000000');
  final strokeWidth = (json['strokeWidth'] as num?)?.toDouble() ?? 0.0;
  return Brush(fillColor, strokeColor, strokeWidth);
}

// Builds a Feedback from a generated {vibration, sound} default literal.
Feedback _buildStaticFeedback(Map<String, Object?> json) {
  final vibrationJson = json['vibration'] as Map<String, Object?>?;
  final soundJson = json['sound'] as Map<String, Object?>?;

  Vibration? vibration;
  if (vibrationJson != null) {
    switch (vibrationJson['type']) {
      case 'selectionHaptic':
        vibration = Vibration.selectionHapticFeedback;
        break;
      case 'successHaptic':
        vibration = Vibration.successHapticFeedback;
        break;
      default:
        vibration = Vibration.defaultVibration;
    }
  }

  Sound? sound;
  if (soundJson != null) {
    sound = soundJson.containsKey('resource') ? Sound(soundJson['resource'] as String?) : Sound(null);
  }

  return Feedback(vibration, sound);
}

LabelCaptureBasicOverlayDefaults _buildStaticLabelCaptureBasicOverlayDefaults() {
  return LabelCaptureBasicOverlayDefaults(
    // Colours are platform-split: the Android wrapper rounds native's float
    // channels half-up while iOS truncates, so e.g. gray(0.7f) is #B3 vs #B2.
    // See label.json for the full note.
    _buildStaticBrush(_platformDefault(
      android: LabelCaptureBasicOverlayGeneratedDefaults.DefaultLabelBrushAndroid,
      ios: LabelCaptureBasicOverlayGeneratedDefaults.DefaultLabelBrushIos,
    )),
    _buildStaticBrush(_platformDefault(
      android: LabelCaptureBasicOverlayGeneratedDefaults.DefaultCapturedFieldBrushAndroid,
      ios: LabelCaptureBasicOverlayGeneratedDefaults.DefaultCapturedFieldBrushIos,
    )),
    _buildStaticBrush(_platformDefault(
      android: LabelCaptureBasicOverlayGeneratedDefaults.DefaultPredictedFieldBrushAndroid,
      ios: LabelCaptureBasicOverlayGeneratedDefaults.DefaultPredictedFieldBrushIos,
    )),
  );
}

LabelCaptureFeedbackDefaults _buildStaticLabelCaptureFeedbackDefaults() {
  final success = _platformDefault(
    android: FeedbackGeneratedDefaults.successAndroid,
    ios: FeedbackGeneratedDefaults.successIos,
  );
  return LabelCaptureFeedbackDefaults(_buildStaticFeedback(success));
}

// ignore: avoid_classes_with_only_static_members
class LabelCaptureDefaults {
  // Expose channel for testing
  static MethodChannel channel = const LoggingMethodChannel('com.scandit.datacapture.label/method_channel');

  // Statically sourced from generated/label_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately,
  // no method-channel round trip needed. See SDC-32174.
  static final LabelCaptureBasicOverlayDefaults _labelCaptureBasicOverlayDefaults =
      _buildStaticLabelCaptureBasicOverlayDefaults();
  static final LabelCaptureFeedbackDefaults _labelCaptureFeedbackDefaults = _buildStaticLabelCaptureFeedbackDefaults();

  // RecommendedCameraSettings is intentionally NOT staticized (native can't
  // be proven to emit the hardcoded Android wrapper values - see id package
  // for the full rationale) and LabelCaptureValidationFlowOverlay is
  // fully dynamic locale-dependent text, never in the generated consts.
  // Both stay fully dynamic.
  static late CameraSettingsDefaults _cameraSettingsDefaults;
  static late LabelCaptureValidationFlowOverlayDefaults _labelCaptureValidationFlowOverlayDefaults;

  static CameraSettingsDefaults get cameraSettingsDefaults => _cameraSettingsDefaults;

  static LabelCaptureBasicOverlayDefaults get labelCaptureBasicOverlayDefaults => _labelCaptureBasicOverlayDefaults;

  static LabelCaptureValidationFlowOverlayDefaults get labelCaptureValidationFlowOverlayDefaults =>
      _labelCaptureValidationFlowOverlayDefaults;

  static LabelCaptureFeedbackDefaults get labelCaptureFeedbackDefaults => _labelCaptureFeedbackDefaults;

  static bool _isInitialized = false;

  static Future<void> initializeDefaults() async {
    if (_isInitialized) return;
    // Narrow endpoint: only RecommendedCameraSettings and
    // LabelCaptureValidationFlowOverlay, the residual keys read below.
    // It is the only defaults endpoint - the full-blob getDefaults was removed
    // in SDC-32178 - and a direct method call (not routed through executeLabel).
    var result = await channel.invokeMethod('getDynamicDefaults');

    var json = jsonDecode(result as String);
    _cameraSettingsDefaults = CameraSettingsDefaults.fromJSON(json['RecommendedCameraSettings']);
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
  final String validationFinishButtonText;
  final String validationRestartButtonText;
  final String validationPauseButtonText;
  final String validationAdaptiveScanningText;
  final String validationScanningText;

  const LabelCaptureValidationFlowSettingsDefaults(
      this.missingFieldsHintText,
      this.standbyHintText,
      this.validationHintText,
      this.validationErrorText,
      this.requiredFieldErrorText,
      this.manualInputButtonText,
      this.validationFinishButtonText,
      this.validationRestartButtonText,
      this.validationPauseButtonText,
      this.validationAdaptiveScanningText,
      this.validationScanningText);

  factory LabelCaptureValidationFlowSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    final missingFieldsHintText = json['missingFieldsHintText'];
    final standbyHintText = json['standbyHintText'];
    final validationHintText = json['validationHintText'];
    final validationErrorText = json['validationErrorText'];
    final requiredFieldErrorText = json['requiredFieldErrorText'];
    final manualInputButtonText = json['manualInputButtonText'];
    final validationFinishButtonText = json['validationFinishButtonText'];
    final validationRestartButtonText = json['validationRestartButtonText'];
    final validationPauseButtonText = json['validationPauseButtonText'];
    final validationAdaptiveScanningText = json['validationAdaptiveScanningText'];
    final validationScanningText = json['validationScanningText'];
    return LabelCaptureValidationFlowSettingsDefaults(
        missingFieldsHintText,
        standbyHintText,
        validationHintText,
        validationErrorText,
        requiredFieldErrorText,
        manualInputButtonText,
        validationFinishButtonText,
        validationRestartButtonText,
        validationPauseButtonText,
        validationAdaptiveScanningText,
        validationScanningText);
  }

  static String get defaultValidationFinishButtonText => _instance.validationFinishButtonText;
  static String get defaultValidationRestartButtonText => _instance.validationRestartButtonText;
  static String get defaultValidationPauseButtonText => _instance.validationPauseButtonText;
  static String get defaultValidationAdaptiveScanningText => _instance.validationAdaptiveScanningText;
  static String get defaultValidationScanningText => _instance.validationScanningText;

  static LabelCaptureValidationFlowSettingsDefaults get _instance =>
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings;
}

@immutable
class LabelCaptureFeedbackDefaults {
  final Feedback success;

  const LabelCaptureFeedbackDefaults(this.success);

  factory LabelCaptureFeedbackDefaults.fromJSON(Map<String, dynamic> json) {
    return LabelCaptureFeedbackDefaults(
      feedbackFromJson(json, 'success'),
    );
  }

  static Feedback feedbackFromJson(Map<String, dynamic> json, String key) {
    var feedbackJson = json[key];

    Sound? feedbackSound;
    Vibration? feedbackVibration;

    if (feedbackJson.containsKey('sound')) {
      var soundMap = feedbackJson['sound'] as Map;
      if (soundMap.isNotEmpty && soundMap.containsKey('resource')) {
        feedbackSound = Sound(soundMap['resource']);
      } else {
        feedbackSound = Sound(null);
      }
    }
    if (feedbackJson.containsKey('vibration')) {
      var vibrationMap = feedbackJson['vibration'] as Map;
      if (vibrationMap.isNotEmpty && vibrationMap.containsKey('type')) {
        var vibrationType = vibrationMap['type'];
        switch (vibrationType) {
          case 'selectionHaptic':
            feedbackVibration = Vibration.selectionHapticFeedback;
            break;
          case 'successHaptic':
            feedbackVibration = Vibration.successHapticFeedback;
            break;
          default:
            feedbackVibration = Vibration.defaultVibration;
        }
      } else {
        feedbackVibration = Vibration.defaultVibration;
      }
    }
    return Feedback(feedbackVibration, feedbackSound);
  }
}
