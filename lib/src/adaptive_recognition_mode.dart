/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Enum specifying the adaptive recognition mode for label definitions. Adaptive recognition uses cloud-based processing as a backup for on-device processing.
///
/// Added in version 8.3.0
enum AdaptiveRecognitionMode {
  /// Disables adaptive recognition. Only on-device processing is used. This is the default mode.
  ///
  /// Added in version 8.3.0
  off('off'),
  /// Automatic strategy selection. The system will determine the best mix of on-device and cloud processing based on the current conditions.
  ///
  /// Added in version 8.3.0
  auto('auto'),
  /// The system prioritizes on-device processing, but cloud-based processing will be used when possible — even in some circumstances where `Auto` mode would skip it.
  ///
  /// Added in version 8.4.0
  on('on');

  const AdaptiveRecognitionMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static AdaptiveRecognitionMode fromJSON(String jsonValue) {
    return AdaptiveRecognitionMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
