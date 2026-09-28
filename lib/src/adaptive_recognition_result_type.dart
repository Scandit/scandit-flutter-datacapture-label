/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum AdaptiveRecognitionResultType {
  receipt('receipt');

  const AdaptiveRecognitionResultType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static AdaptiveRecognitionResultType fromJSON(String jsonValue) {
    return AdaptiveRecognitionResultType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
