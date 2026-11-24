/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

/// Represents the result of parsing a date from captured text using a [LabelDateFormat]. Contains the individual date components (day, month, year) in both numeric and string formats.
///
/// This class is returned when date text fields are successfully parsed according to the configured date format patterns.
///
/// Added in version 7.2.0
class LabelDateResult {
  final int? _day;
  final int? _month;
  final int? _year;
  final String? _dayString;
  final String? _monthString;
  final String? _yearString;

  LabelDateResult._(this._day, this._month, this._year, this._dayString, this._monthString, this._yearString);

  /// When running on Android, the parsed day starts on 1 and can be *null* if the parsing fails. When running on iOS, the parsed day starts on 1 and if the parsing fails, -1 is returned.
  ///
  /// Added in version 7.2.0
  int? get day => _day;
  /// When running on Android, the parsed month starts on 1 for January. Can be *null* if the parsing fails. When running on iOS, the parsed month starts on 1 for January. If the parsing fails, -1 is returned.
  ///
  /// Added in version 7.2.0
  int? get month => _month;
  /// When running on Android, the parsed year starts on 1. Can be *null* if the parsing fails. When running on iOS, the parsed year starts on 1. If the parsing fails, -1 is returned.
  ///
  /// Added in version 7.2.0
  int? get year => _year;

  /// The day in String form.
  ///
  /// Added in version 7.2.0
  String get dayString => _dayString ?? '';
  /// The month in String form.
  ///
  /// Added in version 7.2.0
  String get monthString => _monthString ?? '';
  /// The year in String form.
  ///
  /// Added in version 7.2.0
  String get yearString => _yearString ?? '';

  factory LabelDateResult.fromJSON(Map<String, dynamic> json) {
    return LabelDateResult._(
      json['day'],
      json['month'],
      json['year'],
      json['dayStr'],
      json['monthStr'],
      json['yearStr'],
    );
  }
}
