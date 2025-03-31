/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';

class LabelCaptureSession with _PrivateLabelCaptureSession {
  late List<CapturedLabel> _capturedLabels;
  late int _frameSequenceId;
  late int _lastProcessedFrameId;

  LabelCaptureSession._();

  List<CapturedLabel> get capturedLabels => _capturedLabels;

  int get frameSequenceId => _frameSequenceId;

  int get lastProcessedFrameId => _lastProcessedFrameId;

  factory LabelCaptureSession.fromJSON(Map<String, dynamic> json) {
    final session = LabelCaptureSession._();
    session._frameSequenceId = json['frameSequenceId'];
    session._lastProcessedFrameId = json['lastFrameId'];
    session._capturedLabels =
        (json['labels'] as List).map((label) => CapturedLabel.fromJSON(label, session._frameSequenceId)).toList();

    return session;
  }
}

mixin _PrivateLabelCaptureSession {
  // ignore: prefer_final_fields
  String _frameId = "";

  String get frameId => _frameId;
}
