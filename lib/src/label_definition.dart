import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';

class LabelDefinition implements Serializable {
  final String _name;
  String? _type;

  List<LabelFieldDefinition> _fields = [];

  Map<String, dynamic> _hiddenProperties = {};

  LabelDefinition(String name)
      : _name = name,
        _fields = [];

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

  void addField(LabelFieldDefinition field) {
    _fields.add(field);
  }

  void addFields(List<LabelFieldDefinition> fields) {
    _fields.addAll(fields);
  }

  String get name => _name;

  List<LabelFieldDefinition> get fields => _fields;

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

class LabelDefinitionBuilder {
  final List<LabelFieldDefinition> _fields = [];
  Map<String, dynamic> _hiddenProperties = {};
  AdaptiveRecognitionMode _adaptiveRecognitionMode = AdaptiveRecognitionMode.off;
  LabelDefinitionBuilder addSerialNumberBarcode(SerialNumberBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  LabelDefinitionBuilder addPartNumberBarcode(PartNumberBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  LabelDefinitionBuilder addImeiOneBarcode(ImeiOneBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  LabelDefinitionBuilder addImeiTwoBarcode(ImeiTwoBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  LabelDefinitionBuilder addCustomBarcode(CustomBarcode barcode) {
    _fields.add(barcode);
    return this;
  }

  LabelDefinitionBuilder addUnitPriceText(UnitPriceText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder addTotalPriceText(TotalPriceText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder addWeightText(WeightText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder addPackingDateText(PackingDateText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder addExpiryDateText(ExpiryDateText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder addCustomText(CustomText text) {
    _fields.add(text);
    return this;
  }

  LabelDefinitionBuilder setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this;
  }

  LabelDefinitionBuilder setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties = hiddenProperties;
    return this;
  }

  LabelDefinitionBuilder adaptiveRecognition(AdaptiveRecognitionMode mode) {
    _adaptiveRecognitionMode = mode;
    return this;
  }

  LabelDefinition build(String name) {
    return LabelDefinition(name)
      .._fields = _fields
      .._hiddenProperties = _hiddenProperties
      ..adaptiveRecognitionMode = _adaptiveRecognitionMode;
  }
}
