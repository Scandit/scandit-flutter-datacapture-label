/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// Defines the type of document that can be recognized by the adaptive recognition system.
///
/// Added in version 8.2.0
enum AdaptiveRecognitionResultType {
  /// Receipt document type.
  ///
  /// Added in version 8.2.0
  receipt('receipt');

  const AdaptiveRecognitionResultType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static AdaptiveRecognitionResultType fromJSON(String jsonValue) {
    return AdaptiveRecognitionResultType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
