/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

class LabelDateResult {
  final int? _day;
  final int? _month;
  final int? _year;
  final String? _dayString;
  final String? _monthString;
  final String? _yearString;

  LabelDateResult._(this._day, this._month, this._year, this._dayString, this._monthString, this._yearString);

  int? get day => _day;
  int? get month => _month;
  int? get year => _year;

  String get dayString => _dayString ?? '';
  String get monthString => _monthString ?? '';
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
