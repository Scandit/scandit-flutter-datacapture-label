/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result_type.dart';

class LabelCaptureAdaptiveRecognitionSettings implements Serializable {
  final AdaptiveRecognitionResultType _resultType;

  String processingHintText = '';

  LabelCaptureAdaptiveRecognitionSettings._(this._resultType);

  factory LabelCaptureAdaptiveRecognitionSettings.create(AdaptiveRecognitionResultType resultType) {
    return LabelCaptureAdaptiveRecognitionSettings._(resultType);
  }

  AdaptiveRecognitionResultType get resultType => _resultType;

  @override
  Map<String, dynamic> toMap() {
    return {
      'resultType': resultType.toString(),
      'processingHintText': processingHintText,
    };
  }
}
