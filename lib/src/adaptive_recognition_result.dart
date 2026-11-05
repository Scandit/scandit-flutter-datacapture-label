/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result_type.dart';

/// Base class for all adaptive recognition results. Provides common functionality for all result types.
///
/// Added in version 8.2.0
abstract class AdaptiveRecognitionResult {
  /// The type of the result object.
  ///
  /// Added in version 8.2.0
  AdaptiveRecognitionResultType get resultType;
}
