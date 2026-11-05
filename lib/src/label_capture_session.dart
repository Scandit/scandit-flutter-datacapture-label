/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';

/// Holds the ongoing state of capturing data contained in one or more labels. An instance of this class is passed to LabelCaptureListener.didUpdateSession() when new labels are captured, or existing labels are updated or lost.
///
/// The session provides access to all currently tracked labels, including those that are still being progressively captured (incomplete) and those that have all required fields captured (complete). Labels maintain their tracking IDs across multiple frames until they are no longer visible.
///
/// The capture session should only be accessed from within didUpdateSession() to which it is provided as an argument. It is not safe to be accessed from anywhere else since it may be concurrently modified.Specifically no reference to [LabelCaptureSession.capturedLabels] should be kept and traversed outside of didUpdateSession(). Instead a copy of the list should be made to avoid concurrent modification. The individual labels can be referenced without copying as they are not further modified.
///
/// Added in version 7.2.0
class LabelCaptureSession with _PrivateLabelCaptureSession {
  late List<CapturedLabel> _capturedLabels;
  late int _frameSequenceId;
  late int _lastProcessedFrameId;

  LabelCaptureSession._();

  /// List of currently captured labels.
  ///
  /// Added in version 7.2.0
  List<CapturedLabel> get capturedLabels => _capturedLabels;

  /// The identifier of the current frame sequence.
  ///
  /// Added in version 7.2.0
  int get frameSequenceId => _frameSequenceId;

  /// The identifier of the last processed frame.
  ///
  /// Added in version 7.2.0
  int get lastProcessedFrameId => _lastProcessedFrameId;

  factory LabelCaptureSession.fromJSON(Map<String, dynamic> eventJson) {
    final json = jsonDecode(eventJson['session']);

    final session = LabelCaptureSession._();
    session._frameSequenceId = json['frameSequenceId'];
    session._lastProcessedFrameId = json['lastFrameId'];
    session._capturedLabels =
        (json['labels'] as List).map((label) => CapturedLabel.fromJSON(label, session._frameSequenceId)).toList();
    // `frameId` is nullable on the wire (no frame retained for this session update); the
    // getter is non-nullable, so an absent id reads as empty rather than dropping the event.
    session._frameId = eventJson['frameId'] ?? '';

    return session;
  }
}

mixin _PrivateLabelCaptureSession {
  // ignore: prefer_final_fields
  String _frameId = "";

  String get frameId => _frameId;
}
