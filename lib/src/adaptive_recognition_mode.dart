/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum AdaptiveRecognitionMode {
  off('off'),
  auto('auto');

  const AdaptiveRecognitionMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static AdaptiveRecognitionMode fromJSON(String jsonValue) {
    return AdaptiveRecognitionMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
