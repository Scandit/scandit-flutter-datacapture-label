/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field_location_type.dart';

/// Defines the expected location of a field within a label. This class allows you to specify either exact coordinates or predefined relative positions where a field should be searched for during label capture.
///
/// Field locations help constrain the search area and improve recognition accuracy by focusing the capture engine on specific regions of the label.
///
/// Added in version 7.2.0
class LabelFieldLocation implements Serializable {
  Rect? _rect;
  LabelFieldLocationType? _type;

  LabelFieldLocation._(this._rect, this._type);

  factory LabelFieldLocation.forRect(Rect rect) {
    return LabelFieldLocation._(rect, null);
  }

  factory LabelFieldLocation.forCoordinates(double left, double top, double right, double bottom) {
    return LabelFieldLocation._(Rect(Point(left, top), Size(right - left, bottom - top)), null);
  }

  factory LabelFieldLocation.topLeft() {
    return LabelFieldLocation._(null, LabelFieldLocationType.topLeft);
  }

  factory LabelFieldLocation.topRight() {
    return LabelFieldLocation._(null, LabelFieldLocationType.topRight);
  }

  factory LabelFieldLocation.bottomLeft() {
    return LabelFieldLocation._(null, LabelFieldLocationType.bottomLeft);
  }

  factory LabelFieldLocation.bottomRight() {
    return LabelFieldLocation._(null, LabelFieldLocationType.bottomRight);
  }

  factory LabelFieldLocation.top() {
    return LabelFieldLocation._(null, LabelFieldLocationType.top);
  }

  factory LabelFieldLocation.bottom() {
    return LabelFieldLocation._(null, LabelFieldLocationType.bottom);
  }

  factory LabelFieldLocation.left() {
    return LabelFieldLocation._(null, LabelFieldLocationType.left);
  }

  factory LabelFieldLocation.right() {
    return LabelFieldLocation._(null, LabelFieldLocationType.right);
  }

  factory LabelFieldLocation.center() {
    return LabelFieldLocation._(null, LabelFieldLocationType.center);
  }

  /// Constructs a new Label Field Location with the predefined location type corresponding to the whole label.
  ///
  /// Added in version 7.2.0
  factory LabelFieldLocation.wholeLabel() {
    return LabelFieldLocation._(null, LabelFieldLocationType.wholeLabel);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'rect': _rect?.toMap(),
      'type': _type?.toString(),
    };
  }
}
