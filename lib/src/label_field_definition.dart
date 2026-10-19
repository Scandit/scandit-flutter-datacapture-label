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

  List<String>? _valueRegexes;

  bool _isOptional = false;

  int? _numberOfMandatoryInstances;

  Map<String, dynamic> _hiddenProperties = {};

  LabelFieldDefinition._(this._name, this._fieldType);

  String get name;

  List<String> get valueRegexes;

  bool get isOptional;

  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'name': name,
      'fieldType': _fieldType,
      'optional': isOptional,
      'patterns': _valueRegexes,
    };
    if (_numberOfMandatoryInstances != null) {
      json['number_of_mandatory_instances'] = _numberOfMandatoryInstances!;
    }
    for (final hiddenProp in _hiddenProperties.entries) {
      json[hiddenProp.key] = hiddenProp.value;
    }
    return json;
  }
}

abstract class LabelFieldDefinitionBuilder<BuilderType, FieldType> {
  List<String>? _valueRegexes;
  Map<String, dynamic> _hiddenProperties = {};
  bool _isOptional = false;
  int? _numberOfMandatoryInstances;

  BuilderType setValueRegexes(List<String> valueRegexes) {
    _valueRegexes = valueRegexes;
    return this as BuilderType;
  }

  BuilderType setValueRegex(String valueRegex) {
    _valueRegexes = [...(_valueRegexes ?? []), valueRegex];
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

  BuilderType setNumberOfMandatoryInstances(int? numberOfMandatoryInstances) {
    _numberOfMandatoryInstances = numberOfMandatoryInstances;
    return this as BuilderType;
  }
}

abstract class BarcodeField extends LabelFieldDefinition {
  final List<SymbologySettings> _symbologies;

  BarcodeField._(super.name, this._symbologies, super._fieldType) : super._() {
    // Custom barcode fields have no native default symbology, so at least one must be set.
    // Semantic fields (IMEI, serial number, part number) default natively when omitted.
    if (_symbologies.isEmpty && _fieldType == 'customBarcode') {
      throw ArgumentError('A custom barcode label field requires at least one symbology.');
    }
  }

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
    // Only serialize symbologies when explicitly set. When omitted, the native layer
    // applies the type-appropriate defaults (custom barcode fields have none and require
    // at least one symbology; semantic fields like IMEI/serial/part number default natively).
    if (symbologies.isNotEmpty) {
      json['symbologies'] = {for (var setting in symbologies) setting.symbology.toString(): setting.toMap()};
    }
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

  List<String>? _anchorRegexes;

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

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  LabelFieldLocation? get location => _location;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    if (_locationType != null) {
      json['locationType'] = _locationType?.toString();
    }
    json['dataTypePatterns'] = _anchorRegexes;
    if (_location != null) {
      json['location'] = _location?.toMap();
    }
    return json;
  }
}

class CustomBarcodeBuilder extends BarcodeFieldBuilder<CustomBarcodeBuilder, CustomBarcode> {
  List<String>? _anchorRegexes;

  CustomBarcodeBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  CustomBarcodeBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  CustomBarcode build(String name) {
    final instance = CustomBarcode._fromSymbologies(name, symbologies, 'customBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}

abstract class TextField extends LabelFieldDefinition {
  List<String>? _anchorRegexes;

  TextField._(super.name, super._fieldType) : super._();

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['dataTypePatterns'] = _anchorRegexes;
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

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  LabelFieldLocation? get location => _location;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

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
  List<String>? _anchorRegexes;

  CustomTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  CustomTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  CustomTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  CustomText build(String name) {
    final instance = CustomText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}

class ExpiryDateText extends TextField {
  ExpiryDateText(String name) : super._(name, 'expiryDateText');

  LabelDateFormat? labelDateFormat;

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

class ExpiryDateTextBuilder extends TextFieldBuilder<ExpiryDateTextBuilder, ExpiryDateText> {
  LabelDateFormat? _labelDateFormat;

  List<String>? _anchorRegexes;

  ExpiryDateTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  ExpiryDateTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  ExpiryDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  ExpiryDateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  ExpiryDateText build(String name) {
    final instance = ExpiryDateText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties
      ..labelDateFormat = _labelDateFormat;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
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
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class ImeiOneBarcodeBuilder extends BarcodeFieldBuilder<ImeiOneBarcodeBuilder, ImeiOneBarcode> {
  ImeiOneBarcode build(String name) {
    final instance = ImeiOneBarcode._fromSymbologies(name, symbologies, 'imeiOneBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
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
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class ImeiTwoBarcodeBuilder extends BarcodeFieldBuilder<ImeiTwoBarcodeBuilder, ImeiTwoBarcode> {
  ImeiTwoBarcode build(String name) {
    final instance = ImeiTwoBarcode._fromSymbologies(name, symbologies, 'imeiTwoBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

class PackingDateText extends TextField {
  PackingDateText(String name) : super._(name, 'packingDateText');

  LabelDateFormat? labelDateFormat;

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

class PackingDateTextBuilder extends TextFieldBuilder<PackingDateTextBuilder, PackingDateText> {
  LabelDateFormat? _labelDateFormat;

  List<String>? _anchorRegexes;

  PackingDateTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  PackingDateTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  PackingDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  PackingDateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  PackingDateText build(String name) {
    final instance = PackingDateText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties
      ..labelDateFormat = _labelDateFormat;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
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
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class PartNumberBarcodeBuilder extends BarcodeFieldBuilder<PartNumberBarcodeBuilder, PartNumberBarcode> {
  PartNumberBarcode build(String name) {
    final instance = PartNumberBarcode._fromSymbologies(name, symbologies, 'partNumberBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
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
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  List<SymbologySettings> get symbologies => _symbologies;

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class SerialNumberBarcodeBuilder extends BarcodeFieldBuilder<SerialNumberBarcodeBuilder, SerialNumberBarcode> {
  SerialNumberBarcode build(String name) {
    final instance = SerialNumberBarcode._fromSymbologies(name, symbologies, 'serialNumberBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

class TotalPriceText extends TextField {
  TotalPriceText(String name) : super._(name, 'totalPriceText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class TotalPriceTextBuilder extends TextFieldBuilder<TotalPriceTextBuilder, TotalPriceText> {
  List<String>? _anchorRegexes;

  TotalPriceTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  TotalPriceTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  TotalPriceTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  TotalPriceText build(String name) {
    final instance = TotalPriceText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}

class UnitPriceText extends TextField {
  UnitPriceText(String name) : super._(name, 'unitPriceText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class UnitPriceTextBuilder extends TextFieldBuilder<UnitPriceTextBuilder, UnitPriceText> {
  List<String>? _anchorRegexes;

  UnitPriceTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  UnitPriceTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  UnitPriceTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  UnitPriceText build(String name) {
    final instance = UnitPriceText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}

class WeightText extends TextField {
  WeightText(String name) : super._(name, 'weightText');

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  List<String> get anchorRegexes => _anchorRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

class WeightTextBuilder extends TextFieldBuilder<WeightTextBuilder, WeightText> {
  List<String>? _anchorRegexes;

  WeightTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  WeightTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  WeightTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  WeightText build(String name) {
    final instance = WeightText(name)
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}

class DateText extends TextField {
  late final LabelDateFormat _labelDateFormat;

  DateText(String name, LabelDateFormat labelDateFormat) : super._(name, 'dateText') {
    _labelDateFormat = labelDateFormat;
  }

  LabelDateFormat get labelDateFormat => _labelDateFormat;

  @override
  bool get isOptional => _isOptional;

  @override
  String get name => _name;

  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  List<String> get anchorRegexes => _anchorRegexes ?? [];
}

class DateTextBuilder extends TextFieldBuilder<DateTextBuilder, DateText> {
  List<String>? _anchorRegexes;
  LabelDateFormat? _labelDateFormat;

  DateTextBuilder setAnchorRegexes({String? anchorRegex, Iterable<String>? anchorRegexes}) {
    _anchorRegexes ??= [];
    if (anchorRegex != null) {
      _anchorRegexes?.add(anchorRegex);
    }
    if (anchorRegexes != null) {
      _anchorRegexes?.addAll(anchorRegexes);
    }
    return this;
  }

  DateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  DateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  DateText build(String name) {
    final instance = DateText(name, _labelDateFormat ?? LabelDateFormat(LabelDateComponentFormat.dmy, true))
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    if (_anchorRegexes != null) instance._anchorRegexes = _anchorRegexes;
    return instance;
  }
}
