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

/// Added in version 7.2.0
abstract class LabelFieldDefinition implements Serializable {
  final String _name;
  final String _fieldType;

  List<String>? _valueRegexes;

  bool _isOptional = false;

  int? _numberOfMandatoryInstances;

  Map<String, dynamic> _hiddenProperties = {};

  LabelFieldDefinition._(this._name, this._fieldType);

  /// The unique identifier for this field within the label definition. This name is used to reference the field when processing captured results and must be unique within the label definition.
  ///
  /// Added in version 7.2.0
  String get name;

  /// Regular expressions used to validate captured content. These regexes allow you to ensure that the captured data matches the expected format for your specific field type.
  ///
  /// For example, you can use regexes like [“\d{2}/\d{2}/\d{4}”] for date formats, or [“[A-Z]{2}\d{6}”] for codes that must start with two letters followed by six digits.
  ///
  /// Added in version 8.0.0
  List<String> get valueRegexes;

  /// Determines whether this field is required for the label to be considered complete. When set to true, the label can be marked as complete even if this field is not found. When false (mandatory), the label will only be complete when this field is successfully captured.
  ///
  /// Optional fields are useful for scenarios where certain information might not always be present on labels, such as promotional codes or secondary identifiers.
  ///
  /// Added in version 7.2.0
  bool get isOptional;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
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

/// Interface for field definition builders. Provides common functionality for configuring field properties such as valueRegexes, optional status, and hidden properties.
///
/// Added in version 7.2.0
abstract class LabelFieldDefinitionBuilder<BuilderType, FieldType> {
  List<String>? _valueRegexes;
  Map<String, dynamic> _hiddenProperties = {};
  bool _isOptional = false;
  int? _numberOfMandatoryInstances;

  /// Added in version 8.0.0
  BuilderType setValueRegexes(List<String> valueRegexes) {
    _valueRegexes = valueRegexes;
    return this as BuilderType;
  }

  /// Added in version 8.0.0
  BuilderType setValueRegex(String valueRegex) {
    _valueRegexes = [...(_valueRegexes ?? []), valueRegex];
    return this as BuilderType;
  }

  /// Added in version 7.2.0
  BuilderType setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this as BuilderType;
  }

  /// Added in version 7.2.0
  BuilderType setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this as BuilderType;
  }

  /// Added in version 7.2.0
  BuilderType isOptional(bool optional) {
    _isOptional = optional;
    return this as BuilderType;
  }

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  BuilderType setNumberOfMandatoryInstances(int? numberOfMandatoryInstances) {
    _numberOfMandatoryInstances = numberOfMandatoryInstances;
    return this as BuilderType;
  }
}

/// Interface for barcode field definitions used in label capture. This interface provides the common functionality for all barcode field types, including symbology settings configuration.
///
/// A barcode field must be configured with at least one symbology. Creating one with an empty symbology set raises an error.
///
/// Added in version 7.2.0
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

  /// The symbology settings used for this barcode field, defining which barcode types are enabled and their specific configurations.
  ///
  /// Added in version 7.2.0
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

/// Builder class for creating barcode field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
abstract class BarcodeFieldBuilder<BuilderType, FieldType> extends LabelFieldDefinitionBuilder<BuilderType, FieldType> {
  /// Sets the symbology that is expected to be present in the barcode field.
  ///
  /// Added in version 7.2.0
  BuilderType setSymbology(Symbology symbology) {
    symbologies.add(symbology);
    return this as BuilderType;
  }

  /// Sets the symbologies that are expected to be present in the barcode field.
  ///
  /// Added in version 7.2.0
  BuilderType setSymbologies(List<Symbology> symbologies) {
    this.symbologies = symbologies;
    return this as BuilderType;
  }

  /// The symbologies that are expected to be present in the barcode field.
  ///
  /// Added in version 7.2.0
  List<Symbology> symbologies = [];
}

/// Defines a barcode field with customizable symbology support and validation regexes. This field type allows you to specify which barcode symbologies should be recognized and optionally apply data validation regexes to the decoded content.
///
/// A custom barcode field must be configured with at least one symbology. Creating one with an empty symbology set raises an error.
///
/// Use the builder pattern with [CustomBarcodeBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
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

  /// Creates a new custom barcode field definition with the given name and symbology settings.
  ///
  /// Added in version 7.2.0
  factory CustomBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return CustomBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  /// Sets the location of the barcode field using a predefined location type.
  ///
  /// Added in version 7.2.0
  void setLocationWithType(LabelFieldLocationType location) {
    _locationType = location;
  }

  /// Sets the location of the barcode field using a rectangle.
  ///
  /// Added in version 7.2.0
  void setLocationWithRect(Rect rect) {
    _location = LabelFieldLocation.forRect(rect);
  }

  /// Sets the location of the barcode field using coordinates.
  ///
  /// Added in version 7.2.0
  void setLocationWithCoordinates(double left, double top, double right, double bottom) {
    _location = LabelFieldLocation.forCoordinates(left, top, right, bottom);
  }

  /// Context-identifying keywords or phrases used to distinguish between fields that may have similar patterns. These patterns help Smart Label Capture identify which field the captured data belongs to when multiple fields could match the same regex.
  ///
  /// For example, when a label contains both expiry date and packing date fields, you can use anchorRegexes like [“exp”, “expiry”] for the expiry date field and [“pack”, “packing”] for the packing date field to help the system correctly identify which date is which.
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// The spatial location constraint for this barcode field within the label. This can be used to specify where on the label this field is expected to appear, helping to improve recognition accuracy and speed by focusing the search area.
  ///
  /// Added in version 7.2.0
  LabelFieldLocation? get location => _location;

  /// Determines whether this field is required for the label to be considered complete. When set to true, the label can be marked as complete even if this field is not found. When false (mandatory), the label will only be complete when this field is successfully captured.
  ///
  /// Optional fields are useful for scenarios where certain information might not always be present on labels, such as promotional codes or secondary identifiers.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of the barcode field.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// Regular expressions used to validate the decoded barcode content. These patterns allow you to ensure that the captured barcode data matches the expected format for your specific use case.
  ///
  /// For example, you can use regexes like [“^[0-9]{12,13}$”] to ensure the barcode contains only 12-13 digits, or [“^[A-Z0-9]{17}$”] for VIN codes that must be exactly 17 alphanumeric characters.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The barcode symbologies (formats) that this field should recognize. This allows you to specify which types of barcodes are expected for this field, such as Code 128, EAN-13, or Data Matrix.
  ///
  /// Restricting symbologies improves recognition accuracy and performance by focusing the scanner on the expected barcode formats for each field.
  ///
  /// Added in version 7.2.0
  @override
  List<SymbologySettings> get symbologies => _symbologies;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
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

/// Builder class for creating [CustomBarcode] field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
class CustomBarcodeBuilder extends BarcodeFieldBuilder<CustomBarcodeBuilder, CustomBarcode> {
  List<String>? _anchorRegexes;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  CustomBarcodeBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// Creates a [CustomBarcode] field definition with the specified name and all configured properties. This method finalizes the builder configuration and returns a field definition that can be added to a [LabelDefinition].
  ///
  /// Added in version 7.2.0
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

/// Interface for text field definitions used in label capture. This interface provides the common functionality for all text field types, including regex validation and text recognition settings.
///
/// Added in version 7.2.0
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

/// Builder class for creating text field definitions. Provides a fluent interface for configuring text field properties including validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
abstract class TextFieldBuilder<BuilderType, FieldType> extends LabelFieldDefinitionBuilder<BuilderType, FieldType> {}

/// Defines a text field with customizable OCR recognition and validation regexes. This field type uses optical character recognition (OCR) to extract text content from labels and can apply regexes for content validation.
///
/// Use the builder pattern with [CustomTextBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
class CustomText extends TextField {
  LabelFieldLocationType? _locationType;
  LabelFieldLocation? _location;

  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  CustomText(String name) : super._(name, 'customText');

  /// Sets the location of the text field using a predefined location type.
  ///
  /// Added in version 7.2.0
  void setLocationWithType(LabelFieldLocationType location) {
    _locationType = location;
  }

  /// Sets the location of the text field using a rectangle.
  ///
  /// Added in version 7.2.0
  void setLocationWithRect(Rect rect) {
    _location = LabelFieldLocation.forRect(rect);
  }

  /// Sets the location of the text field using coordinates.
  ///
  /// Added in version 7.2.0
  void setLocationWithCoordinates(double left, double top, double right, double bottom) {
    _location = LabelFieldLocation.forCoordinates(left, top, right, bottom);
  }

  /// Context-identifying keywords or phrases used to distinguish between fields that may have similar patterns. These patterns help Smart Label Capture identify which field the captured data belongs to when multiple fields could match the same regex.
  ///
  /// For example, when a label contains both expiry date and packing date fields, you can use anchorRegexes like [“exp”, “expiry”] for the expiry date field and [“pack”, “packing”] for the packing date field to help the system correctly identify which date is which.
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// The spatial location constraint for this text field within the label. This can be used to specify where on the label this field is expected to appear, helping to improve recognition accuracy and speed by focusing the OCR processing area.
  ///
  /// Added in version 7.2.0
  LabelFieldLocation? get location => _location;

  /// Determines whether this field is required for the label to be considered complete. When set to true, the label can be marked as complete even if this field is not found. When false (mandatory), the label will only be complete when this field is successfully captured.
  ///
  /// Optional fields are useful for scenarios where certain information might not always be present on labels, such as promotional text or secondary identifiers.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The unique identifier for this text field within the label definition. This name is used to reference the field when processing captured results and must be unique within the label definition.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// Regular expressions used to validate the recognized text content. These regexes allow you to ensure that the captured text matches the expected format for your specific use case.
  ///
  /// For example, you can use regexes like [“\d{2}/\d{2}/\d{4}”] for date formats, or [“[A-Z]{2}\d{6}”] for codes that must start with two letters followed by six digits.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
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

/// Builder class for creating [CustomText] field definitions. Provides a fluent interface for configuring text field properties including validation regexes, location constraints, and OCR-specific settings.
///
/// Added in version 7.2.0
class CustomTextBuilder extends TextFieldBuilder<CustomTextBuilder, CustomText> {
  List<String>? _anchorRegexes;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
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

  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  CustomTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  CustomTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// Creates a [CustomText] field definition with the specified name and all configured properties.
  ///
  /// Added in version 7.2.0
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

/// A specialized text field for capturing expiry dates. This predefined field type is optimized for recognizing date formats commonly found on product labels, packaging, and documents.
///
/// The field can be configured with specific date formats using [LabelDateFormat] to ensure proper parsing of various date representations (MM/dd/yyyy, dd.MM.yyyy, etc.).
///
/// Use the builder pattern with [ExpiryDateTextBuilder] for convenient configuration.
///
/// Added in version 7.2.0
class ExpiryDateText extends TextField {
  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  ExpiryDateText(String name) : super._(name, 'expiryDateText');

  /// Used to get and set the [LabelDateFormat] used to parse dates.
  ///
  /// Added in version 7.2.0
  LabelDateFormat? labelDateFormat;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// Returns the name associated with this instance.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

/// This class is used to define an expiry date field for a [LabelDefinition] in a fluent way.
///
/// Added in version 7.2.0
class ExpiryDateTextBuilder extends TextFieldBuilder<ExpiryDateTextBuilder, ExpiryDateText> {
  LabelDateFormat? _labelDateFormat;

  List<String>? _anchorRegexes;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  ExpiryDateTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// Sets a [LabelDateFormat] to use when recognising this date.
  ///
  /// Added in version 7.2.0
  ExpiryDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  /// All pre-built fields come with default valueRegexes and anchorRegexes that are suitable for most use cases. Using either method is optional and will override the defaults.
  ///
  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  ExpiryDateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Builds the [ExpiryDateText] using the properties provided previously with other methods.
  ///
  /// Added in version 7.2.0
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

/// A specialized barcode field for capturing the first IMEI (International Mobile Equipment Identity) number from smart device labels. This predefined field type is optimized for recognizing IMEI barcodes typically found on mobile device packaging and labels.
///
/// Use the builder pattern with [ImeiOneBarcodeBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
class ImeiOneBarcode extends BarcodeField {
  ImeiOneBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  ImeiOneBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory ImeiOneBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return ImeiOneBarcode._(name, symbologySettings, 'imeiOneBarcode');
  }

  factory ImeiOneBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return ImeiOneBarcode._fromSymbologies(name, symbologies.toList(), 'imeiOneBarcode');
  }
  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  factory ImeiOneBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return ImeiOneBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of the field.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The symbologies for the field.
  ///
  /// Added in version 7.2.0
  @override
  List<SymbologySettings> get symbologies => _symbologies;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Builder class for creating [ImeiOneBarcode] field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
class ImeiOneBarcodeBuilder extends BarcodeFieldBuilder<ImeiOneBarcodeBuilder, ImeiOneBarcode> {
  /// Builds the [ImeiOneBarcode] using the properties provided previously with other methods.
  ///
  /// Added in version 7.2.0
  ImeiOneBarcode build(String name) {
    final instance = ImeiOneBarcode._fromSymbologies(name, symbologies, 'imeiOneBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

/// A specialized barcode field for capturing the second IMEI (International Mobile Equipment Identity) number from smart device labels. This predefined field type is optimized for dual-SIM devices that have two IMEI numbers on their labels.
///
/// Use the builder pattern with [ImeiTwoBarcodeBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
class ImeiTwoBarcode extends BarcodeField {
  ImeiTwoBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  ImeiTwoBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory ImeiTwoBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return ImeiTwoBarcode._(name, symbologySettings, 'imeiTwoBarcode');
  }

  factory ImeiTwoBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return ImeiTwoBarcode._fromSymbologies(name, symbologies.toList(), 'imeiTwoBarcode');
  }

  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  factory ImeiTwoBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return ImeiTwoBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of the field.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The symbologies for the field.
  ///
  /// Added in version 7.2.0
  @override
  List<SymbologySettings> get symbologies => _symbologies;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Builder class for creating [ImeiTwoBarcode] field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
class ImeiTwoBarcodeBuilder extends BarcodeFieldBuilder<ImeiTwoBarcodeBuilder, ImeiTwoBarcode> {
  /// Builds the [ImeiTwoBarcode] using the properties provided previously with other methods.
  ///
  /// Added in version 7.2.0
  ImeiTwoBarcode build(String name) {
    final instance = ImeiTwoBarcode._fromSymbologies(name, symbologies, 'imeiTwoBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

/// A specialized text field for capturing packing dates from labels. This predefined field type is optimized for recognizing date formats commonly found on food packaging, pharmaceutical labels, and manufacturing date stamps.
///
/// The field can be configured with specific date formats using [LabelDateFormat] to ensure proper parsing of various date representations.
///
/// Use the builder pattern with [PackingDateTextBuilder] for convenient configuration.
///
/// Added in version 7.2.0
class PackingDateText extends TextField {
  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  PackingDateText(String name) : super._(name, 'packingDateText');

  /// Used to get and set the [LabelDateFormat] used to parse dates.
  ///
  /// Added in version 7.2.0
  LabelDateFormat? labelDateFormat;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// Returns the name associated with this instance.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['labelDateFormat'] = labelDateFormat?.toMap();
    return json;
  }
}

/// This class is used to define a packing date field for a [LabelDefinition] in a fluent way.
///
/// Added in version 7.2.0
class PackingDateTextBuilder extends TextFieldBuilder<PackingDateTextBuilder, PackingDateText> {
  LabelDateFormat? _labelDateFormat;

  List<String>? _anchorRegexes;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  PackingDateTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// Sets a [LabelDateFormat] to use when recognising this date.
  ///
  /// Added in version 7.2.0
  PackingDateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  /// All pre-built fields come with default valueRegexes and anchorRegexes that are suitable for most use cases. Using either method is optional and will override the defaults.
  ///
  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  PackingDateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Builds the [PackingDateText] using the properties provided previously with other methods.
  ///
  /// Added in version 7.2.0
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

/// A specialized barcode field for capturing part numbers. This predefined field type is configured with default settings optimized for common part number barcode formats used in manufacturing, inventory, and logistics.
///
/// Use the builder pattern with [PartNumberBarcodeBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
class PartNumberBarcode extends BarcodeField {
  PartNumberBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  PartNumberBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory PartNumberBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return PartNumberBarcode._(name, symbologySettings, 'partNumberBarcode');
  }

  factory PartNumberBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return PartNumberBarcode._fromSymbologies(name, symbologies.toList(), 'partNumberBarcode');
  }

  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  factory PartNumberBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return PartNumberBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of this field definition, used to identify it within the label definition.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The list of barcode symbologies that this field can accept, along with their specific settings.
  ///
  /// Added in version 7.2.0
  @override
  List<SymbologySettings> get symbologies => _symbologies;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Builder class for creating [PartNumberBarcode] field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
class PartNumberBarcodeBuilder extends BarcodeFieldBuilder<PartNumberBarcodeBuilder, PartNumberBarcode> {
  /// Builds a [PartNumberBarcode] field definition with the specified name.
  ///
  /// Added in version 7.2.0
  PartNumberBarcode build(String name) {
    final instance = PartNumberBarcode._fromSymbologies(name, symbologies, 'partNumberBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties = _hiddenProperties;
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

/// A specialized barcode field for capturing serial numbers. This predefined field type is configured with default settings optimized for common serial number barcode formats.
///
/// Use the builder pattern with [SerialNumberBarcodeBuilder] for convenient configuration, or create instances directly using the various factory methods.
///
/// Added in version 7.2.0
class SerialNumberBarcode extends BarcodeField {
  SerialNumberBarcode._(super.name, super.symbologies, super._fieldType) : super._();

  SerialNumberBarcode._fromSymbologies(super.name, super.symbologies, super._fieldType) : super._fromSymbologies();

  factory SerialNumberBarcode.initWithNameAndSymbologySettings(String name, List<SymbologySettings> symbologySettings) {
    return SerialNumberBarcode._(name, symbologySettings, 'serialNumberBarcode');
  }

  factory SerialNumberBarcode.initWithNameAndSymbologies(String name, Set<Symbology> symbologies) {
    return SerialNumberBarcode._fromSymbologies(name, symbologies.toList(), 'serialNumberBarcode');
  }

  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  factory SerialNumberBarcode.initWithNameAndSymbology(String name, Symbology symbology) {
    return SerialNumberBarcode.initWithNameAndSymbologies(name, {symbology});
  }

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of this field definition, used to identify it within the label definition.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The list of barcode symbologies that this field can accept, along with their specific settings.
  ///
  /// Added in version 7.2.0
  @override
  List<SymbologySettings> get symbologies => _symbologies;

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Builder class for creating [SerialNumberBarcode] field definitions. Provides a fluent interface for configuring barcode field properties including symbologies, validation regexes, location constraints, and other field-specific settings.
///
/// Added in version 7.2.0
class SerialNumberBarcodeBuilder extends BarcodeFieldBuilder<SerialNumberBarcodeBuilder, SerialNumberBarcode> {
  /// Builds a [SerialNumberBarcode] field definition with the specified name.
  ///
  /// Added in version 7.2.0
  SerialNumberBarcode build(String name) {
    final instance = SerialNumberBarcode._fromSymbologies(name, symbologies, 'serialNumberBarcode')
      .._isOptional = _isOptional
      .._numberOfMandatoryInstances = _numberOfMandatoryInstances
      .._hiddenProperties.addAll(_hiddenProperties);
    if (_valueRegexes != null) instance._valueRegexes = _valueRegexes;
    return instance;
  }
}

/// A specialized text field for capturing total price information from labels. This predefined field type is optimized for recognizing price values typically found on retail product labels, receipts, and price tags.
///
/// Use the builder pattern with [TotalPriceTextBuilder] for convenient configuration.
///
/// Added in version 7.2.0
class TotalPriceText extends TextField {
  /// Builds a new instance of this class with the provided name.
  ///
  /// Added in version 7.2.0
  TotalPriceText(String name) : super._(name, 'totalPriceText');

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// Returns the name associated with this instance.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Added in version 7.2.0
class TotalPriceTextBuilder extends TextFieldBuilder<TotalPriceTextBuilder, TotalPriceText> {
  List<String>? _anchorRegexes;

  /// Sets the identifying text anchor regexes from from a list of strings.
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  TotalPriceTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// All pre-built fields come with default valueRegexes and anchorRegexes that are suitable for most use cases. Using either method is optional and will override the defaults.
  ///
  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  TotalPriceTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Added in version 7.2.0
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

/// A specialized text field for capturing unit price information from labels. This predefined field type is optimized for recognizing individual item prices on retail labels.
///
/// Use the builder pattern with [UnitPriceTextBuilder] for convenient configuration.
///
/// Added in version 7.2.0
class UnitPriceText extends TextField {
  /// Added in version 7.2.0
  UnitPriceText(String name) : super._(name, 'unitPriceText');

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of this field definition.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Builder class for creating [UnitPriceText] field definitions. Provides a fluent interface for configuring unit price text field properties including validation regexes and anchor regexes.
///
/// Added in version 7.2.0
class UnitPriceTextBuilder extends TextFieldBuilder<UnitPriceTextBuilder, UnitPriceText> {
  List<String>? _anchorRegexes;

  /// Sets the identifying anchor regexes from a list of strings.
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  UnitPriceTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// All pre-built fields come with default valueRegexes and anchorRegexes that are suitable for most use cases. Using either method is optional and will override the defaults.
  ///
  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  UnitPriceTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Creates a [UnitPriceText] field definition with the specified name and all configured properties.
  ///
  /// Added in version 7.2.0
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

/// A specialized text field for capturing weight information from labels. This predefined field type is optimized for recognizing weight values typically found on product packaging, shipping labels, and inventory tags.
///
/// Use the builder pattern with [WeightTextBuilder] for convenient configuration.
///
/// Added in version 7.2.0
class WeightText extends TextField {
  /// Added in version 7.2.0
  WeightText(String name) : super._(name, 'weightText');

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 7.2.0
  @override
  bool get isOptional => _isOptional;

  /// The name of this field definition, used to identify it within the label definition.
  ///
  /// Added in version 7.2.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.0.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;
}

/// Added in version 7.2.0
class WeightTextBuilder extends TextFieldBuilder<WeightTextBuilder, WeightText> {
  List<String>? _anchorRegexes;

  /// Sets the identifying anchor regexes from a list of strings.
  ///
  /// Added in version 8.0.0
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

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.0.0
  WeightTextBuilder setAnchorRegex(RegExp anchorRegex) {
    _anchorRegexes ??= [];
    _anchorRegexes?.add(anchorRegex.pattern);
    return this;
  }

  /// All pre-built fields come with default valueRegexes and anchorRegexes that are suitable for most use cases. Using either method is optional and will override the defaults.
  ///
  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.0.0
  WeightTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Added in version 7.2.0
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

/// This class is used to define a date field in a [LabelDefinition].
///
/// Added in version 8.3.0
class DateText extends TextField {
  late final LabelDateFormat _labelDateFormat;

  /// Builds a new instance of this class with the provided name and date format.
  ///
  /// Added in version 8.3.0
  DateText(String name, LabelDateFormat labelDateFormat) : super._(name, 'dateText') {
    _labelDateFormat = labelDateFormat;
  }

  /// Returns the [LabelDateFormat] used to parse dates.
  ///
  /// Added in version 8.3.0
  LabelDateFormat get labelDateFormat => _labelDateFormat;

  /// Whether the field is optional or mandatory. This is helpful when certain fields may not be present on every scan.
  ///
  /// Added in version 8.3.0
  @override
  bool get isOptional => _isOptional;

  /// Returns the name associated with this instance.
  ///
  /// Added in version 8.3.0
  @override
  String get name => _name;

  /// The regexes that identify the target string in the scanned content.
  ///
  /// Added in version 8.3.0
  @override
  List<String> get valueRegexes => _valueRegexes ?? [];

  /// The minimum number of instances of this field that must be captured for the label to be considered complete. This is useful for fields that may appear multiple times on a label, such as multiple serial numbers or repeated information.
  ///
  /// Added in version 8.3.0
  @override
  int? get numberOfMandatoryInstances => _numberOfMandatoryInstances;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.3.0
  List<String> get anchorRegexes => _anchorRegexes ?? [];
}

/// Builder class for creating [DateText] field definitions. Provides a fluent interface for configuring text field properties including validation regexes, location constraints, and OCR-specific settings.
///
/// Added in version 8.3.0
class DateTextBuilder extends TextFieldBuilder<DateTextBuilder, DateText> {
  List<String>? _anchorRegexes;
  LabelDateFormat? _labelDateFormat;

  /// Used to specify keywords or phrases that help identify the context of the field. This is particularly useful when the label contains multiple fields that could match the same regex (e.g., when both packaging and expiry dates are present).
  ///
  /// Added in version 8.3.0
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

  /// This method can be used to remove the default anchorRegex, allowing you to rely solely on the valueRegexes for detection.
  ///
  /// Added in version 8.3.0
  DateTextBuilder resetAnchorRegexes() {
    _anchorRegexes?.clear();
    return this;
  }

  /// Sets a [LabelDateFormat] to use when recognising this date.
  ///
  /// Added in version 8.3.0
  DateTextBuilder setLabelDateFormat(LabelDateFormat labelDateFormat) {
    _labelDateFormat = labelDateFormat;
    return this;
  }

  /// Creates a [DateText] field definition with the specified name and all configured properties.
  ///
  /// Added in version 8.3.0
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
