import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';

/// A configuration that defines labels and their relevant fields for Smart Label Capture to recognize and extract during scans. Label definitions provide flexible data extraction from specific label layouts without custom coding, enabling structured data extraction from diverse label types.
///
/// Label definitions support two primary approaches:
///
/// - **Pre-built Labels** - Includes predefined configurations for common label types (price labels, VIN labels, 7-segment displays)
/// - **Custom Labels** - Allows creating unique label definitions using custom barcode and text fields
///
/// Key configuration options for custom fields:
///
/// - **valueRegexes** - Regular expressions to identify target strings
/// - **anchorRegexes** - Context-identifying keywords for field recognition
/// - **symbologies** - Specific barcode types to match
/// - **isOptional** - Determines field requirement status
///
/// Pre-built field categories include:
///
/// - **Barcode Fields** - Serial number, part number, IMEI
/// - **Price/Weight Fields** - Unit price, total price, weight
/// - **Date/Text Fields** - Packing date, expiry date
///
/// You can create label definitions in three ways:
///
/// - **Builder Pattern** - Use [LabelDefinitionBuilder] for fluent configuration
/// - **Manual Construction** - Create with explicit field lists creating a new [LabelDefinition] object and adding fields with [LabelDefinition.addField] or [LabelDefinition.addFields]
///
/// Added in version 7.2.0
class LabelDefinition implements Serializable {
  final String _name;
  String? _type;

  List<LabelFieldDefinition> _fields = [];

  Map<String, dynamic> _hiddenProperties = {};

  /// Creates a predefined label definition for reading numeric values from 7-segment displays, such as digital scales, meters, or other electronic displays.
  ///
  /// This factory method returns a label definition with one field:
  ///
  /// - **weight** - A text field for 7-segment displays with pattern `[0-9OQB]{1,4}[\.\,\s]?[0-9OQB]{1,4}`
  ///
  /// The pattern accounts for common variations in 7-segment displays where certain characters may appear similar (e.g., ‘O’ for ‘0’, ‘Q’ for ‘0’, ‘B’ for ‘8’).
  ///
  /// Added in version 8.3.0
  LabelDefinition(String name)
      : _name = name,
        _fields = [];

  /// Creates a new label definition builder.
  ///
  /// Added in version 7.2.0
  static LabelDefinitionBuilder builder() {
    return LabelDefinitionBuilder();
  }

  factory LabelDefinition.vinLabelDefinitionWithName(String name) {
    final definition = LabelDefinition(name);
    definition._type = 'vin';
    return definition;
  }

  factory LabelDefinition.priceCaptureDefinitionWithName(String name) {
    final definition = LabelDefinition(name);
    definition._type = 'priceCapture';
    return definition;
  }

  factory LabelDefinition.sevenSegmentDisplayLabelDefinitionWithName(String name) {
    final definition = LabelDefinition(name);
    definition._type = 'sevenSegment';
    return definition;
  }

  /// Adds a field to the label definition.
  ///
  /// Added in version 7.2.0
  void addField(LabelFieldDefinition field) {
    _fields.add(field);
  }

  /// Adds multiple fields to the label definition.
  ///
  /// Added in version 7.2.0
  void addFields(List<LabelFieldDefinition> fields) {
    _fields.addAll(fields);
  }

  /// The name of the label definition.
  ///
  /// Added in version 7.2.0
  String get name => _name;

  /// The fields of the label definition.
  ///
  /// Added in version 7.2.0
  List<LabelFieldDefinition> get fields => _fields;

  /// Controls whether the **Adaptive Recognition Engine** is enabled for this label definition. The **Adaptive Recognition Engine** helps making Smart Label Capture more robust and scalable thanks to its larger, more capable model hosted in the cloud. Whenever Smart Label Capture’s on-device model fails to capture data, the SDK will automatically trigger the **Adaptive Recognition Engine** to capture complex, unforeseen data capture and process it with high accuracy and reliability. See [AdaptiveRecognitionMode] for available options. Defaults to [AdaptiveRecognitionMode.off].
  ///
  /// Added in version 8.3.0
  AdaptiveRecognitionMode adaptiveRecognitionMode = AdaptiveRecognitionMode.off;

  @override
  Map<String, dynamic> toMap() {
    final json = {
      'name': name,
      'fields': fields.map((e) => e.toMap()).toList(),
      'adaptiveRecognitionMode': adaptiveRecognitionMode.toString(),
    };
    if (_type != null) {
      json['type'] = _type!;
    }

    for (final hiddenProp in _hiddenProperties.entries) {
      json[hiddenProp.key] = hiddenProp.value;
    }

    return json;
  }
}

/// A fluent builder class for creating [LabelDefinition] objects with a convenient, chainable interface. This builder provides methods to add various field types (barcodes, text fields, dates) and configure their properties in a structured manner.
///
/// The LabelDefinitionBuilder enables you to construct complex label definitions by adding multiple field types:
///
/// - **Barcode Fields** - Serial numbers, part numbers, IMEI codes, custom barcodes
/// - **Text Fields** - Unit prices, total prices, weight information, custom text, date fields (for example, packing dates, expiry dates with configurable formats)
///
/// Each field can be configured with validation regexes, optional status, and symbology settings where applicable. The builder pattern ensures type safety and provides a clear, readable way to define label structures.
///
/// This builder is the recommended approach for creating label definitions as it provides better type safety and readability compared to manual construction.
///
/// Added in version 7.2.0
class LabelDefinitionBuilder {
  final List<LabelFieldDefinition> _fields = [];
  Map<String, dynamic> _hiddenProperties = {};
  AdaptiveRecognitionMode _adaptiveRecognitionMode = AdaptiveRecognitionMode.off;
  /// Adds a pre-configured serial number barcode field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addSerialNumberBarcode(SerialNumberBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  /// Adds a pre-configured part number barcode field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addPartNumberBarcode(PartNumberBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  /// Adds a pre-configured IMEI-1 barcode field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addImeiOneBarcode(ImeiOneBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  /// Adds a pre-configured IMEI-2 barcode field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addImeiTwoBarcode(ImeiTwoBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  /// Adds a pre-configured custom barcode field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addCustomBarcode(CustomBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  /// Adds a pre-configured unit price text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addUnitPriceText(UnitPriceText text) {
    _fields.add(text);
    return this;
  }

  /// Adds a pre-configured total price text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addTotalPriceText(TotalPriceText text) {
    _fields.add(text);
    return this;
  }

  /// Adds a pre-configured weight text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addWeightText(WeightText text) {
    _fields.add(text);
    return this;
  }

  /// Adds a pre-configured packing date text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addPackingDateText(PackingDateText text) {
    _fields.add(text);
    return this;
  }

  /// Adds a pre-configured expiry date text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addExpiryDateText(ExpiryDateText text) {
    _fields.add(text);
    return this;
  }

  /// Adds a pre-configured custom text field to the label definition.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder addCustomText(CustomText text) {
    _fields.add(text);
    return this;
  }

  /// Sets a hidden property to be used when creating the [LabelDefinition] object.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this;
  }

  /// Sets hidden properties to be used when creating the [LabelDefinition] object.
  ///
  /// Added in version 7.2.0
  LabelDefinitionBuilder setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this;
  }

  /// Sets the adaptive recognition mode for the label definition being built. Controls whether cloud-based processing is used as a backup for on-device processing. See [AdaptiveRecognitionMode] for available options.
  ///
  /// Added in version 8.3.0
  LabelDefinitionBuilder adaptiveRecognition(AdaptiveRecognitionMode mode) {
    _adaptiveRecognitionMode = mode;
    return this;
  }

  /// Builds the [LabelDefinition] object with the given name. On web the `name` argument is optional when it was supplied to the constructor.
  ///
  /// Added in version 7.2.0
  LabelDefinition build(String name) {
    return LabelDefinition(name)
      .._fields = _fields
      .._hiddenProperties = _hiddenProperties
      ..adaptiveRecognitionMode = _adaptiveRecognitionMode;
  }
}
