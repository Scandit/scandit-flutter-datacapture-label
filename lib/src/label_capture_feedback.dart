/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

/// Determines what feedback (vibration, sound) should be emitted when capturing labels. The feedback is specified for each [LabelCapture] instance separately and can be changed through the [LabelCapture.feedback] property by either modifying an existing instance of this class, or by assigning a new one.
///
/// As of now, this class only allows to configure the feedback that gets emitted when a label is captured successfully, through the [LabelCaptureFeedback.success] property.
///
/// See documentation on the [LabelCapture.feedback] property for usage samples.
///
/// Added in version 7.6.0
class LabelCaptureFeedback extends ChangeNotifier implements Serializable {
  Feedback _success = LabelCaptureDefaults.labelCaptureFeedbackDefaults.success;

  /// Constructs a new label capture feedback with default configuration.
  ///
  /// Added in version 7.6.0
  LabelCaptureFeedback({Feedback? success}) {
    if (success != null) {
      _success = success;
    }
  }

  /// A [Feedback] for a success event.
  ///
  /// Added in version 7.6.0
  Feedback get success => _success;

  /// A [Feedback] for a success event.
  ///
  /// Added in version 7.6.0
  set success(Feedback newValue) {
    _success = newValue;
    notifyListeners();
  }

  /// Returns a label capture feedback with default configuration:
  ///
  /// - default beep sound is loaded,
  /// - beeping for the success event is enabled,
  /// - vibration for the success event is enabled.
  ///
  /// Added in version 7.6.0
  static LabelCaptureFeedback get defaultFeedback {
    return LabelCaptureFeedback();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'success': success.toMap(),
    };
  }
}
