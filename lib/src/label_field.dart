/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_date_result.dart';

enum LabelFieldType {
  barcode('barcode'),
  text('text'),
  unknown('unknown');

  const LabelFieldType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension LabelFieldTypeDeserializer on LabelFieldType {
  static LabelFieldType fromJSON(String jsonValue) {
    return LabelFieldType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum LabelFieldState {
  captured('captured'),
  predicted('predicted'),
  unknown('unknown');

  const LabelFieldState(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension LabelFieldStateDeserializer on LabelFieldState {
  static LabelFieldState fromJSON(String jsonValue) {
    return LabelFieldState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum LabelDateComponentFormat {
  dmy('dmy'),
  mdy('mdy'),
  ymd('ymd');

  const LabelDateComponentFormat(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension LabelDateComponentFormatDeserializer on LabelDateComponentFormat {
  static LabelDateComponentFormat fromJSON(String jsonValue) {
    return LabelDateComponentFormat.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class LabelField implements Serializable {
  final String _name;
  final LabelFieldType _type;
  final Quadrilateral _predictedLocation;
  final LabelFieldState _state;
  final bool _isRequired;
  final Barcode? _barcode;
  final String? _text;
  final LabelDateResult? _dateResult;

  LabelField._(
    this._name,
    this._type,
    this._predictedLocation,
    this._state,
    this._isRequired,
    this._barcode,
    this._text,
    this._dateResult,
  );

  String get name => _name;

  LabelFieldType get type => _type;

  Quadrilateral get predictedLocation => _predictedLocation;

  LabelFieldState get state => _state;

  bool get isRequired => _isRequired;

  Barcode? get barcode => _barcode;

  String? get text => _text;

  factory LabelField.fromJSON(Map<String, dynamic> json) {
    final dateResult = json['date'] != null ? LabelDateResult.fromJSON(json['date']) : null;
    return LabelField._(
      json['name'],
      LabelFieldTypeDeserializer.fromJSON(json['type']),
      Quadrilateral.fromJSON(json['location']),
      LabelFieldStateDeserializer.fromJSON(json['state']),
      json['isRequired'],
      json['barcode'] != null ? Barcode.fromJSON(json['barcode']) : null,
      json['text'],
      dateResult,
    );
  }

  LabelDateResult? asDate() {
    return _dateResult;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.toString(),
    };
  }
}
