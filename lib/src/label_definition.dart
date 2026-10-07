import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field_definition.dart';

class LabelDefinition implements Serializable {
  final String _name;

  List<LabelFieldDefinition> _fields = [];

  Map<String, dynamic> _hiddenProperties = {};

  LabelDefinition(String name)
      : _name = name,
        _fields = [];

  static LabelDefinitionBuilder builder() {
    return LabelDefinitionBuilder();
  }

  void addField(LabelFieldDefinition field) {
    _fields.add(field);
  }

  void addFields(List<LabelFieldDefinition> fields) {
    _fields.addAll(fields);
  }

  String get name => _name;

  List<LabelFieldDefinition> get fields => _fields;

  @override
  Map<String, dynamic> toMap() {
    final json = {
      'name': name,
      'fields': fields.map((e) => e.toMap()).toList(),
    };

    for (final hiddenProp in _hiddenProperties.entries) {
      json[hiddenProp.key] = hiddenProp.value;
    }

    return json;
  }
}

class LabelDefinitionBuilder {
  final List<LabelFieldDefinition> _fields = [];
  Map<String, dynamic> _hiddenProperties = {};

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

  LabelDefinition build(String name) {
    return LabelDefinition(name)
      .._fields = _fields
      .._hiddenProperties = _hiddenProperties;
  }
}
