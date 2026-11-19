/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

class LabelCaptureFeedback extends ChangeNotifier implements Serializable {
  Feedback _success = LabelCaptureDefaults.labelCaptureFeedbackDefaults.success;

  LabelCaptureFeedback({Feedback? success}) {
    if (success != null) {
      _success = success;
    }
  }

  Feedback get success => _success;

  set success(Feedback newValue) {
    _success = newValue;
    notifyListeners();
  }

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
