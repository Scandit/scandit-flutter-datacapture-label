/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// ignore_for_file: use_super_parameters

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_barcode/src/barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';

abstract class LabelFieldDefinition implements Serializable {
  final String _name;
  final String _fieldType;

  List<String> _patterns = [];

  bool _isOptional = false;

  Map<String, dynamic> _hiddenProperties = {};

  LabelFieldDefinition._(this._name, this._fieldType);

  String get name;

  List<String> get patterns;

  bool get isOptional;

  @override
  Map<String, dynamic> toMap() {
    var json = {
      'name': name,
      'fieldType': _fieldType,
      'patterns': patterns,
      'optional': isOptional,
    };
    for (final hiddenProp in _hiddenProperties.entries) {
      json[hiddenProp.key] = hiddenProp.value;
    }
    return json;
  }
}

abstract class LabelFieldDefinitionBuilder<BuilderType, FieldType> {
  List<String> _patterns = [];
  Map<String, dynamic> _hiddenProperties = {};
  bool _isOptional = false;

  BuilderType setPatterns(List<String> patterns) {
    _patterns = patterns;
    return this as BuilderType;
  }

  BuilderType setPattern(String pattern) {
    _patterns.add(pattern);
    return this as BuilderType;
  }

  BuilderType setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this as BuilderType;
  }

  BuilderType setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this as BuilderType;
  }

  BuilderType isOptional(bool optional) {
    _isOptional = optional;
    return this as BuilderType;
  }
}

abstract class BarcodeField extends LabelFieldDefinition {
  final List<SymbologySettings> _symbologies;

  BarcodeField._(super.name, this._symbologies, super._fieldType) : super._();

  BarcodeField._fromSymbologies(String name, List<Symbology> symbologies, String fieldType)
      : this._(
            name,
            symbologies.map((symbology) {
              final settings = BarcodeDefaults.symbologySettingsDefaults[symbology.toString()];
              if (settings == null) {
                throw ArgumentError('Unsupported symbology: $symbology');
              }
              return settings;
            }).toList(),
            fieldType);

  List<SymbologySettings> get symbologies;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['symbologies'] = {for (var setting in symbologies) setting.symbology.toString(): setting.toMap()};
    return json;
  }
}

abstract class BarcodeFieldBuilder<BuilderType, FieldType> extends LabelFieldDefinitionBuilder<BuilderType, FieldType> {
  BuilderType setSymbology(Symbology symbology) {
    symbologies.add(symbology);
    return this as BuilderType;
  }

  BuilderType setSymbologies(List<Symbology> symbologies) {
    this.symbologies = symbologies;
    return this as BuilderType;
  }

  List<Symbology> symbologies = [];
}

class CustomBarcode extends BarcodeField {
  LabelFieldLocationType? _locationType;

  LabelFieldLocation? _location;

  List<String> _dataTypePatterns = [];

  CustomBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  CustomBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory CustomBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return CustomBarcode._(name, symbologySettings, 'customBarcode');
  }

  factory CustomBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return CustomBarcode._fromSymbologies(name, symbologies.toList(), 'customBarcode');
  }

  factory CustomBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return CustomBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  void setLocationWithType(LabelFieldLocationType location) {
    _locationType = location;
  }

  void setLocationWithRect(Rect rect) {
    _location = LabelFieldLocation.forRect(rect);
  }

  void setLocationWithCoordinates(double left, double top, double right, double bottom) {
    _location = LabelFieldLocation.forCoordinates(left, top, right, bottom);
  }

  List<String> get dataTypePatterns => _dataTypePatterns;

  LabelFieldLocation? get location => _location;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    if (_locationType != null) {
      json['locationType'] = _locationType?.toString();
    }
    json['dataTypePatterns'] = dataTypePatterns;
    if (_location != null) {
      json['location'] = _location?.toMap();
    }
    return json;
  }
}

class CustomBarcodeBuilder extends BarcodeFieldBuilder<CustomBarcodeBuilder, CustomBarcode> {
  final List<String> _dataTypePatterns = [];

  CustomBarcodeBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  CustomBarcodeBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  CustomBarcode build(String name) {
    return CustomBarcode._fromSymbologies(name, symbologies, 'customBarcode')
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      .._dataTypePatterns = _dataTypePatterns;
  }
}

abstract class TextField extends LabelFieldDefinition {
  List<String> _dataTypePatterns = [];

  TextField._(super.name, super._fieldType) : super._();

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['dataTypePatterns'] = _dataTypePatterns;
    return json;
  }
}

abstract class TextFieldBuilder<BuilderType, FieldType> extends LabelFieldDefinitionBuilder<BuilderType, FieldType> {}

class CustomText extends TextField {
  LabelFieldLocationType? _locationType;
  LabelFieldLocation? _location;

  CustomText(String name) : super._(name, 'customText');

  void setLocationWithType(LabelFieldLocationType location) {
    _locationType = location;
  }

  void setLocationWithRect(Rect rect) {
    _location = LabelFieldLocation.forRect(rect);
  }

  void setLocationWithCoordinates(double left, double top, double right, double bottom) {
    _location = LabelFieldLocation.forCoordinates(left, top, right, bottom);
  }

  List<String> get dataTypePatterns => _dataTypePatterns;

  LabelFieldLocation? get location => _location;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    if (_locationType != null) {
      json['locationType'] = _locationType?.toString();
    }
    if (_location != null) {
      json['location'] = _location?.toMap();
    }
    return json;
  }
}

class CustomTextBuilder extends TextFieldBuilder<CustomTextBuilder, CustomText> {
  final List<String> _dataTypePatterns = [];

  CustomTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  CustomTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  CustomTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  CustomText build(String name) {
    return CustomText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      .._dataTypePatterns = _dataTypePatterns;
  }
}

class ExpiryDateText extends TextField {
  ExpiryDateText(String name) : super._(name, 'expiryDateText');

  LabelDateFormat? labelDateFormat;

  List<String> get dataTypePatterns => _dataTypePatterns;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

class ExpiryDateTextBuilder extends TextFieldBuilder<ExpiryDateTextBuilder, ExpiryDateText> {
  LabelDateFormat? _labelDateFormat;

  final List<String> _dataTypePatterns = [];

  ExpiryDateTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  ExpiryDateTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  ExpiryDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  ExpiryDateTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  ExpiryDateText build(String name) {
    return ExpiryDateText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      ..labelDateFormat = _labelDateFormat
      .._dataTypePatterns = _dataTypePatterns;
  }
}

class ImeiOneBarcode extends BarcodeField {
  ImeiOneBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  ImeiOneBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory ImeiOneBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return ImeiOneBarcode._(name, symbologySettings, 'imeiOneBarcode');
  }

  factory ImeiOneBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return ImeiOneBarcode._fromSymbologies(name, symbologies.toList(), 'imeiOneBarcode');
  }
  factory ImeiOneBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return ImeiOneBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  List<SymbologySettings> get symbologies => _symbologies;
}

class ImeiOneBarcodeBuilder extends BarcodeFieldBuilder<ImeiOneBarcodeBuilder, ImeiOneBarcode> {
  ImeiOneBarcode build(String name) {
    return ImeiOneBarcode._fromSymbologies(name, symbologies, 'imeiOneBarcode')
      .._patterns.addAll(_patterns)
      .._isOptional = _isOptional
      .._hiddenProperties.addAll(_hiddenProperties);
  }
}

class ImeiTwoBarcode extends BarcodeField {
  ImeiTwoBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  ImeiTwoBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory ImeiTwoBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return ImeiTwoBarcode._(name, symbologySettings, 'imeiTwoBarcode');
  }

  factory ImeiTwoBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return ImeiTwoBarcode._fromSymbologies(name, symbologies.toList(), 'imeiTwoBarcode');
  }

  factory ImeiTwoBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return ImeiTwoBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  List<SymbologySettings> get symbologies => _symbologies;
}

class ImeiTwoBarcodeBuilder extends BarcodeFieldBuilder<ImeiTwoBarcodeBuilder, ImeiTwoBarcode> {
  ImeiTwoBarcode build(String name) {
    return ImeiTwoBarcode._fromSymbologies(name, symbologies, 'imeiTwoBarcode')
      .._patterns.addAll(_patterns)
      .._isOptional = _isOptional
      .._hiddenProperties.addAll(_hiddenProperties);
  }
}

class PackingDateText extends TextField {
  PackingDateText(String name) : super._(name, 'packingDateText');

  LabelDateFormat? labelDateFormat;

  List<String> get dataTypePatterns => _dataTypePatterns;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

class PackingDateTextBuilder extends TextFieldBuilder<PackingDateTextBuilder, PackingDateText> {
  LabelDateFormat? _labelDateFormat;

  final List<String> _dataTypePatterns = [];

  PackingDateTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  PackingDateTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  PackingDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  PackingDateTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  PackingDateText build(String name) {
    return PackingDateText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      ..labelDateFormat = _labelDateFormat
      .._dataTypePatterns = _dataTypePatterns;
  }
}

class PartNumberBarcode extends BarcodeField {
  PartNumberBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  PartNumberBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory PartNumberBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return PartNumberBarcode._(name, symbologySettings, 'partNumberBarcode');
  }

  factory PartNumberBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return PartNumberBarcode._fromSymbologies(name, symbologies.toList(), 'partNumberBarcode');
  }

  factory PartNumberBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return PartNumberBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  List<SymbologySettings> get symbologies => _symbologies;
}

class PartNumberBarcodeBuilder extends BarcodeFieldBuilder<PartNumberBarcodeBuilder, PartNumberBarcode> {
  PartNumberBarcode build(String name) {
    return PartNumberBarcode._fromSymbologies(name, symbologies, 'partNumberBarcode')
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties;
  }
}

class SerialNumberBarcode extends BarcodeField {
  SerialNumberBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  SerialNumberBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory SerialNumberBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return SerialNumberBarcode._(name, symbologySettings, 'serialNumberBarcode');
  }

  factory SerialNumberBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return SerialNumberBarcode._fromSymbologies(name, symbologies.toList(), 'serialNumberBarcode');
  }

  factory SerialNumberBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return SerialNumberBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  @override
  List<SymbologySettings> get symbologies => _symbologies;
}

class SerialNumberBarcodeBuilder extends BarcodeFieldBuilder<SerialNumberBarcodeBuilder, SerialNumberBarcode> {
  SerialNumberBarcode build(String name) {
    return SerialNumberBarcode._fromSymbologies(name, symbologies, 'serialNumberBarcode')
      .._patterns.addAll(_patterns)
      .._isOptional = _isOptional
      .._hiddenProperties.addAll(_hiddenProperties);
  }
}

class TotalPriceText extends TextField {
  TotalPriceText(String name) : super._(name, 'totalPriceText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  List<String> get dataTypePatterns => _dataTypePatterns;
}

class TotalPriceTextBuilder extends TextFieldBuilder<TotalPriceTextBuilder, TotalPriceText> {
  final List<String> _dataTypePatterns = [];

  TotalPriceTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  TotalPriceTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  TotalPriceTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  TotalPriceText build(String name) {
    return TotalPriceText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      .._dataTypePatterns = _dataTypePatterns;
  }
}

class UnitPriceText extends TextField {
  UnitPriceText(String name) : super._(name, 'unitPriceText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  List<String> get dataTypePatterns => _dataTypePatterns;
}

class UnitPriceTextBuilder extends TextFieldBuilder<UnitPriceTextBuilder, UnitPriceText> {
  final List<String> _dataTypePatterns = [];

  UnitPriceTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  UnitPriceTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  UnitPriceTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  UnitPriceText build(String name) {
    return UnitPriceText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      .._dataTypePatterns = _dataTypePatterns;
  }
}

class WeightText extends TextField {
  WeightText(String name) : super._(name, 'weightText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get patterns => _patterns;

  List<String> get dataTypePatterns => _dataTypePatterns;
}

class WeightTextBuilder extends TextFieldBuilder<WeightTextBuilder, WeightText> {
  final List<String> _dataTypePatterns = [];

  WeightTextBuilder setDataTypePatterns({String? dataTypePattern, Iterable<String>? dataTypePatterns}) {
    if (dataTypePattern != null) {
      _dataTypePatterns.add(dataTypePattern);
    }
    if (dataTypePatterns != null) {
      _dataTypePatterns.addAll(dataTypePatterns);
    }
    return this;
  }

  WeightTextBuilder setDataTypePattern(RegExp dataTypePattern) {
    _dataTypePatterns.add(dataTypePattern.pattern);
    return this;
  }

  WeightTextBuilder resetDataTypePatterns() {
    _dataTypePatterns.clear();
    return this;
  }

  WeightText build(String name) {
    return WeightText(name)
      .._patterns = _patterns
      .._isOptional = _isOptional
      .._hiddenProperties = _hiddenProperties
      .._dataTypePatterns = _dataTypePatterns;
  }
}
