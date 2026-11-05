/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// An enumeration representing the type of label result update in the validation flow.
///
/// This type distinguishes between different stages of label field updates:
///
/// - Synchronous updates from immediate processing
/// - Asynchronous updates when processing starts
/// - Asynchronous updates when processing completes
///
/// Added in version 8.4.0
enum LabelResultUpdateType {
  /// Indicates that asynchronous processing has completed and results are available. The corresponding LabelCaptureValidationFlowExtendedListener.didUpdateValidationFlowResult() callback will include the same asyncId as the [LabelResultUpdateType.asyncStarted] event but with frameData as *null*.
  ///
  /// Added in version 8.4.0
  asyncFinished('AsyncFinished'),
  /// Indicates that asynchronous processing has started for a frame. The corresponding LabelCaptureValidationFlowExtendedListener.didUpdateValidationFlowResult() callback will include frame data and a unique asyncId to correlate with the [LabelResultUpdateType.asyncFinished] event.
  ///
  /// Added in version 8.4.0
  asyncStarted('AsyncStarted'),
  /// Indicates a synchronous update from immediate processing.
  ///
  /// Added in version 8.4.0
  sync('Sync');

  const LabelResultUpdateType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static LabelResultUpdateType fromJSON(String jsonValue) {
    return LabelResultUpdateType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
