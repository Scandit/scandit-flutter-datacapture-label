/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_date_result.dart';

/// An enumeration of possible field types of a captured field ([LabelField]). The type of the field is given by the currently active label capture settings ([LabelCaptureSettings]).
///
/// Added in version 7.2.0
enum LabelFieldType {
  /// The type of the captured field is barcode. For fields that have been [LabelFieldState.captured], the data encoded in the field is available through the [LabelField.barcode] property.
  ///
  /// Added in version 7.2.0
  barcode('barcode'),
  /// The type of the captured field is text. For fields that have been [LabelFieldState.captured], the data encoded in the field is available through the [LabelField.text] property.
  ///
  /// Added in version 7.2.0
  text('text'),
  /// The type of the captured field is unknown.
  ///
  /// Added in version 7.2.0
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

/// An enumeration of possible states a label field ([CapturedLabel]) can be in.
///
/// Added in version 7.2.0
enum LabelFieldState {
  /// The field has been captured, e.g. the barcode or text has been read and its location is known.
  ///
  /// Added in version 7.2.0
  captured('captured'),
  /// The field has not been captured yet, but its location has been predicted.
  ///
  /// Added in version 7.2.0
  predicted('predicted'),
  /// The field data as well as its location are unknown.
  ///
  /// Added in version 7.2.0
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

/// An enumeration of possible date formats to expect when parsing a date in a suitable [LabelField].
///
/// Added in version 7.2.0
enum LabelDateComponentFormat {
  /// Marks the date to follow a date format with day, month and year, in that order.
  ///
  /// Added in version 7.2.0
  dmy('dmy'),
  /// Marks the date to follow a date format with month, day and year, in that order.
  ///
  /// Added in version 7.2.0
  mdy('mdy'),
  /// Marks the date to follow a date format with year, month and day, in that order.
  ///
  /// Added in version 7.2.0
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

/// Specifies the value type of a captured field.
///
/// Added in version 8.3.0
enum LabelFieldValueType {
  /// The field value represents a date.
  ///
  /// Added in version 8.3.0
  date('date'),
  /// The field value represents a price.
  ///
  /// Added in version 8.3.0
  price('price'),
  /// The field value represents a weight.
  ///
  /// Added in version 8.3.0
  weight('weight'),
  /// The field value represents text.
  ///
  /// Added in version 8.3.0
  text('text'),
  /// The field value represents a numeric value.
  ///
  /// Added in version 8.3.0
  numeric('numeric');

  const LabelFieldValueType(this._name);

  @override
  String toString() => _name;

  final String _name;

  static LabelFieldValueType fromJSON(String jsonValue) {
    return LabelFieldValueType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Represents a captured field within a label. Each field corresponds to a specific data element defined in the [LabelDefinition] and contains the actual captured data along with metadata about its state, location, and type.
///
/// Fields can be either barcode fields (containing [Barcode] data) or text fields (containing string data), and may include additional semantic information such as parsed dates.
///
/// **Processing captured fields:**
///
/// Added in version 7.2.0
class LabelField implements Serializable {
  final String _name;
  final LabelFieldType _type;
  final Quadrilateral _predictedLocation;
  final LabelFieldState _state;
  final bool _isRequired;
  final Barcode? _barcode;
  final String? _text;
  final LabelDateResult? _dateResult;
  final LabelFieldValueType _valueType;

  LabelField._(
    this._name,
    this._type,
    this._predictedLocation,
    this._state,
    this._isRequired,
    this._barcode,
    this._text,
    this._dateResult,
    this._valueType,
  );

  /// The unique identifier for this captured field within the label. This name corresponds to the field name specified in the [LabelDefinition] when configuring the label structure. For example, field names might be “barcode”, “price”, “expiry_date”, etc.
  ///
  /// Added in version 7.2.0
  String get name => _name;

  /// Identifies the type of the captured field type. This either returns [LabelFieldType.barcode], or [LabelFieldType.text]. Depending on the type, further information such as captured data is available through the following properties:
  ///
  /// - When the type is [LabelFieldType.barcode], the captured data can be extracted through the [LabelField.barcode] property.
  /// - When the type is [LabelFieldType.text], the captured data can be extracted through the [LabelField.text] property.
  ///
  /// Added in version 7.2.0
  LabelFieldType get type => _type;

  /// The predicted location of this field within the image, represented as a quadrilateral with four corner points. These coordinates are in image space and need to be converted to view coordinates before they can be used for UI overlays. When the field’s [LabelField.state] is [LabelFieldState.unknown], a quadrilateral with all points set to (0,0) is returned.
  ///
  /// Added in version 7.2.0
  Quadrilateral get predictedLocation => _predictedLocation;

  /// The current state of this field in the capture process. This indicates whether the field has been successfully captured, its location has been predicted, or it remains unknown:
  ///
  /// - [LabelFieldState.captured] - The field has been successfully recognized and its data extracted
  /// - [LabelFieldState.predicted] - The field’s location has been estimated but data hasn’t been captured yet
  /// - [LabelFieldState.unknown] - The field’s location could not be determined
  ///
  /// Added in version 7.2.0
  LabelFieldState get state => _state;

  /// Indicates whether this field is required for the label to be considered complete. Returns true for mandatory fields and false for optional fields. This value is determined by the isOptional property set in the corresponding field definition.
  ///
  /// Added in version 7.2.0
  bool get isRequired => _isRequired;

  /// The decoded barcode data for this field. This property contains the full barcode information including the decoded data, symbology, and location. Returns *null* when the field type is not [LabelFieldType.barcode] or when the barcode hasn’t been successfully captured yet.
  ///
  /// Added in version 7.2.0
  Barcode? get barcode => _barcode;

  /// The recognized text content for this field. This property contains the raw text string extracted through OCR processing. Returns *null* when the field type is not [LabelFieldType.text] or when the text hasn’t been successfully captured yet.
  ///
  /// Added in version 7.2.0
  String? get text => _text;

  /// Identifies the semantic value type of the captured field, providing additional context about the data’s meaning beyond just barcode or text. This helps determine how to interpret and process the captured information.
  ///
  /// Added in version 8.3.0
  LabelFieldValueType get valueType => _valueType;

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
      LabelFieldValueType.fromJSON(json['valueType']),
    );
  }

  /// Attempts to parse the field content as a date using the [LabelDateFormat] specified in the field definition. Returns a [LabelDateResult] containing structured date components (day, month, year) if parsing succeeds, or *null* if the field is not a date field or if parsing fails.
  ///
  /// Added in version 7.2.0
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
