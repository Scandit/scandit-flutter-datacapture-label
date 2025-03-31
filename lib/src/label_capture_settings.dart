/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';

class LabelCaptureSettings implements Serializable {
  final Map<String, dynamic> _properties;
  final List<LabelDefinition> _definitions;

  LocationSelection? locationSelection;

  LabelCaptureSettings._(this._definitions, this._properties);

  LabelCaptureSettings(List<LabelDefinition> definitions) : this._(definitions, {});

  factory LabelCaptureSettings.withProperties(List<LabelDefinition> definitions, Map<String, dynamic> properties) {
    return LabelCaptureSettings._(definitions, properties);
  }

  static LabelCaptureSettingsBuilder builder() {
    return LabelCaptureSettingsBuilder();
  }

  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  T getProperty<T>(String name) {
    return _properties[name] as T;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'labelDefinitions': _definitions.map((e) => e.toMap()).toList(),
      'properties': _properties,
      'locationSelection': locationSelection?.toMap(),
    };
  }
}

class LabelCaptureSettingsBuilder {
  final List<LabelDefinition> _labels = [];
  final Map<String, dynamic> _hiddenProperties = {};

  LabelCaptureSettingsBuilder addLabel(LabelDefinition label) {
    _labels.add(label);
    return this;
  }

  LabelCaptureSettingsBuilder setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this;
  }

  LabelCaptureSettingsBuilder setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties.addAll(hiddenProperties);
    return this;
  }

  LabelCaptureSettings build() {
    return LabelCaptureSettings._(_labels, _hiddenProperties);
  }
}
