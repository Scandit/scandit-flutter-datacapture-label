/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result_type.dart';

/// Settings to customize the adaptive recognition receipt scanning UI. These settings are applied to [LabelCaptureAdaptiveRecognitionOverlay] using [LabelCaptureAdaptiveRecognitionOverlay.applySettings].
///
/// Added in version 8.2.0
class LabelCaptureAdaptiveRecognitionSettings implements Serializable {
  final AdaptiveRecognitionResultType _resultType;

  // Unassigned stays null so the key is omitted and native keeps its own
  // default. An explicitly assigned '' is still sent.
  String? _processingHintText;

  /// Hint text displayed while the overlay is processing captured data.
  ///
  /// Added in version 8.2.0
  String get processingHintText => _processingHintText ?? '';

  /// Hint text displayed while the overlay is processing captured data.
  ///
  /// Added in version 8.2.0
  set processingHintText(String value) => _processingHintText = value;

  LabelCaptureAdaptiveRecognitionSettings._(this._resultType);

  /// Creates a new instance with the specified result type.
  ///
  /// Param resultTypeThe type of document to search for.
  ///
  /// Added in version 8.2.0
  factory LabelCaptureAdaptiveRecognitionSettings.create(AdaptiveRecognitionResultType resultType) {
    return LabelCaptureAdaptiveRecognitionSettings._(resultType);
  }

  /// Type of the document to search for.
  ///
  /// Added in version 8.2.0
  AdaptiveRecognitionResultType get resultType => _resultType;

  @override
  Map<String, dynamic> toMap() {
    return {
      'resultType': resultType.toString(),
      if (_processingHintText != null) 'processingHint': _processingHintText,
    };
  }
}
