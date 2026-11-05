/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

/// Added in version 7.5.0
class LabelCaptureValidationFlowSettings implements Serializable {
  /// Creates a Label Capture Validation Flow Settings object with default values.
  ///
  /// Added in version 7.5.0
  LabelCaptureValidationFlowSettings();

  factory LabelCaptureValidationFlowSettings.create() {
    return LabelCaptureValidationFlowSettings();
  }

  String _missingFieldsHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.missingFieldsHintText;

  /// The text in the hint that is shown to the user when an attempt is made to validate a label while there are still empty fields where [LabelField.isRequired] is *true*.
  ///
  /// Defaults to “Please fill in missing fields”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and will be removed in a future release.')
  String get missingFieldsHintText => _missingFieldsHintText;

  /// The text in the hint that is shown to the user when an attempt is made to validate a label while there are still empty fields where [LabelField.isRequired] is *true*.
  ///
  /// Defaults to “Please fill in missing fields”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and will be removed in a future release.')
  set missingFieldsHintText(String value) => _missingFieldsHintText = value;

  /// The text in the hint that is shown to the user when more than 10 seconds have passed during a scanning phase with no scan made, and the flow is paused until further user interaction.
  ///
  /// Defaults to “Scanning paused to conserve battery”.
  ///
  /// Added in version 7.5.0
  String standbyHintText = LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.standbyHintText;

  /// The text in the hint that is shown to the user when a scanning phase has finished. It informs them of how many fields have been successfully scanned so far
  ///
  /// Defaults to “X/Y label fields captured”, where X and Y are the number of captured and expected fields respectively.
  ///
  /// Added in version 7.5.0
  String validationHintText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationHintText;

  /// The text shown below a field that holds an invalid value. This may happen due to either a bad scan or an incorrect manual input.
  ///
  /// Defaults to “Invalid input”.
  ///
  /// Added in version 7.5.0
  String validationErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.validationErrorText;

  String _requiredFieldErrorText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.requiredFieldErrorText;

  /// The text shown below an empty, required field when an attempt to finalize the validation flow has been made.
  ///
  /// Defaults to “This field is required”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and will be removed in a future release.')
  String get requiredFieldErrorText => _requiredFieldErrorText;

  /// The text shown below an empty, required field when an attempt to finalize the validation flow has been made.
  ///
  /// Defaults to “This field is required”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and will be removed in a future release.')
  set requiredFieldErrorText(String value) => _requiredFieldErrorText = value;

  String _manualInputButtonText =
      LabelCaptureDefaults.labelCaptureValidationFlowOverlayDefaults.settings.manualInputButtonText;

  /// The text shown in the button that allows the user to start the flow by inputting values manually for the label fields.
  ///
  /// Defaults to “Input Manually”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and no longer used.')
  String get manualInputButtonText => _manualInputButtonText;

  /// The text shown in the button that allows the user to start the flow by inputting values manually for the label fields.
  ///
  /// Defaults to “Input Manually”.
  ///
  /// Added in version 7.5.0
  @Deprecated('This property is deprecated and no longer used.')
  set manualInputButtonText(String value) => _manualInputButtonText = value;

  /// The text shown in the finish button that allows the user to complete the validation flow when all required fields are filled.
  ///
  /// Defaults to “Finish”.
  ///
  /// Added in version 8.3.0
  String finishButtonText = LabelCaptureValidationFlowSettingsDefaults.defaultValidationFinishButtonText;

  /// The text shown in the restart button that allows the user to clear all fields and restart the validation flow.
  ///
  /// Defaults to “Clear All”.
  ///
  /// Added in version 8.3.0
  String restartButtonText = LabelCaptureValidationFlowSettingsDefaults.defaultValidationRestartButtonText;

  /// The text shown in the pause button that allows the user to pause the scanning process during the validation flow.
  ///
  /// Defaults to “Pause”.
  ///
  /// Added in version 8.3.0
  String pauseButtonText = LabelCaptureValidationFlowSettingsDefaults.defaultValidationPauseButtonText;

  /// The text shown as a placeholder in text fields during the active scanning phase.
  ///
  /// Defaults to “Scanning”.
  ///
  /// Added in version 8.3.0
  String scanningText = LabelCaptureValidationFlowSettingsDefaults.defaultValidationScanningText;

  /// The text shown as a placeholder in text fields when adaptive scanning is active.
  ///
  /// Defaults to “Processing, tap to type manually”.
  ///
  /// Added in version 8.3.0
  String adaptiveScanningText = LabelCaptureValidationFlowSettingsDefaults.defaultValidationAdaptiveScanningText;

  final Map<String, String?> _labelDefinitionsPlaceholders = {};

  /// Sets the placeholder text for a specific label definition field.
  ///
  /// Added in version 8.2.0
  void setPlaceholderTextForLabelDefinition(String fieldName, String? placeholder) {
    if (placeholder == null) {
      _labelDefinitionsPlaceholders.remove(fieldName);
    } else {
      _labelDefinitionsPlaceholders[fieldName] = placeholder;
    }
  }

  /// Gets the placeholder text for a specific label definition field.
  ///
  /// Added in version 8.2.0
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
      'finishButtonText': finishButtonText,
      'restartButtonText': restartButtonText,
      'pauseButtonText': pauseButtonText,
      'scanningText': scanningText,
      'adaptiveScanningText': adaptiveScanningText,
      'validationFinishButtonText': finishButtonText,
      'validationRestartButtonText': restartButtonText,
      'validationPauseButtonText': pauseButtonText,
      'validationAdaptiveScanningText': adaptiveScanningText,
      'validationScanningText': scanningText,
    };
    if (_labelDefinitionsPlaceholders.isNotEmpty) {
      map['labelDefinitionsPlaceholders'] = _labelDefinitionsPlaceholders;
    }
    return map;
  }
}
