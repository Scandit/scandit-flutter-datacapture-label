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

  String _missingFieldsHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.missingFieldsHintText;

  @Deprecated('This property is deprecated and will be removed in a future release.')
  String get missingFieldsHintText => _missingFieldsHintText;

  @Deprecated('This property is deprecated and will be removed in a future release.')
  set missingFieldsHintText(String value) => _missingFieldsHintText = value;

  String standbyHintText = LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.standbyHintText;

  String validationHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationHintText;

  String validationErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationErrorText;

  String _requiredFieldErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.requiredFieldErrorText;

  @Deprecated('This property is deprecated and will be removed in a future release.')
  String get requiredFieldErrorText => _requiredFieldErrorText;

  @Deprecated('This property is deprecated and will be removed in a future release.')
  set requiredFieldErrorText(String value) => _requiredFieldErrorText = value;

  String _manualInputButtonText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.manualInputButtonText;

  @Deprecated('This property is deprecated and no longer used.')
  String get manualInputButtonText => _manualInputButtonText;

  @Deprecated('This property is deprecated and no longer used.')
  set manualInputButtonText(String value) => _manualInputButtonText = value;

  final Map<String, String?> _labelDefinitionsPlaceholders = {};

  void setPlaceholderTextForLabelDefinition(String fieldName, String? placeholder) {
    if (placeholder == null) {
      _labelDefinitionsPlaceholders.remove(fieldName);
    } else {
      _labelDefinitionsPlaceholders[fieldName] = placeholder;
    }
  }

  String? getPlaceholderTextForLabelDefinition(String fieldName) {
    return _labelDefinitionsPlaceholders[fieldName];
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'missingFieldsHintText': _missingFieldsHintText,
      'standbyHintText': standbyHintText,
      'validationHintText': validationHintText,
      'validationErrorText': validationErrorText,
      'requiredFieldErrorText': _requiredFieldErrorText,
      'manualInputButtonText': _manualInputButtonText,
    };
    if (_labelDefinitionsPlaceholders.isNotEmpty) {
      map['labelDefinitionsPlaceholders'] = _labelDefinitionsPlaceholders;
    }
    return map;
  }
}
