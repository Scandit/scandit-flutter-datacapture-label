/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart' show buildLabelDateFormat;

/// Defines the expected format for parsing dates from captured text fields. This class specifies how date components (day, month, year) are ordered and whether partial dates should be accepted during the parsing process.
///
/// Used in conjunction with date text fields like [ExpiryDateText] and [PackingDateText] to ensure accurate date recognition and parsing.
///
/// Added in version 7.2.0
class LabelDateFormat implements Serializable {
  final LabelDateComponentFormat _componentFormat;
  final bool _acceptPartialDates;

  /// Constructs an instance of this class with the provided parameters.
  ///
  /// Added in version 7.2.0
  LabelDateFormat(this._componentFormat, this._acceptPartialDates);

  /// Holds the expected order for the date components. Defaults to [LabelDateComponentFormat.ymd].
  ///
  /// Added in version 7.2.0
  LabelDateComponentFormat get componentFormat => _componentFormat;

  /// Whether or not to accept partial dates corresponding to the specified component format. Defaults to *true*.
  ///
  /// Added in version 7.2.0
  bool get acceptPartialDates => _acceptPartialDates;

  @override
  Map<String, dynamic> toMap() {
    return buildLabelDateFormat(
      componentFormat: componentFormat.toString(),
      acceptPartialDates: acceptPartialDates,
    );
  }
}
