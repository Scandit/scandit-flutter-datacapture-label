/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

class LabelCaptureValidationFlowSettings implements Serializable {
  LabelCaptureValidationFlowSettings._();

  factory LabelCaptureValidationFlowSettings.create() {
    return LabelCaptureValidationFlowSettings._();
  }

  String missingFieldsHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.missingFieldsHintText;

  String standbyHintText = LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.standbyHintText;

  String validationHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationHintText;

  String validationErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationErrorText;

  String requiredFieldErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.requiredFieldErrorText;

  String manualInputButtonText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.manualInputButtonText;

  @override
  Map<String, dynamic> toMap() {
    return {
      'missingFieldsHintText': missingFieldsHintText,
      'standbyHintText': standbyHintText,
      'validationHintText': validationHintText,
      'validationErrorText': validationErrorText,
      'requiredFieldErrorText': requiredFieldErrorText,
      'manualInputButtonText': manualInputButtonText,
    };
  }
}
