/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_barcode/src/barcode_defaults.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';

/// Configures label capture parameters and defines the structure of labels to be captured. This settings object is central to the Smart Label Capture workflow, specifying which label definitions to use, recognition parameters, and capture behavior.
///
/// Key configuration aspects:
///
/// - **Label definitions** - Defines field types (barcodes, dates, text) and their validation rules
/// - **Recognition parameters** - Controls scanning behavior and accuracy
/// - **Location selection** - Specifies scanning areas and constraints
/// - **Symbology settings** - Configures which barcode types are enabled
///
/// The settings follow a fluent builder pattern for convenient configuration and support multiple label definitions to handle different types of labels in the same scanning session. For the settings to take effect, they must be applied to a label capture ([LabelCapture]) instance using the appropriate apply settings method. The same holds for settings already applied: changes made to them afterwards take effect only once the settings are applied again.
///
/// Added in version 7.2.0
class LabelCaptureSettings implements Serializable {
  final Map<String, dynamic> _properties;
  final List<LabelDefinition> _definitions;

  /// Defines the strategy with which to select one out of many visible labels. By default, this property is *null* and label selection is disabled.
  ///
  /// Currently only [RectangularLocationSelection] is supported.
  ///
  /// Added in version 7.2.0
  LocationSelection? locationSelection;

  LabelCaptureSettings._(this._definitions, this._properties);

  /// Load the settings from an array of [LabelDefinition] with optional hidden properties
  ///
  /// Added in version 7.2.0
  LabelCaptureSettings(List<LabelDefinition> definitions) : this._(definitions, {});

  factory LabelCaptureSettings.withProperties(List<LabelDefinition> definitions, Map<String, dynamic> properties) {
    return LabelCaptureSettings._(definitions, properties);
  }

  /// Creates a Label Capture Settings Builder that allows you to fluently configure label definitions and capture settings.
  ///
  /// Added in version 7.2.0
  static LabelCaptureSettingsBuilder builder() {
    return LabelCaptureSettingsBuilder();
  }

  /// Gets [SymbologySettings] specific for the given [Symbology].
  ///
  /// Note that modifying the returned object doesn’t automatically apply the changes to [LabelCapture]. After you made changes to the symbology settings, call LabelCapture.applySettings() with these [LabelCaptureSettings] to apply them.
  ///
  /// Added in version 7.4.0
  SymbologySettings settingsForSymbology(Symbology symbology) {
    var identifier = symbology.toString();
    return BarcodeDefaults.symbologySettingsDefaults[identifier]!;
  }

  /// Sets a property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may change in a future release.
  ///
  /// Added in version 7.2.0
  void setProperty<T>(String name, T value) {
    _properties[name] = value;
  }

  /// Retrieves the value of a previously set property. In case the property does not exist, *null* is returned. Use this method to get properties that are not yet part of a stable API. These properties may change in a future release.
  ///
  /// Added in version 7.2.0
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

/// Builder class for creating [LabelCaptureSettings] objects. Provides a fluent interface for configuring label capture settings including label definitions, hidden properties, and other settings.
///
/// Added in version 7.2.0
class LabelCaptureSettingsBuilder {
  final List<LabelDefinition> _labels = [];
  final Map<String, dynamic> _hiddenProperties = {};

  /// Adds a new label definition to the settings.
  ///
  /// Added in version 7.2.0
  LabelCaptureSettingsBuilder addLabel(LabelDefinition label) {
    _labels.add(label);
    return this;
  }

  /// Sets a hidden property to be used when creating the [LabelCaptureSettings] object.
  ///
  /// Added in version 7.2.0
  LabelCaptureSettingsBuilder setHiddenProperty(String key, dynamic value) {
    _hiddenProperties[key] = value;
    return this;
  }

  /// Sets hidden properties to be used when creating the [LabelCaptureSettings] object.
  ///
  /// Added in version 7.2.0
  LabelCaptureSettingsBuilder setHiddenProperties(Map<String, dynamic> hiddenProperties) {
    _hiddenProperties.addAll(hiddenProperties);
    return this;
  }

  /// Builds the settings object.
  ///
  /// Added in version 7.2.0
  LabelCaptureSettings build() {
    return LabelCaptureSettings._(_labels, _hiddenProperties);
  }
}
