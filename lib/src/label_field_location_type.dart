/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum LabelFieldLocationType {
  topLeft('topLeft'),
  topRight('topRight'),
  bottomRight('bottomRight'),
  bottomLeft('bottomLeft'),
  top('top'),
  right('right'),
  bottom('bottom'),
  left('left'),
  center('center'),
  wholeLabel('wholeLabel');

  const LabelFieldLocationType(this._name);

  @override
  String toString() => _name;

  final String _name;
}
