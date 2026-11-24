/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// An enumeration of possible locations for a text field within a label.
///
/// Added in version 7.2.0
enum LabelFieldLocationType {
  /// Added in version 7.2.0
  topLeft('topLeft'),
  /// Added in version 7.2.0
  topRight('topRight'),
  /// Added in version 7.2.0
  bottomRight('bottomRight'),
  /// Added in version 7.2.0
  bottomLeft('bottomLeft'),
  /// Added in version 7.2.0
  top('top'),
  /// Added in version 7.2.0
  right('right'),
  /// Added in version 7.2.0
  bottom('bottom'),
  /// Added in version 7.2.0
  left('left'),
  /// Added in version 7.2.0
  center('center'),
  /// Added in version 7.2.0
  wholeLabel('wholeLabel');

  const LabelFieldLocationType(this._name);

  @override
  String toString() => _name;

  final String _name;
}
