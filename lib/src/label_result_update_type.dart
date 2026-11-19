/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum LabelResultUpdateType {
  asyncFinished('AsyncFinished'),
  asyncStarted('AsyncStarted'),
  sync('Sync');

  const LabelResultUpdateType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static LabelResultUpdateType fromJSON(String jsonValue) {
    return LabelResultUpdateType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
