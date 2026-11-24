/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/label.json
//
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// Wire-format names (schema property/enum-value strings, e.g.
// `number_of_mandatory_instances`, `royal_mail_4state`) are preserved
// verbatim as Dart identifiers for fidelity with the JSON payload; they are
// not renamed to lowerCamelCase.
//
// Typed classes + throwing fromJson/toJson derived from the serialization
// JSON schemas referenced by this module's bridge params. No runtime
// dependency: validation is hand-rolled below, not json_serializable/built_value.
//
// fromJson enforces only the JSON Schema keywords expressible without a
// schema engine: required, type, enum, string const, additionalProperties,
// null-ness, and root-level oneOf (dispatched on the discriminator to the
// matching variant's fromJson).
// NOT enforced -- a payload violating one of these still parses:
//   pattern, minimum/maximum, minLength/maxLength, multipleOf, and
//   property-level oneOf of more than one non-null variant (those
//   properties are typed Object? and left unvalidated).
//
// Each plain object class also gets a top-level `buildX` function: a
// shallow-typed, validation-free map builder for outbound (Dart -> native)
// payloads. It never parses or throws.
//
// THE BUILDER CONTRACT (stated once here; each buildX carries a one-line
// pointer back to it rather than repeating this block 300+ times).
//
// Outbound payloads are deliberately NOT runtime-validated. The generated
// `fromJson` enforces `additionalProperties: false`, so validating outbound
// would turn the next property added to a public model into a customer-facing
// throw. Compile-time named parameters give the shape guarantee instead.
//
// Emit rule -- "key absent" and "key present and null" are DIFFERENT
// instructions to the deserializers, so the builder reproduces exactly what
// the caller asked for and nothing more:
//   - required                -> always written (omitting it would make
//                                `fromJson` throw "missing required property").
//   - optional, non-nullable  -> omitted when null; null means "not set".
//   - optional + nullable     -> written IF AND ONLY IF the caller passed it,
//                                including when what they passed was null.
//
// That last case is why those parameters are typed `Object?` with an `_unset`
// default instead of their schema type: Dart cannot otherwise tell "passed
// null" from "not passed", and the difference is load-bearing. The schema
// declares null a valid value for these (core/data_capture_view.json documents
// `focusGesture` as "Set to null to disable", and the C++ side branches on
// `containsNull` before falling back to the current value for an absent key),
// so writing the key when the caller stayed silent is just as wrong as
// dropping one they set. A blanket "always write" did exactly that and
// disabled every Android DataCaptureView by adding `parentId: null`, which
// `DataCaptureViewCreationData.kt` reads with `has()` + `getInt()`.
//
// Consequence worth knowing: the generated class's own `toJson()` omits an
// optional+nullable key when null, while `buildX` preserves the caller's
// explicit null. The asymmetry is intended -- `toJson` round-trips a parsed
// object (inbound), `buildX` expresses a caller's intent (outbound) -- so
// `fromJson(buildX(k: null)).toJson()` drops `k`.
//
// Nested `$ref`/array-of-`$ref` properties are typed shallowly
// (`Object?`/`List<Object?>`, not the generated nested class): those classes
// duplicate the hand-written public models (e.g. Brush, Color, Viewfinder)
// that callers already hold an already-serialized map for, so the builder
// accepts that map directly instead of requiring the generated type.

/// Marker for "this optional+nullable argument was not passed", so a builder
/// can tell that apart from an explicit `null`. See the emit rule above.
class _Unset {
  const _Unset();
}

const Object _unset = _Unset();

/// The label capture mode.
class LabelCapture {
  final String type;
  final LabelCaptureSettings? settings;
  final bool? enabled;
  final LabelCaptureFeedback? feedback;
  final int? modeId;
  final int? parentId;
  final bool? hasListeners;

  const LabelCapture({
    required this.type,
    this.settings,
    this.enabled,
    this.feedback,
    this.modeId,
    this.parentId,
    this.hasListeners,
  });

  factory LabelCapture.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCapture: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'enabled',
      'feedback',
      'modeId',
      'parentId',
      'hasListeners',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCapture: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCapture.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCapture'].contains(typeRaw)) {
        throw FormatException("LabelCapture.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCapture.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureSettings.fromJson(settingsRaw);
    } else if (hasSettings && settingsRaw == null) {
      throw FormatException('LabelCapture.settings: null is not allowed');
    }
    final hasEnabled = raw.containsKey('enabled');
    final enabledRaw = raw['enabled'];
    bool? enabledValue;
    if (hasEnabled && enabledRaw != null) {
      if (enabledRaw is! bool) {
        throw FormatException('LabelCapture.enabled: expected a bool');
      }
      enabledValue = enabledRaw;
    } else if (hasEnabled && enabledRaw == null) {
      throw FormatException('LabelCapture.enabled: null is not allowed');
    }
    final hasFeedback = raw.containsKey('feedback');
    final feedbackRaw = raw['feedback'];
    LabelCaptureFeedback? feedbackValue;
    if (hasFeedback && feedbackRaw != null) {
      feedbackValue = LabelCaptureFeedback.fromJson(feedbackRaw);
    } else if (hasFeedback && feedbackRaw == null) {
      throw FormatException('LabelCapture.feedback: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCapture.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCapture.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCapture.modeId: null is not allowed');
    }
    final hasParentId = raw.containsKey('parentId');
    final parentIdRaw = raw['parentId'];
    int? parentIdValue;
    if (hasParentId && parentIdRaw != null) {
      if (parentIdRaw is! num) {
        throw FormatException('LabelCapture.parentId: expected a number');
      }
      if (parentIdRaw != parentIdRaw.toInt()) {
        throw FormatException('LabelCapture.parentId: expected an integer');
      }
      parentIdValue = parentIdRaw.toInt();
    }
    final hasHasListeners = raw.containsKey('hasListeners');
    final hasListenersRaw = raw['hasListeners'];
    bool? hasListenersValue;
    if (hasHasListeners && hasListenersRaw != null) {
      if (hasListenersRaw is! bool) {
        throw FormatException('LabelCapture.hasListeners: expected a bool');
      }
      hasListenersValue = hasListenersRaw;
    } else if (hasHasListeners && hasListenersRaw == null) {
      throw FormatException('LabelCapture.hasListeners: null is not allowed');
    }
    return LabelCapture(
      type: typeValue!,
      settings: settingsValue,
      enabled: enabledValue,
      feedback: feedbackValue,
      modeId: modeIdValue,
      parentId: parentIdValue,
      hasListeners: hasListenersValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (enabled != null) {
      map['enabled'] = enabled;
    }
    if (feedback != null) {
      map['feedback'] = feedback!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (parentId != null) {
      map['parentId'] = parentId;
    }
    if (hasListeners != null) {
      map['hasListeners'] = hasListeners;
    }
    return map;
  }
}

/// Typed builder for the `LabelCapture` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCapture({
  required String type,
  Object? settings,
  bool? enabled,
  Object? feedback,
  int? modeId,
  Object? parentId = _unset,
  bool? hasListeners,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (settings != null) {
    map['settings'] = settings;
  }
  if (enabled != null) {
    map['enabled'] = enabled;
  }
  if (feedback != null) {
    map['feedback'] = feedback;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (!identical(parentId, _unset)) {
    map['parentId'] = parentId;
  }
  if (hasListeners != null) {
    map['hasListeners'] = hasListeners;
  }
  return map;
}

/// Settings that configure label capture behavior.
class LabelCaptureSettings {
  final LocationSelection? locationSelection;
  final List<LabelDefinition>? labelDefinitions;
  final List<String>? languages;
  final Object? properties;

  const LabelCaptureSettings({
    this.locationSelection,
    this.labelDefinitions,
    this.languages,
    this.properties,
  });

  factory LabelCaptureSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'licenseKey',
      'licensee',
      'locationSelection',
      'labelDefinitions',
      'languages',
      'properties',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureSettings: unknown property '$key'");
      }
    }
    final hasLocationSelection = raw.containsKey('locationSelection');
    final locationSelectionRaw = raw['locationSelection'];
    LocationSelection? locationSelectionValue;
    if (hasLocationSelection && locationSelectionRaw != null) {
      locationSelectionValue = LocationSelection.fromJson(locationSelectionRaw);
    }
    final hasLabelDefinitions = raw.containsKey('labelDefinitions');
    final labelDefinitionsRaw = raw['labelDefinitions'];
    List<LabelDefinition>? labelDefinitionsValue;
    if (hasLabelDefinitions && labelDefinitionsRaw != null) {
      if (labelDefinitionsRaw is! List) {
        throw FormatException('LabelCaptureSettings.labelDefinitions: expected a List');
      }
      labelDefinitionsValue = labelDefinitionsRaw.map((item) => LabelDefinition.fromJson(item)).toList();
    } else if (hasLabelDefinitions && labelDefinitionsRaw == null) {
      throw FormatException('LabelCaptureSettings.labelDefinitions: null is not allowed');
    }
    final hasLanguages = raw.containsKey('languages');
    final languagesRaw = raw['languages'];
    List<String>? languagesValue;
    if (hasLanguages && languagesRaw != null) {
      if (languagesRaw is! List) {
        throw FormatException('LabelCaptureSettings.languages: expected a List');
      }
      for (final item in languagesRaw) {
        if (item is! String || !const <String>['en', 'es'].contains(item)) {
          throw FormatException("LabelCaptureSettings.languages: unknown enum value '$item'");
        }
      }
      languagesValue = languagesRaw.cast<String>();
    } else if (hasLanguages && languagesRaw == null) {
      throw FormatException('LabelCaptureSettings.languages: null is not allowed');
    }
    final hasProperties = raw.containsKey('properties');
    final propertiesRaw = raw['properties'];
    Object? propertiesValue;
    if (hasProperties && propertiesRaw != null) {
      propertiesValue = propertiesRaw;
    } else if (hasProperties && propertiesRaw == null) {
      throw FormatException('LabelCaptureSettings.properties: null is not allowed');
    }
    return LabelCaptureSettings(
      locationSelection: locationSelectionValue,
      labelDefinitions: labelDefinitionsValue,
      languages: languagesValue,
      properties: propertiesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (locationSelection != null) {
      map['locationSelection'] = locationSelection!.toJson();
    }
    if (labelDefinitions != null) {
      map['labelDefinitions'] = labelDefinitions!.map((item) => item.toJson()).toList();
    }
    if (languages != null) {
      map['languages'] = languages;
    }
    if (properties != null) {
      map['properties'] = properties;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureSettings({
  Object? locationSelection = _unset,
  List<Object?>? labelDefinitions,
  List<String>? languages,
  Object? properties,
}) {
  final map = <String, Object?>{};
  if (!identical(locationSelection, _unset)) {
    map['locationSelection'] = locationSelection;
  }
  if (labelDefinitions != null) {
    map['labelDefinitions'] = labelDefinitions;
  }
  if (languages != null) {
    map['languages'] = languages;
  }
  if (properties != null) {
    map['properties'] = properties;
  }
  return map;
}

/// A location selection — discriminated union of no, radius, or rectangular selection.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class LocationSelection {
  Map<String, Object?> toJson();

  factory LocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LocationSelection: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'none':
        return NoLocationSelection.fromJson(raw);
      case 'radius':
        return RadiusLocationSelection.fromJson(raw);
      case 'rectangular':
        return RectangularLocationSelection.fromJson(raw);
      default:
        throw FormatException(
          "LocationSelection: unknown type '$discriminant'",
        );
    }
  }
}

/// No location selection — the full scan area is used.
class NoLocationSelection implements LocationSelection {
  final String type;

  const NoLocationSelection({
    required this.type,
  });

  factory NoLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('NoLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("NoLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("NoLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['none'].contains(typeRaw)) {
        throw FormatException("NoLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('NoLocationSelection.type: null is not allowed');
    }
    return NoLocationSelection(
      type: typeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    return map;
  }
}

/// Typed builder for the `NoLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildNoLocationSelection({
  required String type,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  return map;
}

/// A circular location selection.
class RadiusLocationSelection implements LocationSelection {
  final String type;
  final UIValue radius;

  const RadiusLocationSelection({
    required this.type,
    required this.radius,
  });

  factory RadiusLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RadiusLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'radius',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RadiusLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RadiusLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['radius'].contains(typeRaw)) {
        throw FormatException("RadiusLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RadiusLocationSelection.type: null is not allowed');
    }
    final hasRadius = raw.containsKey('radius');
    if (!hasRadius) {
      throw FormatException("RadiusLocationSelection.radius: missing required property");
    }
    final radiusRaw = raw['radius'];
    UIValue? radiusValue;
    if (hasRadius && radiusRaw != null) {
      radiusValue = UIValue.fromJson(radiusRaw);
    } else if (hasRadius && radiusRaw == null) {
      throw FormatException('RadiusLocationSelection.radius: null is not allowed');
    }
    return RadiusLocationSelection(
      type: typeValue!,
      radius: radiusValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    map['radius'] = radius.toJson();
    return map;
  }
}

/// Typed builder for the `RadiusLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRadiusLocationSelection({
  required String type,
  required Object radius,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  map['radius'] = radius;
  return map;
}

/// A value with a unit for UI measurements.
class UIValue {
  final double? value;
  final String? unit;

  const UIValue({
    this.value,
    this.unit,
  });

  factory UIValue.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIValue: expected a Map');
    }
    const allowedKeys = <String>{
      'value',
      'unit',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIValue: unknown property '$key'");
      }
    }
    final hasValue = raw.containsKey('value');
    final valueRaw = raw['value'];
    double? valueValue;
    if (hasValue && valueRaw != null) {
      if (valueRaw is! num) {
        throw FormatException('UIValue.value: expected a number');
      }
      valueValue = valueRaw.toDouble();
    } else if (hasValue && valueRaw == null) {
      throw FormatException('UIValue.value: null is not allowed');
    }
    final hasUnit = raw.containsKey('unit');
    final unitRaw = raw['unit'];
    String? unitValue;
    if (hasUnit && unitRaw != null) {
      if (unitRaw is! String || !const <String>['fraction', 'pixel', 'dip'].contains(unitRaw)) {
        throw FormatException("UIValue.unit: unknown enum value '$unitRaw'");
      }
      unitValue = unitRaw;
    } else if (hasUnit && unitRaw == null) {
      throw FormatException('UIValue.unit: null is not allowed');
    }
    return UIValue(
      value: valueValue,
      unit: unitValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (value != null) {
      map['value'] = value;
    }
    if (unit != null) {
      map['unit'] = unit;
    }
    return map;
  }
}

/// Typed builder for the `UIValue` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIValue({
  double? value,
  String? unit,
}) {
  final map = <String, Object?>{};
  if (value != null) {
    map['value'] = value;
  }
  if (unit != null) {
    map['unit'] = unit;
  }
  return map;
}

/// A rectangular location selection.
class RectangularLocationSelection implements LocationSelection {
  final String type;
  final UIAspectSize size;

  const RectangularLocationSelection({
    required this.type,
    required this.size,
  });

  factory RectangularLocationSelection.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularLocationSelection: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'size',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularLocationSelection: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RectangularLocationSelection.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['rectangular'].contains(typeRaw)) {
        throw FormatException("RectangularLocationSelection.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RectangularLocationSelection.type: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    if (!hasSize) {
      throw FormatException("RectangularLocationSelection.size: missing required property");
    }
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('RectangularLocationSelection.size: null is not allowed');
    }
    return RectangularLocationSelection(
      type: typeValue!,
      size: sizeValue!,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    map['size'] = size.toJson();
    return map;
  }
}

/// Typed builder for the `RectangularLocationSelection` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularLocationSelection({
  required String type,
  required Object size,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  map['size'] = size;
  return map;
}

/// A size specification that can be defined by width/height or shorter dimension/aspect ratio.
class UIAspectSize {
  final UIValue? width;
  final UIValue? height;
  final UIValue? shorterDimension;
  final double? aspect;

  const UIAspectSize({
    this.width,
    this.height,
    this.shorterDimension,
    this.aspect,
  });

  factory UIAspectSize.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIAspectSize: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
      'shorterDimension',
      'aspect',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIAspectSize: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    UIValue? widthValue;
    if (hasWidth && widthRaw != null) {
      widthValue = UIValue.fromJson(widthRaw);
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('UIAspectSize.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    final heightRaw = raw['height'];
    UIValue? heightValue;
    if (hasHeight && heightRaw != null) {
      heightValue = UIValue.fromJson(heightRaw);
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('UIAspectSize.height: null is not allowed');
    }
    final hasShorterDimension = raw.containsKey('shorterDimension');
    final shorterDimensionRaw = raw['shorterDimension'];
    UIValue? shorterDimensionValue;
    if (hasShorterDimension && shorterDimensionRaw != null) {
      shorterDimensionValue = UIValue.fromJson(shorterDimensionRaw);
    } else if (hasShorterDimension && shorterDimensionRaw == null) {
      throw FormatException('UIAspectSize.shorterDimension: null is not allowed');
    }
    final hasAspect = raw.containsKey('aspect');
    final aspectRaw = raw['aspect'];
    double? aspectValue;
    if (hasAspect && aspectRaw != null) {
      if (aspectRaw is! num) {
        throw FormatException('UIAspectSize.aspect: expected a number');
      }
      aspectValue = aspectRaw.toDouble();
    } else if (hasAspect && aspectRaw == null) {
      throw FormatException('UIAspectSize.aspect: null is not allowed');
    }
    return UIAspectSize(
      width: widthValue,
      height: heightValue,
      shorterDimension: shorterDimensionValue,
      aspect: aspectValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (width != null) {
      map['width'] = width!.toJson();
    }
    if (height != null) {
      map['height'] = height!.toJson();
    }
    if (shorterDimension != null) {
      map['shorterDimension'] = shorterDimension!.toJson();
    }
    if (aspect != null) {
      map['aspect'] = aspect;
    }
    return map;
  }
}

/// Typed builder for the `UIAspectSize` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIAspectSize({
  Object? width,
  Object? height,
  Object? shorterDimension,
  double? aspect,
}) {
  final map = <String, Object?>{};
  if (width != null) {
    map['width'] = width;
  }
  if (height != null) {
    map['height'] = height;
  }
  if (shorterDimension != null) {
    map['shorterDimension'] = shorterDimension;
  }
  if (aspect != null) {
    map['aspect'] = aspect;
  }
  return map;
}

/// Defines the structure of a label to be captured, including its name and constituent field definitions.
class LabelDefinition {
  final String name;
  final String? type;
  final List<LabelFieldDefinition>? fields;
  final String? adaptiveRecognitionMode;

  const LabelDefinition({
    required this.name,
    this.type,
    this.fields,
    this.adaptiveRecognitionMode,
  });

  factory LabelDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'type',
      'fields',
      'adaptiveRecognitionMode',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("LabelDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('LabelDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('LabelDefinition.name: null is not allowed');
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['vin', 'priceCapture', 'sevenSegment'].contains(typeRaw)) {
        throw FormatException("LabelDefinition.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelDefinition.type: null is not allowed');
    }
    final hasFields = raw.containsKey('fields');
    final fieldsRaw = raw['fields'];
    List<LabelFieldDefinition>? fieldsValue;
    if (hasFields && fieldsRaw != null) {
      if (fieldsRaw is! List) {
        throw FormatException('LabelDefinition.fields: expected a List');
      }
      fieldsValue = fieldsRaw.map((item) => LabelFieldDefinition.fromJson(item)).toList();
    } else if (hasFields && fieldsRaw == null) {
      throw FormatException('LabelDefinition.fields: null is not allowed');
    }
    final hasAdaptiveRecognitionMode = raw.containsKey('adaptiveRecognitionMode');
    final adaptiveRecognitionModeRaw = raw['adaptiveRecognitionMode'];
    String? adaptiveRecognitionModeValue;
    if (hasAdaptiveRecognitionMode && adaptiveRecognitionModeRaw != null) {
      if (adaptiveRecognitionModeRaw is! String ||
          !const <String>['off', 'auto', 'on'].contains(adaptiveRecognitionModeRaw)) {
        throw FormatException(
            "LabelDefinition.adaptiveRecognitionMode: unknown enum value '$adaptiveRecognitionModeRaw'");
      }
      adaptiveRecognitionModeValue = adaptiveRecognitionModeRaw;
    } else if (hasAdaptiveRecognitionMode && adaptiveRecognitionModeRaw == null) {
      throw FormatException('LabelDefinition.adaptiveRecognitionMode: null is not allowed');
    }
    return LabelDefinition(
      name: nameValue!,
      type: typeValue,
      fields: fieldsValue,
      adaptiveRecognitionMode: adaptiveRecognitionModeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (type != null) {
      map['type'] = type;
    }
    if (fields != null) {
      map['fields'] = fields!.map((item) => item.toJson()).toList();
    }
    if (adaptiveRecognitionMode != null) {
      map['adaptiveRecognitionMode'] = adaptiveRecognitionMode;
    }
    return map;
  }
}

/// Typed builder for the `LabelDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelDefinition({
  required String name,
  String? type,
  List<Object?>? fields,
  String? adaptiveRecognitionMode,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (type != null) {
    map['type'] = type;
  }
  if (fields != null) {
    map['fields'] = fields;
  }
  if (adaptiveRecognitionMode != null) {
    map['adaptiveRecognitionMode'] = adaptiveRecognitionMode;
  }
  return map;
}

/// Discriminated union of all label field definition types. The fieldType field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class LabelFieldDefinition {
  Map<String, Object?> toJson();

  factory LabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelFieldDefinition: expected a Map');
    }
    final discriminant = raw['fieldType'];
    switch (discriminant) {
      case 'imeiOneBarcode':
        return ImeiOneBarcodeFieldDefinition.fromJson(raw);
      case 'imeiTwoBarcode':
        return ImeiTwoBarcodeFieldDefinition.fromJson(raw);
      case 'partNumberBarcode':
        return PartNumberBarcodeFieldDefinition.fromJson(raw);
      case 'serialNumberBarcode':
        return SerialNumberBarcodeFieldDefinition.fromJson(raw);
      case 'expiryDateText':
        return ExpiryDateTextFieldDefinition.fromJson(raw);
      case 'packingDateText':
        return PackingDateTextFieldDefinition.fromJson(raw);
      case 'totalPriceText':
        return TotalPriceTextFieldDefinition.fromJson(raw);
      case 'unitPriceText':
        return UnitPriceTextFieldDefinition.fromJson(raw);
      case 'weightText':
        return WeightTextFieldDefinition.fromJson(raw);
      case 'customBarcode':
        return CustomBarcodeLabelFieldDefinition.fromJson(raw);
      case 'customText':
        return CustomTextLabelFieldDefinition.fromJson(raw);
      case 'dateText':
        return DateTextFieldDefinition.fromJson(raw);
      default:
        throw FormatException(
          "LabelFieldDefinition: unknown fieldType '$discriminant'",
        );
    }
  }
}

/// Label field definition for the first IMEI barcode field.
class ImeiOneBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const ImeiOneBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory ImeiOneBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImeiOneBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImeiOneBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ImeiOneBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ImeiOneBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['imeiOneBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("ImeiOneBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiOneBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ImeiOneBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiOneBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('ImeiOneBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return ImeiOneBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `ImeiOneBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImeiOneBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Symbology configuration — either an array of symbology identifiers to enable, or an object mapping each symbology to its detailed configuration.
typedef SymbologySettings = Object;

SymbologySettings parseSymbologySettings(Object? raw) {
  if (raw == null) {
    throw FormatException('SymbologySettings: expected a non-null value');
  }
  return raw;
}

/// Label field definition for the second IMEI barcode field.
class ImeiTwoBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const ImeiTwoBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory ImeiTwoBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ImeiTwoBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ImeiTwoBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ImeiTwoBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['imeiTwoBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("ImeiTwoBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiTwoBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ImeiTwoBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ImeiTwoBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('ImeiTwoBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return ImeiTwoBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `ImeiTwoBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildImeiTwoBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for a part number barcode field.
class PartNumberBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const PartNumberBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory PartNumberBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PartNumberBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PartNumberBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("PartNumberBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('PartNumberBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('PartNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('PartNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("PartNumberBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['partNumberBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("PartNumberBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('PartNumberBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('PartNumberBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('PartNumberBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('PartNumberBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('PartNumberBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('PartNumberBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return PartNumberBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `PartNumberBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPartNumberBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for a serial number barcode field.
class SerialNumberBarcodeFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final SymbologySettings? symbologies;

  const SerialNumberBarcodeFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.symbologies,
  });

  factory SerialNumberBarcodeFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SerialNumberBarcodeFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SerialNumberBarcodeFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("SerialNumberBarcodeFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("SerialNumberBarcodeFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['serialNumberBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("SerialNumberBarcodeFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('SerialNumberBarcodeFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('SerialNumberBarcodeFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('SerialNumberBarcodeFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('SerialNumberBarcodeFieldDefinition.symbologies: null is not allowed');
    }
    return SerialNumberBarcodeFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `SerialNumberBarcodeFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSerialNumberBarcodeFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Label field definition for an expiry date text field.
class ExpiryDateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const ExpiryDateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory ExpiryDateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ExpiryDateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ExpiryDateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("ExpiryDateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ExpiryDateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('ExpiryDateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('ExpiryDateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("ExpiryDateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['expiryDateText'].contains(fieldTypeRaw)) {
        throw FormatException("ExpiryDateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('ExpiryDateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('ExpiryDateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('ExpiryDateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('ExpiryDateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('ExpiryDateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('ExpiryDateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return ExpiryDateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `ExpiryDateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildExpiryDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Date-format hint controlling how a date label field is parsed.
class LabelDateFormat {
  final String componentFormat;
  final bool? acceptPartialDates;

  const LabelDateFormat({
    required this.componentFormat,
    this.acceptPartialDates,
  });

  factory LabelDateFormat.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelDateFormat: expected a Map');
    }
    const allowedKeys = <String>{
      'componentFormat',
      'acceptPartialDates',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelDateFormat: unknown property '$key'");
      }
    }
    final hasComponentFormat = raw.containsKey('componentFormat');
    if (!hasComponentFormat) {
      throw FormatException("LabelDateFormat.componentFormat: missing required property");
    }
    final componentFormatRaw = raw['componentFormat'];
    String? componentFormatValue;
    if (hasComponentFormat && componentFormatRaw != null) {
      if (componentFormatRaw is! String || !const <String>['dmy', 'mdy', 'ymd'].contains(componentFormatRaw)) {
        throw FormatException("LabelDateFormat.componentFormat: unknown enum value '$componentFormatRaw'");
      }
      componentFormatValue = componentFormatRaw;
    } else if (hasComponentFormat && componentFormatRaw == null) {
      throw FormatException('LabelDateFormat.componentFormat: null is not allowed');
    }
    final hasAcceptPartialDates = raw.containsKey('acceptPartialDates');
    final acceptPartialDatesRaw = raw['acceptPartialDates'];
    bool? acceptPartialDatesValue;
    if (hasAcceptPartialDates && acceptPartialDatesRaw != null) {
      if (acceptPartialDatesRaw is! bool) {
        throw FormatException('LabelDateFormat.acceptPartialDates: expected a bool');
      }
      acceptPartialDatesValue = acceptPartialDatesRaw;
    } else if (hasAcceptPartialDates && acceptPartialDatesRaw == null) {
      throw FormatException('LabelDateFormat.acceptPartialDates: null is not allowed');
    }
    return LabelDateFormat(
      componentFormat: componentFormatValue!,
      acceptPartialDates: acceptPartialDatesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['componentFormat'] = componentFormat;
    if (acceptPartialDates != null) {
      map['acceptPartialDates'] = acceptPartialDates;
    }
    return map;
  }
}

/// Typed builder for the `LabelDateFormat` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelDateFormat({
  required String componentFormat,
  bool? acceptPartialDates,
}) {
  final map = <String, Object?>{};
  map['componentFormat'] = componentFormat;
  if (acceptPartialDates != null) {
    map['acceptPartialDates'] = acceptPartialDates;
  }
  return map;
}

/// Label field definition for a packing date text field.
class PackingDateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const PackingDateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory PackingDateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('PackingDateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("PackingDateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("PackingDateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('PackingDateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('PackingDateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('PackingDateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("PackingDateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['packingDateText'].contains(fieldTypeRaw)) {
        throw FormatException("PackingDateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('PackingDateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('PackingDateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('PackingDateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('PackingDateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('PackingDateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('PackingDateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return PackingDateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `PackingDateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildPackingDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a total price text field.
class TotalPriceTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const TotalPriceTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory TotalPriceTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TotalPriceTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TotalPriceTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("TotalPriceTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('TotalPriceTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('TotalPriceTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('TotalPriceTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("TotalPriceTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['totalPriceText'].contains(fieldTypeRaw)) {
        throw FormatException("TotalPriceTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('TotalPriceTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('TotalPriceTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('TotalPriceTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('TotalPriceTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('TotalPriceTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('TotalPriceTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return TotalPriceTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `TotalPriceTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTotalPriceTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a unit price text field.
class UnitPriceTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const UnitPriceTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory UnitPriceTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UnitPriceTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UnitPriceTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("UnitPriceTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('UnitPriceTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('UnitPriceTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('UnitPriceTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("UnitPriceTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['unitPriceText'].contains(fieldTypeRaw)) {
        throw FormatException("UnitPriceTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('UnitPriceTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('UnitPriceTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('UnitPriceTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('UnitPriceTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('UnitPriceTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('UnitPriceTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return UnitPriceTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `UnitPriceTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUnitPriceTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a weight text field.
class WeightTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const WeightTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory WeightTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('WeightTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("WeightTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("WeightTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('WeightTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('WeightTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('WeightTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('WeightTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("WeightTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['weightText'].contains(fieldTypeRaw)) {
        throw FormatException("WeightTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('WeightTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('WeightTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('WeightTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('WeightTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('WeightTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('WeightTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('WeightTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return WeightTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `WeightTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildWeightTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Label field definition for a custom barcode field.
class CustomBarcodeLabelFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final LabelFieldLocation? location;
  final SymbologySettings? symbologies;

  const CustomBarcodeLabelFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.location,
    this.symbologies,
  });

  factory CustomBarcodeLabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CustomBarcodeLabelFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'location',
      'symbologies',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CustomBarcodeLabelFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("CustomBarcodeLabelFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("CustomBarcodeLabelFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['customBarcode'].contains(fieldTypeRaw)) {
        throw FormatException("CustomBarcodeLabelFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('CustomBarcodeLabelFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('CustomBarcodeLabelFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('CustomBarcodeLabelFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasLocation = raw.containsKey('location');
    final locationRaw = raw['location'];
    LabelFieldLocation? locationValue;
    if (hasLocation && locationRaw != null) {
      locationValue = LabelFieldLocation.fromJson(locationRaw);
    } else if (hasLocation && locationRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.location: null is not allowed');
    }
    final hasSymbologies = raw.containsKey('symbologies');
    final symbologiesRaw = raw['symbologies'];
    SymbologySettings? symbologiesValue;
    if (hasSymbologies && symbologiesRaw != null) {
      symbologiesValue = parseSymbologySettings(symbologiesRaw);
    } else if (hasSymbologies && symbologiesRaw == null) {
      throw FormatException('CustomBarcodeLabelFieldDefinition.symbologies: null is not allowed');
    }
    return CustomBarcodeLabelFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      location: locationValue,
      symbologies: symbologiesValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (location != null) {
      map['location'] = location!.toJson();
    }
    if (symbologies != null) {
      map['symbologies'] = symbologies;
    }
    return map;
  }
}

/// Typed builder for the `CustomBarcodeLabelFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCustomBarcodeLabelFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  Object? location,
  SymbologySettings? symbologies,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (location != null) {
    map['location'] = location;
  }
  if (symbologies != null) {
    map['symbologies'] = symbologies;
  }
  return map;
}

/// Location of a label field, specified either by type (LabelFieldLocationType) or an explicit bounding rectangle.
class LabelFieldLocation {
  final String? type;
  final Rect? rect;

  const LabelFieldLocation({
    this.type,
    this.rect,
  });

  factory LabelFieldLocation.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelFieldLocation: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'rect',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelFieldLocation: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String ||
          !const <String>[
            'topLeft',
            'topRight',
            'bottomRight',
            'bottomLeft',
            'top',
            'right',
            'bottom',
            'left',
            'center',
            'wholeLabel'
          ].contains(typeRaw)) {
        throw FormatException("LabelFieldLocation.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelFieldLocation.type: null is not allowed');
    }
    final hasRect = raw.containsKey('rect');
    final rectRaw = raw['rect'];
    Rect? rectValue;
    if (hasRect && rectRaw != null) {
      rectValue = Rect.fromJson(rectRaw);
    } else if (hasRect && rectRaw == null) {
      throw FormatException('LabelFieldLocation.rect: null is not allowed');
    }
    return LabelFieldLocation(
      type: typeValue,
      rect: rectValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (type != null) {
      map['type'] = type;
    }
    if (rect != null) {
      map['rect'] = rect!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LabelFieldLocation` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelFieldLocation({
  String? type,
  Object? rect,
}) {
  final map = <String, Object?>{};
  if (type != null) {
    map['type'] = type;
  }
  if (rect != null) {
    map['rect'] = rect;
  }
  return map;
}

/// A rectangle defined by an origin point and a size.
class Rect {
  final RectOrigin origin;
  final RectSize size;

  const Rect({
    required this.origin,
    required this.size,
  });

  factory Rect.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Rect: expected a Map');
    }
    const allowedKeys = <String>{
      'origin',
      'size',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Rect: unknown property '$key'");
      }
    }
    final hasOrigin = raw.containsKey('origin');
    if (!hasOrigin) {
      throw FormatException("Rect.origin: missing required property");
    }
    final originRaw = raw['origin'];
    RectOrigin? originValue;
    if (hasOrigin && originRaw != null) {
      originValue = RectOrigin.fromJson(originRaw);
    } else if (hasOrigin && originRaw == null) {
      throw FormatException('Rect.origin: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    if (!hasSize) {
      throw FormatException("Rect.size: missing required property");
    }
    final sizeRaw = raw['size'];
    RectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = RectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('Rect.size: null is not allowed');
    }
    return Rect(
      origin: originValue!,
      size: sizeValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['origin'] = origin.toJson();
    map['size'] = size.toJson();
    return map;
  }
}

/// Typed builder for the `Rect` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRect({
  required Object origin,
  required Object size,
}) {
  final map = <String, Object?>{};
  map['origin'] = origin;
  map['size'] = size;
  return map;
}

/// The origin of the rectangle.
class RectOrigin {
  final double x;
  final double y;

  const RectOrigin({
    required this.x,
    required this.y,
  });

  factory RectOrigin.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectOrigin: expected a Map');
    }
    const allowedKeys = <String>{
      'x',
      'y',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectOrigin: unknown property '$key'");
      }
    }
    final hasX = raw.containsKey('x');
    if (!hasX) {
      throw FormatException("RectOrigin.x: missing required property");
    }
    final xRaw = raw['x'];
    double? xValue;
    if (hasX && xRaw != null) {
      if (xRaw is! num) {
        throw FormatException('RectOrigin.x: expected a number');
      }
      xValue = xRaw.toDouble();
    } else if (hasX && xRaw == null) {
      throw FormatException('RectOrigin.x: null is not allowed');
    }
    final hasY = raw.containsKey('y');
    if (!hasY) {
      throw FormatException("RectOrigin.y: missing required property");
    }
    final yRaw = raw['y'];
    double? yValue;
    if (hasY && yRaw != null) {
      if (yRaw is! num) {
        throw FormatException('RectOrigin.y: expected a number');
      }
      yValue = yRaw.toDouble();
    } else if (hasY && yRaw == null) {
      throw FormatException('RectOrigin.y: null is not allowed');
    }
    return RectOrigin(
      x: xValue!,
      y: yValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['x'] = x;
    map['y'] = y;
    return map;
  }
}

/// Typed builder for the `RectOrigin` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectOrigin({
  required double x,
  required double y,
}) {
  final map = <String, Object?>{};
  map['x'] = x;
  map['y'] = y;
  return map;
}

/// The size of the rectangle.
class RectSize {
  final double width;
  final double height;

  const RectSize({
    required this.width,
    required this.height,
  });

  factory RectSize.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectSize: expected a Map');
    }
    const allowedKeys = <String>{
      'width',
      'height',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectSize: unknown property '$key'");
      }
    }
    final hasWidth = raw.containsKey('width');
    if (!hasWidth) {
      throw FormatException("RectSize.width: missing required property");
    }
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('RectSize.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('RectSize.width: null is not allowed');
    }
    final hasHeight = raw.containsKey('height');
    if (!hasHeight) {
      throw FormatException("RectSize.height: missing required property");
    }
    final heightRaw = raw['height'];
    double? heightValue;
    if (hasHeight && heightRaw != null) {
      if (heightRaw is! num) {
        throw FormatException('RectSize.height: expected a number');
      }
      heightValue = heightRaw.toDouble();
    } else if (hasHeight && heightRaw == null) {
      throw FormatException('RectSize.height: null is not allowed');
    }
    return RectSize(
      width: widthValue!,
      height: heightValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['width'] = width;
    map['height'] = height;
    return map;
  }
}

/// Typed builder for the `RectSize` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectSize({
  required double width,
  required double height,
}) {
  final map = <String, Object?>{};
  map['width'] = width;
  map['height'] = height;
  return map;
}

/// Label field definition for a custom text field.
class CustomTextLabelFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;
  final LabelFieldLocation? location;

  const CustomTextLabelFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
    this.location,
  });

  factory CustomTextLabelFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('CustomTextLabelFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
      'location',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("CustomTextLabelFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("CustomTextLabelFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('CustomTextLabelFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('CustomTextLabelFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('CustomTextLabelFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("CustomTextLabelFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['customText'].contains(fieldTypeRaw)) {
        throw FormatException("CustomTextLabelFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('CustomTextLabelFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('CustomTextLabelFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('CustomTextLabelFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('CustomTextLabelFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('CustomTextLabelFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    final hasLocation = raw.containsKey('location');
    final locationRaw = raw['location'];
    LabelFieldLocation? locationValue;
    if (hasLocation && locationRaw != null) {
      locationValue = LabelFieldLocation.fromJson(locationRaw);
    } else if (hasLocation && locationRaw == null) {
      throw FormatException('CustomTextLabelFieldDefinition.location: null is not allowed');
    }
    return CustomTextLabelFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
      location: locationValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    if (location != null) {
      map['location'] = location!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `CustomTextLabelFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildCustomTextLabelFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
  Object? location,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  if (location != null) {
    map['location'] = location;
  }
  return map;
}

/// Label field definition for a generic date text field.
class DateTextFieldDefinition implements LabelFieldDefinition {
  final String name;
  final int? number_of_mandatory_instances;
  final LabelDateFormat? labelDateFormat;
  final String fieldType;
  final bool? optional;
  final List<String>? dataTypePatterns;
  final List<String>? patterns;

  const DateTextFieldDefinition({
    required this.name,
    this.number_of_mandatory_instances,
    this.labelDateFormat,
    required this.fieldType,
    this.optional,
    this.dataTypePatterns,
    this.patterns,
  });

  factory DateTextFieldDefinition.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('DateTextFieldDefinition: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'number_of_mandatory_instances',
      'labelDateFormat',
      'fieldType',
      'optional',
      'dataTypePatterns',
      'patterns',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("DateTextFieldDefinition: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    if (!hasName) {
      throw FormatException("DateTextFieldDefinition.name: missing required property");
    }
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('DateTextFieldDefinition.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('DateTextFieldDefinition.name: null is not allowed');
    }
    final hasNumber_of_mandatory_instances = raw.containsKey('number_of_mandatory_instances');
    final number_of_mandatory_instancesRaw = raw['number_of_mandatory_instances'];
    int? number_of_mandatory_instancesValue;
    if (hasNumber_of_mandatory_instances && number_of_mandatory_instancesRaw != null) {
      if (number_of_mandatory_instancesRaw is! num) {
        throw FormatException('DateTextFieldDefinition.number_of_mandatory_instances: expected a number');
      }
      if (number_of_mandatory_instancesRaw != number_of_mandatory_instancesRaw.toInt()) {
        throw FormatException('DateTextFieldDefinition.number_of_mandatory_instances: expected an integer');
      }
      number_of_mandatory_instancesValue = number_of_mandatory_instancesRaw.toInt();
    }
    final hasLabelDateFormat = raw.containsKey('labelDateFormat');
    final labelDateFormatRaw = raw['labelDateFormat'];
    LabelDateFormat? labelDateFormatValue;
    if (hasLabelDateFormat && labelDateFormatRaw != null) {
      labelDateFormatValue = LabelDateFormat.fromJson(labelDateFormatRaw);
    } else if (hasLabelDateFormat && labelDateFormatRaw == null) {
      throw FormatException('DateTextFieldDefinition.labelDateFormat: null is not allowed');
    }
    final hasFieldType = raw.containsKey('fieldType');
    if (!hasFieldType) {
      throw FormatException("DateTextFieldDefinition.fieldType: missing required property");
    }
    final fieldTypeRaw = raw['fieldType'];
    String? fieldTypeValue;
    if (hasFieldType && fieldTypeRaw != null) {
      if (fieldTypeRaw is! String || !const <String>['dateText'].contains(fieldTypeRaw)) {
        throw FormatException("DateTextFieldDefinition.fieldType: unknown enum value '$fieldTypeRaw'");
      }
      fieldTypeValue = fieldTypeRaw;
    } else if (hasFieldType && fieldTypeRaw == null) {
      throw FormatException('DateTextFieldDefinition.fieldType: null is not allowed');
    }
    final hasOptional = raw.containsKey('optional');
    final optionalRaw = raw['optional'];
    bool? optionalValue;
    if (hasOptional && optionalRaw != null) {
      if (optionalRaw is! bool) {
        throw FormatException('DateTextFieldDefinition.optional: expected a bool');
      }
      optionalValue = optionalRaw;
    } else if (hasOptional && optionalRaw == null) {
      throw FormatException('DateTextFieldDefinition.optional: null is not allowed');
    }
    final hasDataTypePatterns = raw.containsKey('dataTypePatterns');
    final dataTypePatternsRaw = raw['dataTypePatterns'];
    List<String>? dataTypePatternsValue;
    if (hasDataTypePatterns && dataTypePatternsRaw != null) {
      if (dataTypePatternsRaw is! List) {
        throw FormatException('DateTextFieldDefinition.dataTypePatterns: expected a List');
      }
      for (final item in dataTypePatternsRaw) {
        if (item is! String) {
          throw FormatException('DateTextFieldDefinition.dataTypePatterns: expected a List of String');
        }
      }
      dataTypePatternsValue = dataTypePatternsRaw.cast<String>();
    }
    final hasPatterns = raw.containsKey('patterns');
    final patternsRaw = raw['patterns'];
    List<String>? patternsValue;
    if (hasPatterns && patternsRaw != null) {
      if (patternsRaw is! List) {
        throw FormatException('DateTextFieldDefinition.patterns: expected a List');
      }
      for (final item in patternsRaw) {
        if (item is! String) {
          throw FormatException('DateTextFieldDefinition.patterns: expected a List of String');
        }
      }
      patternsValue = patternsRaw.cast<String>();
    }
    return DateTextFieldDefinition(
      name: nameValue!,
      number_of_mandatory_instances: number_of_mandatory_instancesValue,
      labelDateFormat: labelDateFormatValue,
      fieldType: fieldTypeValue!,
      optional: optionalValue,
      dataTypePatterns: dataTypePatternsValue,
      patterns: patternsValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['name'] = name;
    if (number_of_mandatory_instances != null) {
      map['number_of_mandatory_instances'] = number_of_mandatory_instances;
    }
    if (labelDateFormat != null) {
      map['labelDateFormat'] = labelDateFormat!.toJson();
    }
    map['fieldType'] = fieldType;
    if (optional != null) {
      map['optional'] = optional;
    }
    if (dataTypePatterns != null) {
      map['dataTypePatterns'] = dataTypePatterns;
    }
    if (patterns != null) {
      map['patterns'] = patterns;
    }
    return map;
  }
}

/// Typed builder for the `DateTextFieldDefinition` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildDateTextFieldDefinition({
  required String name,
  Object? number_of_mandatory_instances = _unset,
  Object? labelDateFormat,
  required String fieldType,
  bool? optional,
  Object? dataTypePatterns = _unset,
  Object? patterns = _unset,
}) {
  final map = <String, Object?>{};
  map['name'] = name;
  if (!identical(number_of_mandatory_instances, _unset)) {
    map['number_of_mandatory_instances'] = number_of_mandatory_instances;
  }
  if (labelDateFormat != null) {
    map['labelDateFormat'] = labelDateFormat;
  }
  map['fieldType'] = fieldType;
  if (optional != null) {
    map['optional'] = optional;
  }
  if (!identical(dataTypePatterns, _unset)) {
    map['dataTypePatterns'] = dataTypePatterns;
  }
  if (!identical(patterns, _unset)) {
    map['patterns'] = patterns;
  }
  return map;
}

/// Feedback configuration for label capture events.
class LabelCaptureFeedback {
  final Feedback? success;

  const LabelCaptureFeedback({
    this.success,
  });

  factory LabelCaptureFeedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureFeedback: expected a Map');
    }
    const allowedKeys = <String>{
      'success',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureFeedback: unknown property '$key'");
      }
    }
    final hasSuccess = raw.containsKey('success');
    final successRaw = raw['success'];
    Feedback? successValue;
    if (hasSuccess && successRaw != null) {
      successValue = Feedback.fromJson(successRaw);
    } else if (hasSuccess && successRaw == null) {
      throw FormatException('LabelCaptureFeedback.success: null is not allowed');
    }
    return LabelCaptureFeedback(
      success: successValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (success != null) {
      map['success'] = success!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureFeedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureFeedback({
  Object? success,
}) {
  final map = <String, Object?>{};
  if (success != null) {
    map['success'] = success;
  }
  return map;
}

/// Audio and haptic feedback for scan events.
class Feedback {
  final Sound? sound;
  final Vibration? vibration;

  const Feedback({
    this.sound,
    this.vibration,
  });

  factory Feedback.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Feedback: expected a Map');
    }
    const allowedKeys = <String>{
      'sound',
      'vibration',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Feedback: unknown property '$key'");
      }
    }
    final hasSound = raw.containsKey('sound');
    final soundRaw = raw['sound'];
    Sound? soundValue;
    if (hasSound && soundRaw != null) {
      soundValue = Sound.fromJson(soundRaw);
    }
    final hasVibration = raw.containsKey('vibration');
    final vibrationRaw = raw['vibration'];
    Vibration? vibrationValue;
    if (hasVibration && vibrationRaw != null) {
      vibrationValue = Vibration.fromJson(vibrationRaw);
    }
    return Feedback(
      sound: soundValue,
      vibration: vibrationValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (sound != null) {
      map['sound'] = sound!.toJson();
    }
    if (vibration != null) {
      map['vibration'] = vibration!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `Feedback` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFeedback({
  Object? sound = _unset,
  Object? vibration = _unset,
}) {
  final map = <String, Object?>{};
  if (!identical(sound, _unset)) {
    map['sound'] = sound;
  }
  if (!identical(vibration, _unset)) {
    map['vibration'] = vibration;
  }
  return map;
}

///
class Sound {
  final String? resource;

  const Sound({
    this.resource,
  });

  factory Sound.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Sound: expected a Map');
    }
    const allowedKeys = <String>{
      'resource',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Sound: unknown property '$key'");
      }
    }
    final hasResource = raw.containsKey('resource');
    final resourceRaw = raw['resource'];
    String? resourceValue;
    if (hasResource && resourceRaw != null) {
      if (resourceRaw is! String) {
        throw FormatException('Sound.resource: expected a String');
      }
      resourceValue = resourceRaw;
    } else if (hasResource && resourceRaw == null) {
      throw FormatException('Sound.resource: null is not allowed');
    }
    return Sound(
      resource: resourceValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (resource != null) {
      map['resource'] = resource;
    }
    return map;
  }
}

/// Typed builder for the `Sound` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSound({
  String? resource,
}) {
  final map = <String, Object?>{};
  if (resource != null) {
    map['resource'] = resource;
  }
  return map;
}

///
class Vibration {
  final String? type;
  final List<int>? timings;
  final List<int>? amplitudes;

  const Vibration({
    this.type,
    this.timings,
    this.amplitudes,
  });

  factory Vibration.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Vibration: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'timings',
      'amplitudes',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Vibration: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String ||
          !const <String>[
            'default',
            'selectionHaptic',
            'successHaptic',
            'impactHaptic',
            'impactHapticLight',
            'failureHaptic',
            'waveForm'
          ].contains(typeRaw)) {
        throw FormatException("Vibration.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('Vibration.type: null is not allowed');
    }
    final hasTimings = raw.containsKey('timings');
    final timingsRaw = raw['timings'];
    List<int>? timingsValue;
    if (hasTimings && timingsRaw != null) {
      if (timingsRaw is! List) {
        throw FormatException('Vibration.timings: expected a List');
      }
      for (final item in timingsRaw) {
        if (item is! num) {
          throw FormatException('Vibration.timings: expected a List of num');
        }
        if (item != item.toInt()) {
          throw FormatException('Vibration.timings: expected a List of integers');
        }
      }
      timingsValue = timingsRaw.map((item) => (item as num).toInt()).toList();
    } else if (hasTimings && timingsRaw == null) {
      throw FormatException('Vibration.timings: null is not allowed');
    }
    final hasAmplitudes = raw.containsKey('amplitudes');
    final amplitudesRaw = raw['amplitudes'];
    List<int>? amplitudesValue;
    if (hasAmplitudes && amplitudesRaw != null) {
      if (amplitudesRaw is! List) {
        throw FormatException('Vibration.amplitudes: expected a List');
      }
      for (final item in amplitudesRaw) {
        if (item is! num) {
          throw FormatException('Vibration.amplitudes: expected a List of num');
        }
        if (item != item.toInt()) {
          throw FormatException('Vibration.amplitudes: expected a List of integers');
        }
      }
      amplitudesValue = amplitudesRaw.map((item) => (item as num).toInt()).toList();
    } else if (hasAmplitudes && amplitudesRaw == null) {
      throw FormatException('Vibration.amplitudes: null is not allowed');
    }
    return Vibration(
      type: typeValue,
      timings: timingsValue,
      amplitudes: amplitudesValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (type != null) {
      map['type'] = type;
    }
    if (timings != null) {
      map['timings'] = timings;
    }
    if (amplitudes != null) {
      map['amplitudes'] = amplitudes;
    }
    return map;
  }
}

/// Typed builder for the `Vibration` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildVibration({
  String? type,
  List<int>? timings,
  List<int>? amplitudes,
}) {
  final map = <String, Object?>{};
  if (type != null) {
    map['type'] = type;
  }
  if (timings != null) {
    map['timings'] = timings;
  }
  if (amplitudes != null) {
    map['amplitudes'] = amplitudes;
  }
  return map;
}

/// A named anchor position within a rectangular area.
enum Anchor {
  topLeft('topLeft'),
  topCenter('topCenter'),
  topRight('topRight'),
  centerLeft('centerLeft'),
  center('center'),
  centerRight('centerRight'),
  bottomLeft('bottomLeft'),
  bottomCenter('bottomCenter'),
  bottomRight('bottomRight');

  const Anchor(this.jsonValue);

  final String jsonValue;

  static Anchor fromJSON(String jsonValue) {
    for (final value in Anchor.values) {
      if (value.jsonValue == jsonValue) {
        return value;
      }
    }
    throw FormatException("Anchor: unknown enum value '$jsonValue'");
  }

  String toJson() => jsonValue;
}

/// A 2D point with UI value coordinates.
class UIPoint {
  final UIValue x;
  final UIValue y;

  const UIPoint({
    required this.x,
    required this.y,
  });

  factory UIPoint.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('UIPoint: expected a Map');
    }
    const allowedKeys = <String>{
      'x',
      'y',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("UIPoint: unknown property '$key'");
      }
    }
    final hasX = raw.containsKey('x');
    if (!hasX) {
      throw FormatException("UIPoint.x: missing required property");
    }
    final xRaw = raw['x'];
    UIValue? xValue;
    if (hasX && xRaw != null) {
      xValue = UIValue.fromJson(xRaw);
    } else if (hasX && xRaw == null) {
      throw FormatException('UIPoint.x: null is not allowed');
    }
    final hasY = raw.containsKey('y');
    if (!hasY) {
      throw FormatException("UIPoint.y: missing required property");
    }
    final yRaw = raw['y'];
    UIValue? yValue;
    if (hasY && yRaw != null) {
      yValue = UIValue.fromJson(yRaw);
    } else if (hasY && yRaw == null) {
      throw FormatException('UIPoint.y: null is not allowed');
    }
    return UIPoint(
      x: xValue!,
      y: yValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['x'] = x.toJson();
    map['y'] = y.toJson();
    return map;
  }
}

/// Typed builder for the `UIPoint` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildUIPoint({
  required Object x,
  required Object y,
}) {
  final map = <String, Object?>{};
  map['x'] = x;
  map['y'] = y;
  return map;
}

/// The basic overlay for label capture, rendering location highlights for label fields.
class LabelCaptureBasicOverlay {
  final String type;
  final FieldBrushes? fieldBrushes;
  final Brush? labelBrush;
  final Viewfinder? viewfinder;
  final bool? shouldShowScanAreaGuides;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureBasicOverlay({
    required this.type,
    this.fieldBrushes,
    this.labelBrush,
    this.viewfinder,
    this.shouldShowScanAreaGuides,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureBasicOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureBasicOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'fieldBrushes',
      'labelBrush',
      'viewfinder',
      'shouldShowScanAreaGuides',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureBasicOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureBasicOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCaptureBasic'].contains(typeRaw)) {
        throw FormatException("LabelCaptureBasicOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.type: null is not allowed');
    }
    final hasFieldBrushes = raw.containsKey('fieldBrushes');
    final fieldBrushesRaw = raw['fieldBrushes'];
    FieldBrushes? fieldBrushesValue;
    if (hasFieldBrushes && fieldBrushesRaw != null) {
      fieldBrushesValue = FieldBrushes.fromJson(fieldBrushesRaw);
    } else if (hasFieldBrushes && fieldBrushesRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.fieldBrushes: null is not allowed');
    }
    final hasLabelBrush = raw.containsKey('labelBrush');
    final labelBrushRaw = raw['labelBrush'];
    Brush? labelBrushValue;
    if (hasLabelBrush && labelBrushRaw != null) {
      labelBrushValue = Brush.fromJson(labelBrushRaw);
    } else if (hasLabelBrush && labelBrushRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.labelBrush: null is not allowed');
    }
    final hasViewfinder = raw.containsKey('viewfinder');
    final viewfinderRaw = raw['viewfinder'];
    Viewfinder? viewfinderValue;
    if (hasViewfinder && viewfinderRaw != null) {
      viewfinderValue = Viewfinder.fromJson(viewfinderRaw);
    } else if (hasViewfinder && viewfinderRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.viewfinder: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('LabelCaptureBasicOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureBasicOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureBasicOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureBasicOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureBasicOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureBasicOverlay(
      type: typeValue!,
      fieldBrushes: fieldBrushesValue,
      labelBrush: labelBrushValue,
      viewfinder: viewfinderValue,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (fieldBrushes != null) {
      map['fieldBrushes'] = fieldBrushes!.toJson();
    }
    if (labelBrush != null) {
      map['labelBrush'] = labelBrush!.toJson();
    }
    if (viewfinder != null) {
      map['viewfinder'] = viewfinder!.toJson();
    }
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureBasicOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureBasicOverlay({
  required String type,
  Object? fieldBrushes,
  Object? labelBrush,
  Object? viewfinder,
  bool? shouldShowScanAreaGuides,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (fieldBrushes != null) {
    map['fieldBrushes'] = fieldBrushes;
  }
  if (labelBrush != null) {
    map['labelBrush'] = labelBrush;
  }
  if (viewfinder != null) {
    map['viewfinder'] = viewfinder;
  }
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Default brushes for different field states.
class FieldBrushes {
  final Brush? captured;
  final Brush? predicted;

  const FieldBrushes({
    this.captured,
    this.predicted,
  });

  factory FieldBrushes.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('FieldBrushes: expected a Map');
    }
    const allowedKeys = <String>{
      'captured',
      'predicted',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("FieldBrushes: unknown property '$key'");
      }
    }
    final hasCaptured = raw.containsKey('captured');
    final capturedRaw = raw['captured'];
    Brush? capturedValue;
    if (hasCaptured && capturedRaw != null) {
      capturedValue = Brush.fromJson(capturedRaw);
    } else if (hasCaptured && capturedRaw == null) {
      throw FormatException('FieldBrushes.captured: null is not allowed');
    }
    final hasPredicted = raw.containsKey('predicted');
    final predictedRaw = raw['predicted'];
    Brush? predictedValue;
    if (hasPredicted && predictedRaw != null) {
      predictedValue = Brush.fromJson(predictedRaw);
    } else if (hasPredicted && predictedRaw == null) {
      throw FormatException('FieldBrushes.predicted: null is not allowed');
    }
    return FieldBrushes(
      captured: capturedValue,
      predicted: predictedValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (captured != null) {
      map['captured'] = captured!.toJson();
    }
    if (predicted != null) {
      map['predicted'] = predicted!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `FieldBrushes` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFieldBrushes({
  Object? captured,
  Object? predicted,
}) {
  final map = <String, Object?>{};
  if (captured != null) {
    map['captured'] = captured;
  }
  if (predicted != null) {
    map['predicted'] = predicted;
  }
  return map;
}

/// A brush defining fill and stroke appearance.
class Brush {
  final Fill? fill;
  final Stroke? stroke;

  const Brush({
    this.fill,
    this.stroke,
  });

  factory Brush.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Brush: expected a Map');
    }
    const allowedKeys = <String>{
      'fill',
      'stroke',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Brush: unknown property '$key'");
      }
    }
    final hasFill = raw.containsKey('fill');
    final fillRaw = raw['fill'];
    Fill? fillValue;
    if (hasFill && fillRaw != null) {
      fillValue = Fill.fromJson(fillRaw);
    } else if (hasFill && fillRaw == null) {
      throw FormatException('Brush.fill: null is not allowed');
    }
    final hasStroke = raw.containsKey('stroke');
    final strokeRaw = raw['stroke'];
    Stroke? strokeValue;
    if (hasStroke && strokeRaw != null) {
      strokeValue = Stroke.fromJson(strokeRaw);
    } else if (hasStroke && strokeRaw == null) {
      throw FormatException('Brush.stroke: null is not allowed');
    }
    return Brush(
      fill: fillValue,
      stroke: strokeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (fill != null) {
      map['fill'] = fill!.toJson();
    }
    if (stroke != null) {
      map['stroke'] = stroke!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `Brush` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildBrush({
  Object? fill,
  Object? stroke,
}) {
  final map = <String, Object?>{};
  if (fill != null) {
    map['fill'] = fill;
  }
  if (stroke != null) {
    map['stroke'] = stroke;
  }
  return map;
}

///
class Fill {
  final Color? color;

  const Fill({
    this.color,
  });

  factory Fill.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Fill: expected a Map');
    }
    const allowedKeys = <String>{
      'color',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Fill: unknown property '$key'");
      }
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('Fill.color: null is not allowed');
    }
    return Fill(
      color: colorValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (color != null) {
      map['color'] = color;
    }
    return map;
  }
}

/// Typed builder for the `Fill` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildFill({
  Color? color,
}) {
  final map = <String, Object?>{};
  if (color != null) {
    map['color'] = color;
  }
  return map;
}

/// A color expressed as a hex string with an optional # prefix. Accepted formats: RGB, RGBA, RRGGBB, RRGGBBAA (case-insensitive).
typedef Color = String;

Color parseColor(Object? raw) {
  if (raw is! String) {
    throw FormatException('Color: expected a String');
  }
  return raw;
}

///
class Stroke {
  final Color? color;
  final double? width;

  const Stroke({
    this.color,
    this.width,
  });

  factory Stroke.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Stroke: expected a Map');
    }
    const allowedKeys = <String>{
      'color',
      'width',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("Stroke: unknown property '$key'");
      }
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('Stroke.color: null is not allowed');
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    double? widthValue;
    if (hasWidth && widthRaw != null) {
      if (widthRaw is! num) {
        throw FormatException('Stroke.width: expected a number');
      }
      widthValue = widthRaw.toDouble();
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('Stroke.width: null is not allowed');
    }
    return Stroke(
      color: colorValue,
      width: widthValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (color != null) {
      map['color'] = color;
    }
    if (width != null) {
      map['width'] = width;
    }
    return map;
  }
}

/// Typed builder for the `Stroke` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildStroke({
  Color? color,
  double? width,
}) {
  final map = <String, Object?>{};
  if (color != null) {
    map['color'] = color;
  }
  if (width != null) {
    map['width'] = width;
  }
  return map;
}

/// Discriminated union of all viewfinder types. The type field selects the concrete schema.
// NOTE: `abstract class`, not `abstract interface class`. The generated Dart
// must parse under the OLDEST toolchain in CI -- validate-bridge-generator's
// `dart format` runs on an older Dart SDK that does not understand Dart 3.0+
// class modifiers (`interface`, `sealed`, `base`, `final class`,
// `mixin class`). The docs signature collector moved to `analyzer ^7.7.1` in
// SDC-33150 and parses those fine, so it is no longer part of this
// constraint; `dart format` still is. `abstract class` is implementable in
// Dart 2 and 3 alike, so it preserves the same "implement, don't extend"
// contract without the modifier.
abstract class Viewfinder {
  Map<String, Object?> toJson();

  factory Viewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('Viewfinder: expected a Map');
    }
    final discriminant = raw['type'];
    switch (discriminant) {
      case 'none':
        return NoneViewfinder.fromJson(raw);
      case 'rectangular':
        return RectangularViewfinder.fromJson(raw);
      case 'laserline':
        return LaserlineViewfinder.fromJson(raw);
      case 'spotlight':
        return SpotlightViewfinder.fromJson(raw);
      case 'aimer':
        return AimerViewfinder.fromJson(raw);
      case 'targetAimer':
        return TargetAimerViewfinder.fromJson(raw);
      default:
        throw FormatException(
          "Viewfinder: unknown type '$discriminant'",
        );
    }
  }
}

/// A viewfinder that renders nothing.
class NoneViewfinder implements Viewfinder {
  final String type;
  final UIPoint? pointOfInterest;

  const NoneViewfinder({
    required this.type,
    this.pointOfInterest,
  });

  factory NoneViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('NoneViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("NoneViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("NoneViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['none'].contains(typeRaw)) {
        throw FormatException("NoneViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('NoneViewfinder.type: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return NoneViewfinder(
      type: typeValue!,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `NoneViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildNoneViewfinder({
  required String type,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a rectangular frame around the scan area.
class RectangularViewfinder implements Viewfinder {
  final String type;
  final String? style;
  final UIAspectSize? size;
  final Color? color;
  final Color? disabledColor;
  final String? lineStyle;
  final double? dimming;
  final double? disabledDimming;
  final RectangularViewfinderAnimation? animation;
  final UIPoint? pointOfInterest;

  const RectangularViewfinder({
    required this.type,
    this.style,
    this.size,
    this.color,
    this.disabledColor,
    this.lineStyle,
    this.dimming,
    this.disabledDimming,
    this.animation,
    this.pointOfInterest,
  });

  factory RectangularViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'style',
      'size',
      'color',
      'disabledColor',
      'lineStyle',
      'dimming',
      'disabledDimming',
      'animation',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("RectangularViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['rectangular'].contains(typeRaw)) {
        throw FormatException("RectangularViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('RectangularViewfinder.type: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['rounded', 'square'].contains(styleRaw)) {
        throw FormatException("RectangularViewfinder.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('RectangularViewfinder.style: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('RectangularViewfinder.size: null is not allowed');
    }
    final hasColor = raw.containsKey('color');
    final colorRaw = raw['color'];
    Color? colorValue;
    if (hasColor && colorRaw != null) {
      colorValue = parseColor(colorRaw);
    } else if (hasColor && colorRaw == null) {
      throw FormatException('RectangularViewfinder.color: null is not allowed');
    }
    final hasDisabledColor = raw.containsKey('disabledColor');
    final disabledColorRaw = raw['disabledColor'];
    Color? disabledColorValue;
    if (hasDisabledColor && disabledColorRaw != null) {
      disabledColorValue = parseColor(disabledColorRaw);
    } else if (hasDisabledColor && disabledColorRaw == null) {
      throw FormatException('RectangularViewfinder.disabledColor: null is not allowed');
    }
    final hasLineStyle = raw.containsKey('lineStyle');
    final lineStyleRaw = raw['lineStyle'];
    String? lineStyleValue;
    if (hasLineStyle && lineStyleRaw != null) {
      if (lineStyleRaw is! String || !const <String>['light', 'bold'].contains(lineStyleRaw)) {
        throw FormatException("RectangularViewfinder.lineStyle: unknown enum value '$lineStyleRaw'");
      }
      lineStyleValue = lineStyleRaw;
    } else if (hasLineStyle && lineStyleRaw == null) {
      throw FormatException('RectangularViewfinder.lineStyle: null is not allowed');
    }
    final hasDimming = raw.containsKey('dimming');
    final dimmingRaw = raw['dimming'];
    double? dimmingValue;
    if (hasDimming && dimmingRaw != null) {
      if (dimmingRaw is! num) {
        throw FormatException('RectangularViewfinder.dimming: expected a number');
      }
      dimmingValue = dimmingRaw.toDouble();
    } else if (hasDimming && dimmingRaw == null) {
      throw FormatException('RectangularViewfinder.dimming: null is not allowed');
    }
    final hasDisabledDimming = raw.containsKey('disabledDimming');
    final disabledDimmingRaw = raw['disabledDimming'];
    double? disabledDimmingValue;
    if (hasDisabledDimming && disabledDimmingRaw != null) {
      if (disabledDimmingRaw is! num) {
        throw FormatException('RectangularViewfinder.disabledDimming: expected a number');
      }
      disabledDimmingValue = disabledDimmingRaw.toDouble();
    } else if (hasDisabledDimming && disabledDimmingRaw == null) {
      throw FormatException('RectangularViewfinder.disabledDimming: null is not allowed');
    }
    final hasAnimation = raw.containsKey('animation');
    final animationRaw = raw['animation'];
    RectangularViewfinderAnimation? animationValue;
    if (hasAnimation && animationRaw != null) {
      animationValue = RectangularViewfinderAnimation.fromJson(animationRaw);
    } else if (hasAnimation && animationRaw == null) {
      throw FormatException('RectangularViewfinder.animation: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return RectangularViewfinder(
      type: typeValue!,
      style: styleValue,
      size: sizeValue,
      color: colorValue,
      disabledColor: disabledColorValue,
      lineStyle: lineStyleValue,
      dimming: dimmingValue,
      disabledDimming: disabledDimmingValue,
      animation: animationValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (style != null) {
      map['style'] = style;
    }
    if (size != null) {
      map['size'] = size!.toJson();
    }
    if (color != null) {
      map['color'] = color;
    }
    if (disabledColor != null) {
      map['disabledColor'] = disabledColor;
    }
    if (lineStyle != null) {
      map['lineStyle'] = lineStyle;
    }
    if (dimming != null) {
      map['dimming'] = dimming;
    }
    if (disabledDimming != null) {
      map['disabledDimming'] = disabledDimming;
    }
    if (animation != null) {
      map['animation'] = animation!.toJson();
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `RectangularViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularViewfinder({
  required String type,
  String? style,
  Object? size,
  Color? color,
  Color? disabledColor,
  String? lineStyle,
  double? dimming,
  double? disabledDimming,
  Object? animation,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (style != null) {
    map['style'] = style;
  }
  if (size != null) {
    map['size'] = size;
  }
  if (color != null) {
    map['color'] = color;
  }
  if (disabledColor != null) {
    map['disabledColor'] = disabledColor;
  }
  if (lineStyle != null) {
    map['lineStyle'] = lineStyle;
  }
  if (dimming != null) {
    map['dimming'] = dimming;
  }
  if (disabledDimming != null) {
    map['disabledDimming'] = disabledDimming;
  }
  if (animation != null) {
    map['animation'] = animation;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

///
class RectangularViewfinderAnimation {
  final bool? looping;

  const RectangularViewfinderAnimation({
    this.looping,
  });

  factory RectangularViewfinderAnimation.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('RectangularViewfinderAnimation: expected a Map');
    }
    const allowedKeys = <String>{
      'looping',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("RectangularViewfinderAnimation: unknown property '$key'");
      }
    }
    final hasLooping = raw.containsKey('looping');
    final loopingRaw = raw['looping'];
    bool? loopingValue;
    if (hasLooping && loopingRaw != null) {
      if (loopingRaw is! bool) {
        throw FormatException('RectangularViewfinderAnimation.looping: expected a bool');
      }
      loopingValue = loopingRaw;
    } else if (hasLooping && loopingRaw == null) {
      throw FormatException('RectangularViewfinderAnimation.looping: null is not allowed');
    }
    return RectangularViewfinderAnimation(
      looping: loopingValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (looping != null) {
      map['looping'] = looping;
    }
    return map;
  }
}

/// Typed builder for the `RectangularViewfinderAnimation` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildRectangularViewfinderAnimation({
  bool? looping,
}) {
  final map = <String, Object?>{};
  if (looping != null) {
    map['looping'] = looping;
  }
  return map;
}

/// A viewfinder that draws a horizontal laser line across the scan area.
class LaserlineViewfinder implements Viewfinder {
  final String type;
  final String? style;
  final UIValue? width;
  final Color? enabledColor;
  final Color? disabledColor;
  final UIPoint? pointOfInterest;

  const LaserlineViewfinder({
    required this.type,
    this.style,
    this.width,
    this.enabledColor,
    this.disabledColor,
    this.pointOfInterest,
  });

  factory LaserlineViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LaserlineViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'style',
      'width',
      'enabledColor',
      'disabledColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LaserlineViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LaserlineViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['laserline'].contains(typeRaw)) {
        throw FormatException("LaserlineViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LaserlineViewfinder.type: null is not allowed');
    }
    final hasStyle = raw.containsKey('style');
    final styleRaw = raw['style'];
    String? styleValue;
    if (hasStyle && styleRaw != null) {
      if (styleRaw is! String || !const <String>['legacy', 'animated'].contains(styleRaw)) {
        throw FormatException("LaserlineViewfinder.style: unknown enum value '$styleRaw'");
      }
      styleValue = styleRaw;
    } else if (hasStyle && styleRaw == null) {
      throw FormatException('LaserlineViewfinder.style: null is not allowed');
    }
    final hasWidth = raw.containsKey('width');
    final widthRaw = raw['width'];
    UIValue? widthValue;
    if (hasWidth && widthRaw != null) {
      widthValue = UIValue.fromJson(widthRaw);
    } else if (hasWidth && widthRaw == null) {
      throw FormatException('LaserlineViewfinder.width: null is not allowed');
    }
    final hasEnabledColor = raw.containsKey('enabledColor');
    final enabledColorRaw = raw['enabledColor'];
    Color? enabledColorValue;
    if (hasEnabledColor && enabledColorRaw != null) {
      enabledColorValue = parseColor(enabledColorRaw);
    } else if (hasEnabledColor && enabledColorRaw == null) {
      throw FormatException('LaserlineViewfinder.enabledColor: null is not allowed');
    }
    final hasDisabledColor = raw.containsKey('disabledColor');
    final disabledColorRaw = raw['disabledColor'];
    Color? disabledColorValue;
    if (hasDisabledColor && disabledColorRaw != null) {
      disabledColorValue = parseColor(disabledColorRaw);
    } else if (hasDisabledColor && disabledColorRaw == null) {
      throw FormatException('LaserlineViewfinder.disabledColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return LaserlineViewfinder(
      type: typeValue!,
      style: styleValue,
      width: widthValue,
      enabledColor: enabledColorValue,
      disabledColor: disabledColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (style != null) {
      map['style'] = style;
    }
    if (width != null) {
      map['width'] = width!.toJson();
    }
    if (enabledColor != null) {
      map['enabledColor'] = enabledColor;
    }
    if (disabledColor != null) {
      map['disabledColor'] = disabledColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `LaserlineViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLaserlineViewfinder({
  required String type,
  String? style,
  Object? width,
  Color? enabledColor,
  Color? disabledColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (style != null) {
    map['style'] = style;
  }
  if (width != null) {
    map['width'] = width;
  }
  if (enabledColor != null) {
    map['enabledColor'] = enabledColor;
  }
  if (disabledColor != null) {
    map['disabledColor'] = disabledColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a circular spotlight around the scan area. No current SDK (C++, iOS, Android, Web) deserializes this type; retained as a tombstone for backward-compatible payload validation.
class SpotlightViewfinder implements Viewfinder {
  final String type;
  final UIAspectSize? size;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;
  final UIPoint? pointOfInterest;

  const SpotlightViewfinder({
    required this.type,
    this.size,
    this.enabledBorderColor,
    this.disabledBorderColor,
    this.pointOfInterest,
  });

  factory SpotlightViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('SpotlightViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'size',
      'enabledBorderColor',
      'disabledBorderColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("SpotlightViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("SpotlightViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['spotlight'].contains(typeRaw)) {
        throw FormatException("SpotlightViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('SpotlightViewfinder.type: null is not allowed');
    }
    final hasSize = raw.containsKey('size');
    final sizeRaw = raw['size'];
    UIAspectSize? sizeValue;
    if (hasSize && sizeRaw != null) {
      sizeValue = UIAspectSize.fromJson(sizeRaw);
    } else if (hasSize && sizeRaw == null) {
      throw FormatException('SpotlightViewfinder.size: null is not allowed');
    }
    final hasEnabledBorderColor = raw.containsKey('enabledBorderColor');
    final enabledBorderColorRaw = raw['enabledBorderColor'];
    Color? enabledBorderColorValue;
    if (hasEnabledBorderColor && enabledBorderColorRaw != null) {
      enabledBorderColorValue = parseColor(enabledBorderColorRaw);
    } else if (hasEnabledBorderColor && enabledBorderColorRaw == null) {
      throw FormatException('SpotlightViewfinder.enabledBorderColor: null is not allowed');
    }
    final hasDisabledBorderColor = raw.containsKey('disabledBorderColor');
    final disabledBorderColorRaw = raw['disabledBorderColor'];
    Color? disabledBorderColorValue;
    if (hasDisabledBorderColor && disabledBorderColorRaw != null) {
      disabledBorderColorValue = parseColor(disabledBorderColorRaw);
    } else if (hasDisabledBorderColor && disabledBorderColorRaw == null) {
      throw FormatException('SpotlightViewfinder.disabledBorderColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return SpotlightViewfinder(
      type: typeValue!,
      size: sizeValue,
      enabledBorderColor: enabledBorderColorValue,
      disabledBorderColor: disabledBorderColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (size != null) {
      map['size'] = size!.toJson();
    }
    if (enabledBorderColor != null) {
      map['enabledBorderColor'] = enabledBorderColor;
    }
    if (disabledBorderColor != null) {
      map['disabledBorderColor'] = disabledBorderColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `SpotlightViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildSpotlightViewfinder({
  required String type,
  Object? size,
  Color? enabledBorderColor,
  Color? disabledBorderColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (size != null) {
    map['size'] = size;
  }
  if (enabledBorderColor != null) {
    map['enabledBorderColor'] = enabledBorderColor;
  }
  if (disabledBorderColor != null) {
    map['disabledBorderColor'] = disabledBorderColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws an aimer frame and dot at the point of interest.
class AimerViewfinder implements Viewfinder {
  final String type;
  final Color? frameColor;
  final Color? dotColor;
  final UIPoint? pointOfInterest;

  const AimerViewfinder({
    required this.type,
    this.frameColor,
    this.dotColor,
    this.pointOfInterest,
  });

  factory AimerViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('AimerViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'frameColor',
      'dotColor',
      'pointOfInterest',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("AimerViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("AimerViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['aimer'].contains(typeRaw)) {
        throw FormatException("AimerViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('AimerViewfinder.type: null is not allowed');
    }
    final hasFrameColor = raw.containsKey('frameColor');
    final frameColorRaw = raw['frameColor'];
    Color? frameColorValue;
    if (hasFrameColor && frameColorRaw != null) {
      frameColorValue = parseColor(frameColorRaw);
    } else if (hasFrameColor && frameColorRaw == null) {
      throw FormatException('AimerViewfinder.frameColor: null is not allowed');
    }
    final hasDotColor = raw.containsKey('dotColor');
    final dotColorRaw = raw['dotColor'];
    Color? dotColorValue;
    if (hasDotColor && dotColorRaw != null) {
      dotColorValue = parseColor(dotColorRaw);
    } else if (hasDotColor && dotColorRaw == null) {
      throw FormatException('AimerViewfinder.dotColor: null is not allowed');
    }
    final hasPointOfInterest = raw.containsKey('pointOfInterest');
    final pointOfInterestRaw = raw['pointOfInterest'];
    UIPoint? pointOfInterestValue;
    if (hasPointOfInterest && pointOfInterestRaw != null) {
      pointOfInterestValue = UIPoint.fromJson(pointOfInterestRaw);
    }
    return AimerViewfinder(
      type: typeValue!,
      frameColor: frameColorValue,
      dotColor: dotColorValue,
      pointOfInterest: pointOfInterestValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (frameColor != null) {
      map['frameColor'] = frameColor;
    }
    if (dotColor != null) {
      map['dotColor'] = dotColor;
    }
    if (pointOfInterest != null) {
      map['pointOfInterest'] = pointOfInterest!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `AimerViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildAimerViewfinder({
  required String type,
  Color? frameColor,
  Color? dotColor,
  Object? pointOfInterest = _unset,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (frameColor != null) {
    map['frameColor'] = frameColor;
  }
  if (dotColor != null) {
    map['dotColor'] = dotColor;
  }
  if (!identical(pointOfInterest, _unset)) {
    map['pointOfInterest'] = pointOfInterest;
  }
  return map;
}

/// A viewfinder that draws a target aimer with crosshair lines and a circular aimer.
class TargetAimerViewfinder implements Viewfinder {
  final String type;
  final Color? lineColor;
  final double? lineStrokeWidth;
  final Color? aimerColor;
  final UIValue? radius;

  const TargetAimerViewfinder({
    required this.type,
    this.lineColor,
    this.lineStrokeWidth,
    this.aimerColor,
    this.radius,
  });

  factory TargetAimerViewfinder.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('TargetAimerViewfinder: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'lineColor',
      'lineStrokeWidth',
      'aimerColor',
      'radius',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("TargetAimerViewfinder: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("TargetAimerViewfinder.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['targetAimer'].contains(typeRaw)) {
        throw FormatException("TargetAimerViewfinder.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('TargetAimerViewfinder.type: null is not allowed');
    }
    final hasLineColor = raw.containsKey('lineColor');
    final lineColorRaw = raw['lineColor'];
    Color? lineColorValue;
    if (hasLineColor && lineColorRaw != null) {
      lineColorValue = parseColor(lineColorRaw);
    } else if (hasLineColor && lineColorRaw == null) {
      throw FormatException('TargetAimerViewfinder.lineColor: null is not allowed');
    }
    final hasLineStrokeWidth = raw.containsKey('lineStrokeWidth');
    final lineStrokeWidthRaw = raw['lineStrokeWidth'];
    double? lineStrokeWidthValue;
    if (hasLineStrokeWidth && lineStrokeWidthRaw != null) {
      if (lineStrokeWidthRaw is! num) {
        throw FormatException('TargetAimerViewfinder.lineStrokeWidth: expected a number');
      }
      lineStrokeWidthValue = lineStrokeWidthRaw.toDouble();
    } else if (hasLineStrokeWidth && lineStrokeWidthRaw == null) {
      throw FormatException('TargetAimerViewfinder.lineStrokeWidth: null is not allowed');
    }
    final hasAimerColor = raw.containsKey('aimerColor');
    final aimerColorRaw = raw['aimerColor'];
    Color? aimerColorValue;
    if (hasAimerColor && aimerColorRaw != null) {
      aimerColorValue = parseColor(aimerColorRaw);
    } else if (hasAimerColor && aimerColorRaw == null) {
      throw FormatException('TargetAimerViewfinder.aimerColor: null is not allowed');
    }
    final hasRadius = raw.containsKey('radius');
    final radiusRaw = raw['radius'];
    UIValue? radiusValue;
    if (hasRadius && radiusRaw != null) {
      radiusValue = UIValue.fromJson(radiusRaw);
    } else if (hasRadius && radiusRaw == null) {
      throw FormatException('TargetAimerViewfinder.radius: null is not allowed');
    }
    return TargetAimerViewfinder(
      type: typeValue!,
      lineColor: lineColorValue,
      lineStrokeWidth: lineStrokeWidthValue,
      aimerColor: aimerColorValue,
      radius: radiusValue,
    );
  }

  @override
  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (lineColor != null) {
      map['lineColor'] = lineColor;
    }
    if (lineStrokeWidth != null) {
      map['lineStrokeWidth'] = lineStrokeWidth;
    }
    if (aimerColor != null) {
      map['aimerColor'] = aimerColor;
    }
    if (radius != null) {
      map['radius'] = radius!.toJson();
    }
    return map;
  }
}

/// Typed builder for the `TargetAimerViewfinder` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildTargetAimerViewfinder({
  required String type,
  Color? lineColor,
  double? lineStrokeWidth,
  Color? aimerColor,
  Object? radius,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (lineColor != null) {
    map['lineColor'] = lineColor;
  }
  if (lineStrokeWidth != null) {
    map['lineStrokeWidth'] = lineStrokeWidth;
  }
  if (aimerColor != null) {
    map['aimerColor'] = aimerColor;
  }
  if (radius != null) {
    map['radius'] = radius;
  }
  return map;
}

/// The advanced overlay for label capture, supporting custom AR annotations per label.
class LabelCaptureAdvancedOverlay {
  final String type;
  final bool? shouldShowScanAreaGuides;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureAdvancedOverlay({
    required this.type,
    this.shouldShowScanAreaGuides,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureAdvancedOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'shouldShowScanAreaGuides',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureAdvancedOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['labelCaptureAdvanced'].contains(typeRaw)) {
        throw FormatException("LabelCaptureAdvancedOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.type: null is not allowed');
    }
    final hasShouldShowScanAreaGuides = raw.containsKey('shouldShowScanAreaGuides');
    final shouldShowScanAreaGuidesRaw = raw['shouldShowScanAreaGuides'];
    bool? shouldShowScanAreaGuidesValue;
    if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw != null) {
      if (shouldShowScanAreaGuidesRaw is! bool) {
        throw FormatException('LabelCaptureAdvancedOverlay.shouldShowScanAreaGuides: expected a bool');
      }
      shouldShowScanAreaGuidesValue = shouldShowScanAreaGuidesRaw;
    } else if (hasShouldShowScanAreaGuides && shouldShowScanAreaGuidesRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.shouldShowScanAreaGuides: null is not allowed');
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureAdvancedOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureAdvancedOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureAdvancedOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureAdvancedOverlay(
      type: typeValue!,
      shouldShowScanAreaGuides: shouldShowScanAreaGuidesValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (shouldShowScanAreaGuides != null) {
      map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlay({
  required String type,
  bool? shouldShowScanAreaGuides,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (shouldShowScanAreaGuides != null) {
    map['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// The validation flow overlay for label capture, guiding users through manual input of missing or invalid fields.
class LabelCaptureValidationFlowOverlay {
  final String type;
  final bool? shouldHandleKeyboardInsetsInternally;
  final LabelCaptureValidationFlowSettings? settings;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureValidationFlowOverlay({
    required this.type,
    this.shouldHandleKeyboardInsetsInternally,
    this.settings,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureValidationFlowOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'shouldHandleKeyboardInsetsInternally',
      'settings',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureValidationFlowOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureValidationFlowOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['validationFlow'].contains(typeRaw)) {
        throw FormatException("LabelCaptureValidationFlowOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.type: null is not allowed');
    }
    final hasShouldHandleKeyboardInsetsInternally = raw.containsKey('shouldHandleKeyboardInsetsInternally');
    final shouldHandleKeyboardInsetsInternallyRaw = raw['shouldHandleKeyboardInsetsInternally'];
    bool? shouldHandleKeyboardInsetsInternallyValue;
    if (hasShouldHandleKeyboardInsetsInternally && shouldHandleKeyboardInsetsInternallyRaw != null) {
      if (shouldHandleKeyboardInsetsInternallyRaw is! bool) {
        throw FormatException(
            'LabelCaptureValidationFlowOverlay.shouldHandleKeyboardInsetsInternally: expected a bool');
      }
      shouldHandleKeyboardInsetsInternallyValue = shouldHandleKeyboardInsetsInternallyRaw;
    } else if (hasShouldHandleKeyboardInsetsInternally && shouldHandleKeyboardInsetsInternallyRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowOverlay.shouldHandleKeyboardInsetsInternally: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureValidationFlowSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureValidationFlowSettings.fromJson(settingsRaw);
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureValidationFlowOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureValidationFlowOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureValidationFlowOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureValidationFlowOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureValidationFlowOverlay(
      type: typeValue!,
      shouldHandleKeyboardInsetsInternally: shouldHandleKeyboardInsetsInternallyValue,
      settings: settingsValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (shouldHandleKeyboardInsetsInternally != null) {
      map['shouldHandleKeyboardInsetsInternally'] = shouldHandleKeyboardInsetsInternally;
    }
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowOverlay({
  required String type,
  bool? shouldHandleKeyboardInsetsInternally,
  Object? settings = _unset,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (shouldHandleKeyboardInsetsInternally != null) {
    map['shouldHandleKeyboardInsetsInternally'] = shouldHandleKeyboardInsetsInternally;
  }
  if (!identical(settings, _unset)) {
    map['settings'] = settings;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Text and placeholder configuration for the label capture validation flow.
class LabelCaptureValidationFlowSettings {
  final String? missingFieldsHint;
  final String? standbyHint;
  final String? validationHint;
  final String? validationError;
  final String? requiredFieldError;
  final String? manualInputButtonText;
  final String? validationFinishButtonText;
  final String? validationRestartButtonText;
  final String? validationPauseButtonText;
  final String? validationAdaptiveScanningText;
  final String? validationScanningText;
  final Object? labelDefinitionsPlaceholders;

  const LabelCaptureValidationFlowSettings({
    this.missingFieldsHint,
    this.standbyHint,
    this.validationHint,
    this.validationError,
    this.requiredFieldError,
    this.manualInputButtonText,
    this.validationFinishButtonText,
    this.validationRestartButtonText,
    this.validationPauseButtonText,
    this.validationAdaptiveScanningText,
    this.validationScanningText,
    this.labelDefinitionsPlaceholders,
  });

  factory LabelCaptureValidationFlowSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'missingFieldsHint',
      'standbyHint',
      'validationHint',
      'validationError',
      'requiredFieldError',
      'manualInputButtonText',
      'validationFinishButtonText',
      'validationRestartButtonText',
      'validationPauseButtonText',
      'validationAdaptiveScanningText',
      'validationScanningText',
      'labelDefinitionsPlaceholders',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureValidationFlowSettings: unknown property '$key'");
      }
    }
    final hasMissingFieldsHint = raw.containsKey('missingFieldsHint');
    final missingFieldsHintRaw = raw['missingFieldsHint'];
    String? missingFieldsHintValue;
    if (hasMissingFieldsHint && missingFieldsHintRaw != null) {
      if (missingFieldsHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.missingFieldsHint: expected a String');
      }
      missingFieldsHintValue = missingFieldsHintRaw;
    } else if (hasMissingFieldsHint && missingFieldsHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.missingFieldsHint: null is not allowed');
    }
    final hasStandbyHint = raw.containsKey('standbyHint');
    final standbyHintRaw = raw['standbyHint'];
    String? standbyHintValue;
    if (hasStandbyHint && standbyHintRaw != null) {
      if (standbyHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.standbyHint: expected a String');
      }
      standbyHintValue = standbyHintRaw;
    } else if (hasStandbyHint && standbyHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.standbyHint: null is not allowed');
    }
    final hasValidationHint = raw.containsKey('validationHint');
    final validationHintRaw = raw['validationHint'];
    String? validationHintValue;
    if (hasValidationHint && validationHintRaw != null) {
      if (validationHintRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationHint: expected a String');
      }
      validationHintValue = validationHintRaw;
    } else if (hasValidationHint && validationHintRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationHint: null is not allowed');
    }
    final hasValidationError = raw.containsKey('validationError');
    final validationErrorRaw = raw['validationError'];
    String? validationErrorValue;
    if (hasValidationError && validationErrorRaw != null) {
      if (validationErrorRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationError: expected a String');
      }
      validationErrorValue = validationErrorRaw;
    } else if (hasValidationError && validationErrorRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationError: null is not allowed');
    }
    final hasRequiredFieldError = raw.containsKey('requiredFieldError');
    final requiredFieldErrorRaw = raw['requiredFieldError'];
    String? requiredFieldErrorValue;
    if (hasRequiredFieldError && requiredFieldErrorRaw != null) {
      if (requiredFieldErrorRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.requiredFieldError: expected a String');
      }
      requiredFieldErrorValue = requiredFieldErrorRaw;
    } else if (hasRequiredFieldError && requiredFieldErrorRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.requiredFieldError: null is not allowed');
    }
    final hasManualInputButtonText = raw.containsKey('manualInputButtonText');
    final manualInputButtonTextRaw = raw['manualInputButtonText'];
    String? manualInputButtonTextValue;
    if (hasManualInputButtonText && manualInputButtonTextRaw != null) {
      if (manualInputButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.manualInputButtonText: expected a String');
      }
      manualInputButtonTextValue = manualInputButtonTextRaw;
    } else if (hasManualInputButtonText && manualInputButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.manualInputButtonText: null is not allowed');
    }
    final hasValidationFinishButtonText = raw.containsKey('validationFinishButtonText');
    final validationFinishButtonTextRaw = raw['validationFinishButtonText'];
    String? validationFinishButtonTextValue;
    if (hasValidationFinishButtonText && validationFinishButtonTextRaw != null) {
      if (validationFinishButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationFinishButtonText: expected a String');
      }
      validationFinishButtonTextValue = validationFinishButtonTextRaw;
    } else if (hasValidationFinishButtonText && validationFinishButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationFinishButtonText: null is not allowed');
    }
    final hasValidationRestartButtonText = raw.containsKey('validationRestartButtonText');
    final validationRestartButtonTextRaw = raw['validationRestartButtonText'];
    String? validationRestartButtonTextValue;
    if (hasValidationRestartButtonText && validationRestartButtonTextRaw != null) {
      if (validationRestartButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationRestartButtonText: expected a String');
      }
      validationRestartButtonTextValue = validationRestartButtonTextRaw;
    } else if (hasValidationRestartButtonText && validationRestartButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationRestartButtonText: null is not allowed');
    }
    final hasValidationPauseButtonText = raw.containsKey('validationPauseButtonText');
    final validationPauseButtonTextRaw = raw['validationPauseButtonText'];
    String? validationPauseButtonTextValue;
    if (hasValidationPauseButtonText && validationPauseButtonTextRaw != null) {
      if (validationPauseButtonTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationPauseButtonText: expected a String');
      }
      validationPauseButtonTextValue = validationPauseButtonTextRaw;
    } else if (hasValidationPauseButtonText && validationPauseButtonTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationPauseButtonText: null is not allowed');
    }
    final hasValidationAdaptiveScanningText = raw.containsKey('validationAdaptiveScanningText');
    final validationAdaptiveScanningTextRaw = raw['validationAdaptiveScanningText'];
    String? validationAdaptiveScanningTextValue;
    if (hasValidationAdaptiveScanningText && validationAdaptiveScanningTextRaw != null) {
      if (validationAdaptiveScanningTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationAdaptiveScanningText: expected a String');
      }
      validationAdaptiveScanningTextValue = validationAdaptiveScanningTextRaw;
    } else if (hasValidationAdaptiveScanningText && validationAdaptiveScanningTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationAdaptiveScanningText: null is not allowed');
    }
    final hasValidationScanningText = raw.containsKey('validationScanningText');
    final validationScanningTextRaw = raw['validationScanningText'];
    String? validationScanningTextValue;
    if (hasValidationScanningText && validationScanningTextRaw != null) {
      if (validationScanningTextRaw is! String) {
        throw FormatException('LabelCaptureValidationFlowSettings.validationScanningText: expected a String');
      }
      validationScanningTextValue = validationScanningTextRaw;
    } else if (hasValidationScanningText && validationScanningTextRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.validationScanningText: null is not allowed');
    }
    final hasLabelDefinitionsPlaceholders = raw.containsKey('labelDefinitionsPlaceholders');
    final labelDefinitionsPlaceholdersRaw = raw['labelDefinitionsPlaceholders'];
    Object? labelDefinitionsPlaceholdersValue;
    if (hasLabelDefinitionsPlaceholders && labelDefinitionsPlaceholdersRaw != null) {
      labelDefinitionsPlaceholdersValue = labelDefinitionsPlaceholdersRaw;
    } else if (hasLabelDefinitionsPlaceholders && labelDefinitionsPlaceholdersRaw == null) {
      throw FormatException('LabelCaptureValidationFlowSettings.labelDefinitionsPlaceholders: null is not allowed');
    }
    return LabelCaptureValidationFlowSettings(
      missingFieldsHint: missingFieldsHintValue,
      standbyHint: standbyHintValue,
      validationHint: validationHintValue,
      validationError: validationErrorValue,
      requiredFieldError: requiredFieldErrorValue,
      manualInputButtonText: manualInputButtonTextValue,
      validationFinishButtonText: validationFinishButtonTextValue,
      validationRestartButtonText: validationRestartButtonTextValue,
      validationPauseButtonText: validationPauseButtonTextValue,
      validationAdaptiveScanningText: validationAdaptiveScanningTextValue,
      validationScanningText: validationScanningTextValue,
      labelDefinitionsPlaceholders: labelDefinitionsPlaceholdersValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (missingFieldsHint != null) {
      map['missingFieldsHint'] = missingFieldsHint;
    }
    if (standbyHint != null) {
      map['standbyHint'] = standbyHint;
    }
    if (validationHint != null) {
      map['validationHint'] = validationHint;
    }
    if (validationError != null) {
      map['validationError'] = validationError;
    }
    if (requiredFieldError != null) {
      map['requiredFieldError'] = requiredFieldError;
    }
    if (manualInputButtonText != null) {
      map['manualInputButtonText'] = manualInputButtonText;
    }
    if (validationFinishButtonText != null) {
      map['validationFinishButtonText'] = validationFinishButtonText;
    }
    if (validationRestartButtonText != null) {
      map['validationRestartButtonText'] = validationRestartButtonText;
    }
    if (validationPauseButtonText != null) {
      map['validationPauseButtonText'] = validationPauseButtonText;
    }
    if (validationAdaptiveScanningText != null) {
      map['validationAdaptiveScanningText'] = validationAdaptiveScanningText;
    }
    if (validationScanningText != null) {
      map['validationScanningText'] = validationScanningText;
    }
    if (labelDefinitionsPlaceholders != null) {
      map['labelDefinitionsPlaceholders'] = labelDefinitionsPlaceholders;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowSettings({
  String? missingFieldsHint,
  String? standbyHint,
  String? validationHint,
  String? validationError,
  String? requiredFieldError,
  String? manualInputButtonText,
  String? validationFinishButtonText,
  String? validationRestartButtonText,
  String? validationPauseButtonText,
  String? validationAdaptiveScanningText,
  String? validationScanningText,
  Object? labelDefinitionsPlaceholders,
}) {
  final map = <String, Object?>{};
  if (missingFieldsHint != null) {
    map['missingFieldsHint'] = missingFieldsHint;
  }
  if (standbyHint != null) {
    map['standbyHint'] = standbyHint;
  }
  if (validationHint != null) {
    map['validationHint'] = validationHint;
  }
  if (validationError != null) {
    map['validationError'] = validationError;
  }
  if (requiredFieldError != null) {
    map['requiredFieldError'] = requiredFieldError;
  }
  if (manualInputButtonText != null) {
    map['manualInputButtonText'] = manualInputButtonText;
  }
  if (validationFinishButtonText != null) {
    map['validationFinishButtonText'] = validationFinishButtonText;
  }
  if (validationRestartButtonText != null) {
    map['validationRestartButtonText'] = validationRestartButtonText;
  }
  if (validationPauseButtonText != null) {
    map['validationPauseButtonText'] = validationPauseButtonText;
  }
  if (validationAdaptiveScanningText != null) {
    map['validationAdaptiveScanningText'] = validationAdaptiveScanningText;
  }
  if (validationScanningText != null) {
    map['validationScanningText'] = validationScanningText;
  }
  if (labelDefinitionsPlaceholders != null) {
    map['labelDefinitionsPlaceholders'] = labelDefinitionsPlaceholders;
  }
  return map;
}

/// The adaptive recognition overlay for label capture, used to scan receipts.
class LabelCaptureAdaptiveRecognitionOverlay {
  final String type;
  final LabelCaptureAdaptiveRecognitionSettings? settings;
  final int? modeId;
  final bool? hasListener;

  const LabelCaptureAdaptiveRecognitionOverlay({
    required this.type,
    this.settings,
    this.modeId,
    this.hasListener,
  });

  factory LabelCaptureAdaptiveRecognitionOverlay.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay: expected a Map');
    }
    const allowedKeys = <String>{
      'type',
      'settings',
      'modeId',
      'hasListener',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionOverlay: unknown property '$key'");
      }
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException("LabelCaptureAdaptiveRecognitionOverlay.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['receiptScanning'].contains(typeRaw)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionOverlay.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.type: null is not allowed');
    }
    final hasSettings = raw.containsKey('settings');
    final settingsRaw = raw['settings'];
    LabelCaptureAdaptiveRecognitionSettings? settingsValue;
    if (hasSettings && settingsRaw != null) {
      settingsValue = LabelCaptureAdaptiveRecognitionSettings.fromJson(settingsRaw);
    }
    final hasModeId = raw.containsKey('modeId');
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.modeId: null is not allowed');
    }
    final hasHasListener = raw.containsKey('hasListener');
    final hasListenerRaw = raw['hasListener'];
    bool? hasListenerValue;
    if (hasHasListener && hasListenerRaw != null) {
      if (hasListenerRaw is! bool) {
        throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.hasListener: expected a bool');
      }
      hasListenerValue = hasListenerRaw;
    } else if (hasHasListener && hasListenerRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionOverlay.hasListener: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionOverlay(
      type: typeValue!,
      settings: settingsValue,
      modeId: modeIdValue,
      hasListener: hasListenerValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['type'] = type;
    if (settings != null) {
      map['settings'] = settings!.toJson();
    }
    if (modeId != null) {
      map['modeId'] = modeId;
    }
    if (hasListener != null) {
      map['hasListener'] = hasListener;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionOverlay` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionOverlay({
  required String type,
  Object? settings = _unset,
  int? modeId,
  bool? hasListener,
}) {
  final map = <String, Object?>{};
  map['type'] = type;
  if (!identical(settings, _unset)) {
    map['settings'] = settings;
  }
  if (modeId != null) {
    map['modeId'] = modeId;
  }
  if (hasListener != null) {
    map['hasListener'] = hasListener;
  }
  return map;
}

/// Configuration for adaptive recognition, applied to the label capture adaptive recognition overlay.
class LabelCaptureAdaptiveRecognitionSettings {
  final String? processingHint;
  final String? processingHintText;
  final String? resultType;

  const LabelCaptureAdaptiveRecognitionSettings({
    this.processingHint,
    this.processingHintText,
    this.resultType,
  });

  factory LabelCaptureAdaptiveRecognitionSettings.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings: expected a Map');
    }
    const allowedKeys = <String>{
      'processingHint',
      'processingHintText',
      'resultType',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionSettings: unknown property '$key'");
      }
    }
    final hasProcessingHint = raw.containsKey('processingHint');
    final processingHintRaw = raw['processingHint'];
    String? processingHintValue;
    if (hasProcessingHint && processingHintRaw != null) {
      if (processingHintRaw is! String) {
        throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHint: expected a String');
      }
      processingHintValue = processingHintRaw;
    } else if (hasProcessingHint && processingHintRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHint: null is not allowed');
    }
    final hasProcessingHintText = raw.containsKey('processingHintText');
    final processingHintTextRaw = raw['processingHintText'];
    String? processingHintTextValue;
    if (hasProcessingHintText && processingHintTextRaw != null) {
      if (processingHintTextRaw is! String) {
        throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHintText: expected a String');
      }
      processingHintTextValue = processingHintTextRaw;
    } else if (hasProcessingHintText && processingHintTextRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.processingHintText: null is not allowed');
    }
    final hasResultType = raw.containsKey('resultType');
    final resultTypeRaw = raw['resultType'];
    String? resultTypeValue;
    if (hasResultType && resultTypeRaw != null) {
      if (resultTypeRaw is! String || !const <String>['receipt'].contains(resultTypeRaw)) {
        throw FormatException(
            "LabelCaptureAdaptiveRecognitionSettings.resultType: unknown enum value '$resultTypeRaw'");
      }
      resultTypeValue = resultTypeRaw;
    } else if (hasResultType && resultTypeRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionSettings.resultType: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionSettings(
      processingHint: processingHintValue,
      processingHintText: processingHintTextValue,
      resultType: resultTypeValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (processingHint != null) {
      map['processingHint'] = processingHint;
    }
    if (processingHintText != null) {
      map['processingHintText'] = processingHintText;
    }
    if (resultType != null) {
      map['resultType'] = resultType;
    }
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionSettings` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionSettings({
  String? processingHint,
  String? processingHintText,
  String? resultType,
}) {
  final map = <String, Object?>{};
  if (processingHint != null) {
    map['processingHint'] = processingHint;
  }
  if (processingHintText != null) {
    map['processingHintText'] = processingHintText;
  }
  if (resultType != null) {
    map['resultType'] = resultType;
  }
  return map;
}

/// Notifies the listener that LabelCapture updated its session.
class LabelCaptureListenerDidUpdateSession {
  final String session;
  final String? frameId;
  final int modeId;
  final String event;

  const LabelCaptureListenerDidUpdateSession({
    required this.session,
    this.frameId,
    required this.modeId,
    required this.event,
  });

  factory LabelCaptureListenerDidUpdateSession.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureListenerDidUpdateSession: expected a Map');
    }
    const allowedKeys = <String>{
      'session',
      'frameId',
      'modeId',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureListenerDidUpdateSession: unknown property '$key'");
      }
    }
    final hasSession = raw.containsKey('session');
    if (!hasSession) {
      throw FormatException("LabelCaptureListenerDidUpdateSession.session: missing required property");
    }
    final sessionRaw = raw['session'];
    String? sessionValue;
    if (hasSession && sessionRaw != null) {
      if (sessionRaw is! String) {
        throw FormatException('LabelCaptureListenerDidUpdateSession.session: expected a String');
      }
      sessionValue = sessionRaw;
    } else if (hasSession && sessionRaw == null) {
      throw FormatException('LabelCaptureListenerDidUpdateSession.session: null is not allowed');
    }
    final hasFrameId = raw.containsKey('frameId');
    if (!hasFrameId) {
      throw FormatException("LabelCaptureListenerDidUpdateSession.frameId: missing required property");
    }
    final frameIdRaw = raw['frameId'];
    String? frameIdValue;
    if (hasFrameId && frameIdRaw != null) {
      if (frameIdRaw is! String) {
        throw FormatException('LabelCaptureListenerDidUpdateSession.frameId: expected a String');
      }
      frameIdValue = frameIdRaw;
    }
    final hasModeId = raw.containsKey('modeId');
    if (!hasModeId) {
      throw FormatException("LabelCaptureListenerDidUpdateSession.modeId: missing required property");
    }
    final modeIdRaw = raw['modeId'];
    int? modeIdValue;
    if (hasModeId && modeIdRaw != null) {
      if (modeIdRaw is! num) {
        throw FormatException('LabelCaptureListenerDidUpdateSession.modeId: expected a number');
      }
      if (modeIdRaw != modeIdRaw.toInt()) {
        throw FormatException('LabelCaptureListenerDidUpdateSession.modeId: expected an integer');
      }
      modeIdValue = modeIdRaw.toInt();
    } else if (hasModeId && modeIdRaw == null) {
      throw FormatException('LabelCaptureListenerDidUpdateSession.modeId: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureListenerDidUpdateSession.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['LabelCaptureListener.didUpdateSession'].contains(eventRaw)) {
        throw FormatException("LabelCaptureListenerDidUpdateSession.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureListenerDidUpdateSession.event: null is not allowed');
    }
    return LabelCaptureListenerDidUpdateSession(
      session: sessionValue!,
      frameId: frameIdValue,
      modeId: modeIdValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['session'] = session;
    map['frameId'] = frameId;
    map['modeId'] = modeId;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureListenerDidUpdateSession` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureListenerDidUpdateSession({
  required String session,
  required String? frameId,
  required int modeId,
  required String event,
}) {
  final map = <String, Object?>{};
  map['session'] = session;
  map['frameId'] = frameId;
  map['modeId'] = modeId;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the user tapped a captured label in the basic overlay.
class LabelCaptureBasicOverlayListenerDidTapLabel {
  final String label;
  final String event;

  const LabelCaptureBasicOverlayListenerDidTapLabel({
    required this.label,
    required this.event,
  });

  factory LabelCaptureBasicOverlayListenerDidTapLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureBasicOverlayListenerDidTapLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureBasicOverlayListenerDidTapLabel: unknown property '$key'");
      }
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureBasicOverlayListenerDidTapLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureBasicOverlayListenerDidTapLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerDidTapLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureBasicOverlayListenerDidTapLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['LabelCaptureBasicOverlayListener.didTapLabel'].contains(eventRaw)) {
        throw FormatException("LabelCaptureBasicOverlayListenerDidTapLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerDidTapLabel.event: null is not allowed');
    }
    return LabelCaptureBasicOverlayListenerDidTapLabel(
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureBasicOverlayListenerDidTapLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureBasicOverlayListenerDidTapLabel({
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the brush to use for a captured label in the basic overlay.
class LabelCaptureBasicOverlayListenerBrushForLabel {
  final String label;
  final String event;

  const LabelCaptureBasicOverlayListenerBrushForLabel({
    required this.label,
    required this.event,
  });

  factory LabelCaptureBasicOverlayListenerBrushForLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureBasicOverlayListenerBrushForLabel: unknown property '$key'");
      }
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureBasicOverlayListenerBrushForLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureBasicOverlayListenerBrushForLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureBasicOverlayListenerBrushForLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String || !const <String>['LabelCaptureBasicOverlayListener.brushForLabel'].contains(eventRaw)) {
        throw FormatException("LabelCaptureBasicOverlayListenerBrushForLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForLabel.event: null is not allowed');
    }
    return LabelCaptureBasicOverlayListenerBrushForLabel(
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureBasicOverlayListenerBrushForLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureBasicOverlayListenerBrushForLabel({
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the brush to use for a captured label field in the basic overlay.
class LabelCaptureBasicOverlayListenerBrushForFieldOfLabel {
  final String field;
  final String label;
  final String event;

  const LabelCaptureBasicOverlayListenerBrushForFieldOfLabel({
    required this.field,
    required this.label,
    required this.event,
  });

  factory LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'field',
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureBasicOverlayListenerBrushForFieldOfLabel: unknown property '$key'");
      }
    }
    final hasField = raw.containsKey('field');
    if (!hasField) {
      throw FormatException("LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.field: missing required property");
    }
    final fieldRaw = raw['field'];
    String? fieldValue;
    if (hasField && fieldRaw != null) {
      if (fieldRaw is! String) {
        throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.field: expected a String');
      }
      fieldValue = fieldRaw;
    } else if (hasField && fieldRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.field: null is not allowed');
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureBasicOverlayListener.brushForFieldOfLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.event: null is not allowed');
    }
    return LabelCaptureBasicOverlayListenerBrushForFieldOfLabel(
      field: fieldValue!,
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['field'] = field;
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureBasicOverlayListenerBrushForFieldOfLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureBasicOverlayListenerBrushForFieldOfLabel({
  required String field,
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['field'] = field;
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the view to display for a captured label in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerViewForLabel {
  final String label;
  final String event;

  const LabelCaptureAdvancedOverlayListenerViewForLabel({
    required this.label,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerViewForLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerViewForLabel: unknown property '$key'");
      }
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerViewForLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerViewForLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerViewForLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.viewForLabel'].contains(eventRaw)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerViewForLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerViewForLabel(
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerViewForLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerViewForLabel({
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the view to display for a captured label field in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel {
  final String field;
  final String? identifier;
  final String event;

  const LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel({
    required this.field,
    this.identifier,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'field',
      'identifier',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel: unknown property '$key'");
      }
    }
    final hasField = raw.containsKey('field');
    if (!hasField) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.field: missing required property");
    }
    final fieldRaw = raw['field'];
    String? fieldValue;
    if (hasField && fieldRaw != null) {
      if (fieldRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.field: expected a String');
      }
      fieldValue = fieldRaw;
    } else if (hasField && fieldRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.field: null is not allowed');
    }
    final hasIdentifier = raw.containsKey('identifier');
    if (!hasIdentifier) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.identifier: missing required property");
    }
    final identifierRaw = raw['identifier'];
    String? identifierValue;
    if (hasIdentifier && identifierRaw != null) {
      if (identifierRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.identifier: expected a String');
      }
      identifierValue = identifierRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel(
      field: fieldValue!,
      identifier: identifierValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['field'] = field;
    map['identifier'] = identifier;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerViewForFieldOfLabel({
  required String field,
  required String? identifier,
  required String event,
}) {
  final map = <String, Object?>{};
  map['field'] = field;
  map['identifier'] = identifier;
  map['event'] = event;
  return map;
}

/// Asks the listener for the anchor point to use for a captured label's view in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerAnchorForLabel {
  final String label;
  final String event;

  const LabelCaptureAdvancedOverlayListenerAnchorForLabel({
    required this.label,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerAnchorForLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerAnchorForLabel: unknown property '$key'");
      }
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerAnchorForLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerAnchorForLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.anchorForLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdvancedOverlayListenerAnchorForLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerAnchorForLabel(
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerAnchorForLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerAnchorForLabel({
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the anchor point to use for a captured label field's view in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel {
  final String field;
  final String? identifier;
  final String event;

  const LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel({
    required this.field,
    this.identifier,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'field',
      'identifier',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel: unknown property '$key'");
      }
    }
    final hasField = raw.containsKey('field');
    if (!hasField) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.field: missing required property");
    }
    final fieldRaw = raw['field'];
    String? fieldValue;
    if (hasField && fieldRaw != null) {
      if (fieldRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.field: expected a String');
      }
      fieldValue = fieldRaw;
    } else if (hasField && fieldRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.field: null is not allowed');
    }
    final hasIdentifier = raw.containsKey('identifier');
    if (!hasIdentifier) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.identifier: missing required property");
    }
    final identifierRaw = raw['identifier'];
    String? identifierValue;
    if (hasIdentifier && identifierRaw != null) {
      if (identifierRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.identifier: expected a String');
      }
      identifierValue = identifierRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel(
      field: fieldValue!,
      identifier: identifierValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['field'] = field;
    map['identifier'] = identifier;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel({
  required String field,
  required String? identifier,
  required String event,
}) {
  final map = <String, Object?>{};
  map['field'] = field;
  map['identifier'] = identifier;
  map['event'] = event;
  return map;
}

/// Asks the listener for the offset to apply to a captured label's view in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerOffsetForLabel {
  final String label;
  final String event;

  const LabelCaptureAdvancedOverlayListenerOffsetForLabel({
    required this.label,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerOffsetForLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'label',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerOffsetForLabel: unknown property '$key'");
      }
    }
    final hasLabel = raw.containsKey('label');
    if (!hasLabel) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerOffsetForLabel.label: missing required property");
    }
    final labelRaw = raw['label'];
    String? labelValue;
    if (hasLabel && labelRaw != null) {
      if (labelRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForLabel.label: expected a String');
      }
      labelValue = labelRaw;
    } else if (hasLabel && labelRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForLabel.label: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdvancedOverlayListenerOffsetForLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.offsetForLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdvancedOverlayListenerOffsetForLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerOffsetForLabel(
      label: labelValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['label'] = label;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerOffsetForLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerOffsetForLabel({
  required String label,
  required String event,
}) {
  final map = <String, Object?>{};
  map['label'] = label;
  map['event'] = event;
  return map;
}

/// Asks the listener for the offset to apply to a captured label field's view in the advanced overlay.
class LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel {
  final String field;
  final String? identifier;
  final String event;

  const LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel({
    required this.field,
    this.identifier,
    required this.event,
  });

  factory LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel: expected a Map');
    }
    const allowedKeys = <String>{
      'field',
      'identifier',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel: unknown property '$key'");
      }
    }
    final hasField = raw.containsKey('field');
    if (!hasField) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.field: missing required property");
    }
    final fieldRaw = raw['field'];
    String? fieldValue;
    if (hasField && fieldRaw != null) {
      if (fieldRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.field: expected a String');
      }
      fieldValue = fieldRaw;
    } else if (hasField && fieldRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.field: null is not allowed');
    }
    final hasIdentifier = raw.containsKey('identifier');
    if (!hasIdentifier) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.identifier: missing required property");
    }
    final identifierRaw = raw['identifier'];
    String? identifierValue;
    if (hasIdentifier && identifierRaw != null) {
      if (identifierRaw is! String) {
        throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.identifier: expected a String');
      }
      identifierValue = identifierRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException(
          "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.event: null is not allowed');
    }
    return LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel(
      field: fieldValue!,
      identifier: identifierValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['field'] = field;
    map['identifier'] = identifier;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel({
  required String field,
  required String? identifier,
  required String event,
}) {
  final map = <String, Object?>{};
  map['field'] = field;
  map['identifier'] = identifier;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the validation flow captured a label with the given fields.
class LabelCaptureValidationFlowListenerDidCaptureLabelWithFields {
  final List<String> fields;
  final String event;

  const LabelCaptureValidationFlowListenerDidCaptureLabelWithFields({
    required this.fields,
    required this.event,
  });

  factory LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowListenerDidCaptureLabelWithFields: expected a Map');
    }
    const allowedKeys = <String>{
      'fields',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureValidationFlowListenerDidCaptureLabelWithFields: unknown property '$key'");
      }
    }
    final hasFields = raw.containsKey('fields');
    if (!hasFields) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fields: missing required property");
    }
    final fieldsRaw = raw['fields'];
    List<String>? fieldsValue;
    if (hasFields && fieldsRaw != null) {
      if (fieldsRaw is! List) {
        throw FormatException('LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fields: expected a List');
      }
      for (final item in fieldsRaw) {
        if (item is! String) {
          throw FormatException(
              'LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fields: expected a List of String');
        }
      }
      fieldsValue = fieldsRaw.cast<String>();
    } else if (hasFields && fieldsRaw == null) {
      throw FormatException('LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fields: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureValidationFlowListener.didCaptureLabelWithFields'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.event: null is not allowed');
    }
    return LabelCaptureValidationFlowListenerDidCaptureLabelWithFields(
      fields: fieldsValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['fields'] = fields;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowListenerDidCaptureLabelWithFields` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowListenerDidCaptureLabelWithFields({
  required List<String> fields,
  required String event,
}) {
  final map = <String, Object?>{};
  map['fields'] = fields;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the user manually submitted a value for a label field in the validation flow.
class LabelCaptureValidationFlowListenerDidSubmitManualInputForField {
  final List<String> fields;
  final String? oldValue;
  final String newValue;
  final String event;

  const LabelCaptureValidationFlowListenerDidSubmitManualInputForField({
    required this.fields,
    this.oldValue,
    required this.newValue,
    required this.event,
  });

  factory LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowListenerDidSubmitManualInputForField: expected a Map');
    }
    const allowedKeys = <String>{
      'fields',
      'oldValue',
      'newValue',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidSubmitManualInputForField: unknown property '$key'");
      }
    }
    final hasFields = raw.containsKey('fields');
    if (!hasFields) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fields: missing required property");
    }
    final fieldsRaw = raw['fields'];
    List<String>? fieldsValue;
    if (hasFields && fieldsRaw != null) {
      if (fieldsRaw is! List) {
        throw FormatException('LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fields: expected a List');
      }
      for (final item in fieldsRaw) {
        if (item is! String) {
          throw FormatException(
              'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fields: expected a List of String');
        }
      }
      fieldsValue = fieldsRaw.cast<String>();
    } else if (hasFields && fieldsRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fields: null is not allowed');
    }
    final hasOldValue = raw.containsKey('oldValue');
    if (!hasOldValue) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.oldValue: missing required property");
    }
    final oldValueRaw = raw['oldValue'];
    String? oldValueValue;
    if (hasOldValue && oldValueRaw != null) {
      if (oldValueRaw is! String) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.oldValue: expected a String');
      }
      oldValueValue = oldValueRaw;
    }
    final hasNewValue = raw.containsKey('newValue');
    if (!hasNewValue) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.newValue: missing required property");
    }
    final newValueRaw = raw['newValue'];
    String? newValueValue;
    if (hasNewValue && newValueRaw != null) {
      if (newValueRaw is! String) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.newValue: expected a String');
      }
      newValueValue = newValueRaw;
    } else if (hasNewValue && newValueRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.newValue: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureValidationFlowListener.didSubmitManualInputForField'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidSubmitManualInputForField.event: null is not allowed');
    }
    return LabelCaptureValidationFlowListenerDidSubmitManualInputForField(
      fields: fieldsValue!,
      oldValue: oldValueValue,
      newValue: newValueValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['fields'] = fields;
    map['oldValue'] = oldValue;
    map['newValue'] = newValue;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowListenerDidSubmitManualInputForField` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowListenerDidSubmitManualInputForField({
  required List<String> fields,
  required String? oldValue,
  required String newValue,
  required String event,
}) {
  final map = <String, Object?>{};
  map['fields'] = fields;
  map['oldValue'] = oldValue;
  map['newValue'] = newValue;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the validation flow result was updated.
class LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult {
  final List<String> fields;
  final String type;
  final int asyncId;
  final String? frameId;
  final String event;

  const LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult({
    required this.fields,
    required this.type,
    required this.asyncId,
    this.frameId,
    required this.event,
  });

  factory LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult: expected a Map');
    }
    const allowedKeys = <String>{
      'fields',
      'type',
      'asyncId',
      'frameId',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult: unknown property '$key'");
      }
    }
    final hasFields = raw.containsKey('fields');
    if (!hasFields) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fields: missing required property");
    }
    final fieldsRaw = raw['fields'];
    List<String>? fieldsValue;
    if (hasFields && fieldsRaw != null) {
      if (fieldsRaw is! List) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fields: expected a List');
      }
      for (final item in fieldsRaw) {
        if (item is! String) {
          throw FormatException(
              'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fields: expected a List of String');
        }
      }
      fieldsValue = fieldsRaw.cast<String>();
    } else if (hasFields && fieldsRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fields: null is not allowed');
    }
    final hasType = raw.containsKey('type');
    if (!hasType) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.type: missing required property");
    }
    final typeRaw = raw['type'];
    String? typeValue;
    if (hasType && typeRaw != null) {
      if (typeRaw is! String || !const <String>['Sync', 'AsyncStarted', 'AsyncFinished'].contains(typeRaw)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.type: unknown enum value '$typeRaw'");
      }
      typeValue = typeRaw;
    } else if (hasType && typeRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.type: null is not allowed');
    }
    final hasAsyncId = raw.containsKey('asyncId');
    if (!hasAsyncId) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.asyncId: missing required property");
    }
    final asyncIdRaw = raw['asyncId'];
    int? asyncIdValue;
    if (hasAsyncId && asyncIdRaw != null) {
      if (asyncIdRaw is! num) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.asyncId: expected a number');
      }
      if (asyncIdRaw != asyncIdRaw.toInt()) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.asyncId: expected an integer');
      }
      asyncIdValue = asyncIdRaw.toInt();
    } else if (hasAsyncId && asyncIdRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.asyncId: null is not allowed');
    }
    final hasFrameId = raw.containsKey('frameId');
    if (!hasFrameId) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.frameId: missing required property");
    }
    final frameIdRaw = raw['frameId'];
    String? frameIdValue;
    if (hasFrameId && frameIdRaw != null) {
      if (frameIdRaw is! String) {
        throw FormatException(
            'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.frameId: expected a String');
      }
      frameIdValue = frameIdRaw;
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException(
          "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureValidationFlowListener.didUpdateValidationFlowResult'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException(
          'LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.event: null is not allowed');
    }
    return LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult(
      fields: fieldsValue!,
      type: typeValue!,
      asyncId: asyncIdValue!,
      frameId: frameIdValue,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['fields'] = fields;
    map['type'] = type;
    map['asyncId'] = asyncId;
    map['frameId'] = frameId;
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureValidationFlowListenerDidUpdateValidationFlowResult({
  required List<String> fields,
  required String type,
  required int asyncId,
  required String? frameId,
  required String event,
}) {
  final map = <String, Object?>{};
  map['fields'] = fields;
  map['type'] = type;
  map['asyncId'] = asyncId;
  map['frameId'] = frameId;
  map['event'] = event;
  return map;
}

/// Notifies the listener that the adaptive recognition overlay recognized a result.
class LabelCaptureAdaptiveRecognitionListenerRecognized {
  final ReceiptScanningResult result;
  final String event;

  const LabelCaptureAdaptiveRecognitionListenerRecognized({
    required this.result,
    required this.event,
  });

  factory LabelCaptureAdaptiveRecognitionListenerRecognized.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionListenerRecognized: expected a Map');
    }
    const allowedKeys = <String>{
      'result',
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionListenerRecognized: unknown property '$key'");
      }
    }
    final hasResult = raw.containsKey('result');
    if (!hasResult) {
      throw FormatException("LabelCaptureAdaptiveRecognitionListenerRecognized.result: missing required property");
    }
    final resultRaw = raw['result'];
    ReceiptScanningResult? resultValue;
    if (hasResult && resultRaw != null) {
      resultValue = ReceiptScanningResult.fromJson(resultRaw);
    } else if (hasResult && resultRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionListenerRecognized.result: null is not allowed');
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdaptiveRecognitionListenerRecognized.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdaptiveRecognitionListener.recognized'].contains(eventRaw)) {
        throw FormatException(
            "LabelCaptureAdaptiveRecognitionListenerRecognized.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionListenerRecognized.event: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionListenerRecognized(
      result: resultValue!,
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['result'] = result.toJson();
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionListenerRecognized` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionListenerRecognized({
  required Object result,
  required String event,
}) {
  final map = <String, Object?>{};
  map['result'] = result;
  map['event'] = event;
  return map;
}

/// The result of a receipt scanning operation: store information, payment details and the purchased line items. Produced by the C++ framework-bridge serializer, which both iOS (SDCReceiptScanningResult.JSONString) and Android (ReceiptScanningResult.toJson()) delegate to, so the two platforms emit identical keys. Frameworks parse this strictly (additionalProperties: false), so a key added to the serializer without updating this schema drops the recognized event on Android, iOS and Flutter; the emitted key set is pinned by native/libs/sdc/label/main/test/test_receipt_scanning_result_serializer.cc, which must change in lockstep with this file. The analytics event carries the same data under snake_case keys pinned by its own schema; that surface is separate and is not modelled here.
class ReceiptScanningResult {
  final String? storeName;
  final String? storeCity;
  final String? storeAddress;
  final String? date;
  final String? time;
  final double? paymentPreTaxTotal;
  final double? paymentTax;
  final double? paymentTotal;
  final int? loyaltyNumber;
  final List<ReceiptScanningLineItem>? lineItems;

  const ReceiptScanningResult({
    this.storeName,
    this.storeCity,
    this.storeAddress,
    this.date,
    this.time,
    this.paymentPreTaxTotal,
    this.paymentTax,
    this.paymentTotal,
    this.loyaltyNumber,
    this.lineItems,
  });

  factory ReceiptScanningResult.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ReceiptScanningResult: expected a Map');
    }
    const allowedKeys = <String>{
      'storeName',
      'storeCity',
      'storeAddress',
      'date',
      'time',
      'paymentPreTaxTotal',
      'paymentTax',
      'paymentTotal',
      'loyaltyNumber',
      'lineItems',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ReceiptScanningResult: unknown property '$key'");
      }
    }
    final hasStoreName = raw.containsKey('storeName');
    final storeNameRaw = raw['storeName'];
    String? storeNameValue;
    if (hasStoreName && storeNameRaw != null) {
      if (storeNameRaw is! String) {
        throw FormatException('ReceiptScanningResult.storeName: expected a String');
      }
      storeNameValue = storeNameRaw;
    }
    final hasStoreCity = raw.containsKey('storeCity');
    final storeCityRaw = raw['storeCity'];
    String? storeCityValue;
    if (hasStoreCity && storeCityRaw != null) {
      if (storeCityRaw is! String) {
        throw FormatException('ReceiptScanningResult.storeCity: expected a String');
      }
      storeCityValue = storeCityRaw;
    }
    final hasStoreAddress = raw.containsKey('storeAddress');
    final storeAddressRaw = raw['storeAddress'];
    String? storeAddressValue;
    if (hasStoreAddress && storeAddressRaw != null) {
      if (storeAddressRaw is! String) {
        throw FormatException('ReceiptScanningResult.storeAddress: expected a String');
      }
      storeAddressValue = storeAddressRaw;
    }
    final hasDate = raw.containsKey('date');
    final dateRaw = raw['date'];
    String? dateValue;
    if (hasDate && dateRaw != null) {
      if (dateRaw is! String) {
        throw FormatException('ReceiptScanningResult.date: expected a String');
      }
      dateValue = dateRaw;
    }
    final hasTime = raw.containsKey('time');
    final timeRaw = raw['time'];
    String? timeValue;
    if (hasTime && timeRaw != null) {
      if (timeRaw is! String) {
        throw FormatException('ReceiptScanningResult.time: expected a String');
      }
      timeValue = timeRaw;
    }
    final hasPaymentPreTaxTotal = raw.containsKey('paymentPreTaxTotal');
    final paymentPreTaxTotalRaw = raw['paymentPreTaxTotal'];
    double? paymentPreTaxTotalValue;
    if (hasPaymentPreTaxTotal && paymentPreTaxTotalRaw != null) {
      if (paymentPreTaxTotalRaw is! num) {
        throw FormatException('ReceiptScanningResult.paymentPreTaxTotal: expected a number');
      }
      paymentPreTaxTotalValue = paymentPreTaxTotalRaw.toDouble();
    }
    final hasPaymentTax = raw.containsKey('paymentTax');
    final paymentTaxRaw = raw['paymentTax'];
    double? paymentTaxValue;
    if (hasPaymentTax && paymentTaxRaw != null) {
      if (paymentTaxRaw is! num) {
        throw FormatException('ReceiptScanningResult.paymentTax: expected a number');
      }
      paymentTaxValue = paymentTaxRaw.toDouble();
    }
    final hasPaymentTotal = raw.containsKey('paymentTotal');
    final paymentTotalRaw = raw['paymentTotal'];
    double? paymentTotalValue;
    if (hasPaymentTotal && paymentTotalRaw != null) {
      if (paymentTotalRaw is! num) {
        throw FormatException('ReceiptScanningResult.paymentTotal: expected a number');
      }
      paymentTotalValue = paymentTotalRaw.toDouble();
    }
    final hasLoyaltyNumber = raw.containsKey('loyaltyNumber');
    final loyaltyNumberRaw = raw['loyaltyNumber'];
    int? loyaltyNumberValue;
    if (hasLoyaltyNumber && loyaltyNumberRaw != null) {
      if (loyaltyNumberRaw is! num) {
        throw FormatException('ReceiptScanningResult.loyaltyNumber: expected a number');
      }
      if (loyaltyNumberRaw != loyaltyNumberRaw.toInt()) {
        throw FormatException('ReceiptScanningResult.loyaltyNumber: expected an integer');
      }
      loyaltyNumberValue = loyaltyNumberRaw.toInt();
    }
    final hasLineItems = raw.containsKey('lineItems');
    final lineItemsRaw = raw['lineItems'];
    List<ReceiptScanningLineItem>? lineItemsValue;
    if (hasLineItems && lineItemsRaw != null) {
      if (lineItemsRaw is! List) {
        throw FormatException('ReceiptScanningResult.lineItems: expected a List');
      }
      lineItemsValue = lineItemsRaw.map((item) => ReceiptScanningLineItem.fromJson(item)).toList();
    } else if (hasLineItems && lineItemsRaw == null) {
      throw FormatException('ReceiptScanningResult.lineItems: null is not allowed');
    }
    return ReceiptScanningResult(
      storeName: storeNameValue,
      storeCity: storeCityValue,
      storeAddress: storeAddressValue,
      date: dateValue,
      time: timeValue,
      paymentPreTaxTotal: paymentPreTaxTotalValue,
      paymentTax: paymentTaxValue,
      paymentTotal: paymentTotalValue,
      loyaltyNumber: loyaltyNumberValue,
      lineItems: lineItemsValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (storeName != null) {
      map['storeName'] = storeName;
    }
    if (storeCity != null) {
      map['storeCity'] = storeCity;
    }
    if (storeAddress != null) {
      map['storeAddress'] = storeAddress;
    }
    if (date != null) {
      map['date'] = date;
    }
    if (time != null) {
      map['time'] = time;
    }
    if (paymentPreTaxTotal != null) {
      map['paymentPreTaxTotal'] = paymentPreTaxTotal;
    }
    if (paymentTax != null) {
      map['paymentTax'] = paymentTax;
    }
    if (paymentTotal != null) {
      map['paymentTotal'] = paymentTotal;
    }
    if (loyaltyNumber != null) {
      map['loyaltyNumber'] = loyaltyNumber;
    }
    if (lineItems != null) {
      map['lineItems'] = lineItems!.map((item) => item.toJson()).toList();
    }
    return map;
  }
}

/// Typed builder for the `ReceiptScanningResult` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildReceiptScanningResult({
  Object? storeName = _unset,
  Object? storeCity = _unset,
  Object? storeAddress = _unset,
  Object? date = _unset,
  Object? time = _unset,
  Object? paymentPreTaxTotal = _unset,
  Object? paymentTax = _unset,
  Object? paymentTotal = _unset,
  Object? loyaltyNumber = _unset,
  List<Object?>? lineItems,
}) {
  final map = <String, Object?>{};
  if (!identical(storeName, _unset)) {
    map['storeName'] = storeName;
  }
  if (!identical(storeCity, _unset)) {
    map['storeCity'] = storeCity;
  }
  if (!identical(storeAddress, _unset)) {
    map['storeAddress'] = storeAddress;
  }
  if (!identical(date, _unset)) {
    map['date'] = date;
  }
  if (!identical(time, _unset)) {
    map['time'] = time;
  }
  if (!identical(paymentPreTaxTotal, _unset)) {
    map['paymentPreTaxTotal'] = paymentPreTaxTotal;
  }
  if (!identical(paymentTax, _unset)) {
    map['paymentTax'] = paymentTax;
  }
  if (!identical(paymentTotal, _unset)) {
    map['paymentTotal'] = paymentTotal;
  }
  if (!identical(loyaltyNumber, _unset)) {
    map['loyaltyNumber'] = loyaltyNumber;
  }
  if (lineItems != null) {
    map['lineItems'] = lineItems;
  }
  return map;
}

/// A single purchased item identified on a scanned receipt.
class ReceiptScanningLineItem {
  final String? name;
  final double? unitPrice;
  final double? discount;
  final double? quantity;
  final double? totalPrice;

  const ReceiptScanningLineItem({
    this.name,
    this.unitPrice,
    this.discount,
    this.quantity,
    this.totalPrice,
  });

  factory ReceiptScanningLineItem.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('ReceiptScanningLineItem: expected a Map');
    }
    const allowedKeys = <String>{
      'name',
      'unitPrice',
      'discount',
      'quantity',
      'totalPrice',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("ReceiptScanningLineItem: unknown property '$key'");
      }
    }
    final hasName = raw.containsKey('name');
    final nameRaw = raw['name'];
    String? nameValue;
    if (hasName && nameRaw != null) {
      if (nameRaw is! String) {
        throw FormatException('ReceiptScanningLineItem.name: expected a String');
      }
      nameValue = nameRaw;
    } else if (hasName && nameRaw == null) {
      throw FormatException('ReceiptScanningLineItem.name: null is not allowed');
    }
    final hasUnitPrice = raw.containsKey('unitPrice');
    final unitPriceRaw = raw['unitPrice'];
    double? unitPriceValue;
    if (hasUnitPrice && unitPriceRaw != null) {
      if (unitPriceRaw is! num) {
        throw FormatException('ReceiptScanningLineItem.unitPrice: expected a number');
      }
      unitPriceValue = unitPriceRaw.toDouble();
    }
    final hasDiscount = raw.containsKey('discount');
    final discountRaw = raw['discount'];
    double? discountValue;
    if (hasDiscount && discountRaw != null) {
      if (discountRaw is! num) {
        throw FormatException('ReceiptScanningLineItem.discount: expected a number');
      }
      discountValue = discountRaw.toDouble();
    }
    final hasQuantity = raw.containsKey('quantity');
    final quantityRaw = raw['quantity'];
    double? quantityValue;
    if (hasQuantity && quantityRaw != null) {
      if (quantityRaw is! num) {
        throw FormatException('ReceiptScanningLineItem.quantity: expected a number');
      }
      quantityValue = quantityRaw.toDouble();
    } else if (hasQuantity && quantityRaw == null) {
      throw FormatException('ReceiptScanningLineItem.quantity: null is not allowed');
    }
    final hasTotalPrice = raw.containsKey('totalPrice');
    final totalPriceRaw = raw['totalPrice'];
    double? totalPriceValue;
    if (hasTotalPrice && totalPriceRaw != null) {
      if (totalPriceRaw is! num) {
        throw FormatException('ReceiptScanningLineItem.totalPrice: expected a number');
      }
      totalPriceValue = totalPriceRaw.toDouble();
    }
    return ReceiptScanningLineItem(
      name: nameValue,
      unitPrice: unitPriceValue,
      discount: discountValue,
      quantity: quantityValue,
      totalPrice: totalPriceValue,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    if (name != null) {
      map['name'] = name;
    }
    if (unitPrice != null) {
      map['unitPrice'] = unitPrice;
    }
    if (discount != null) {
      map['discount'] = discount;
    }
    if (quantity != null) {
      map['quantity'] = quantity;
    }
    if (totalPrice != null) {
      map['totalPrice'] = totalPrice;
    }
    return map;
  }
}

/// Typed builder for the `ReceiptScanningLineItem` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildReceiptScanningLineItem({
  String? name,
  Object? unitPrice = _unset,
  Object? discount = _unset,
  double? quantity,
  Object? totalPrice = _unset,
}) {
  final map = <String, Object?>{};
  if (name != null) {
    map['name'] = name;
  }
  if (!identical(unitPrice, _unset)) {
    map['unitPrice'] = unitPrice;
  }
  if (!identical(discount, _unset)) {
    map['discount'] = discount;
  }
  if (quantity != null) {
    map['quantity'] = quantity;
  }
  if (!identical(totalPrice, _unset)) {
    map['totalPrice'] = totalPrice;
  }
  return map;
}

/// Notifies the listener that the adaptive recognition overlay failed to recognize a result.
class LabelCaptureAdaptiveRecognitionListenerFailure {
  final String event;

  const LabelCaptureAdaptiveRecognitionListenerFailure({
    required this.event,
  });

  factory LabelCaptureAdaptiveRecognitionListenerFailure.fromJson(Object? raw) {
    if (raw is! Map) {
      throw FormatException('LabelCaptureAdaptiveRecognitionListenerFailure: expected a Map');
    }
    const allowedKeys = <String>{
      'event',
    };
    for (final key in raw.keys) {
      if (!allowedKeys.contains(key)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionListenerFailure: unknown property '$key'");
      }
    }
    final hasEvent = raw.containsKey('event');
    if (!hasEvent) {
      throw FormatException("LabelCaptureAdaptiveRecognitionListenerFailure.event: missing required property");
    }
    final eventRaw = raw['event'];
    String? eventValue;
    if (hasEvent && eventRaw != null) {
      if (eventRaw is! String ||
          !const <String>['LabelCaptureAdaptiveRecognitionListener.failure'].contains(eventRaw)) {
        throw FormatException("LabelCaptureAdaptiveRecognitionListenerFailure.event: unknown enum value '$eventRaw'");
      }
      eventValue = eventRaw;
    } else if (hasEvent && eventRaw == null) {
      throw FormatException('LabelCaptureAdaptiveRecognitionListenerFailure.event: null is not allowed');
    }
    return LabelCaptureAdaptiveRecognitionListenerFailure(
      event: eventValue!,
    );
  }

  Map<String, Object?> toJson() {
    final map = <String, Object?>{};
    map['event'] = event;
    return map;
  }
}

/// Typed builder for the `LabelCaptureAdaptiveRecognitionListenerFailure` wire payload. Validation-free;
/// see "THE BUILDER CONTRACT" in this file's header for the emit rule and
/// why optional+nullable parameters are `Object?` with an `_unset` default.
Map<String, Object?> buildLabelCaptureAdaptiveRecognitionListenerFailure({
  required String event,
}) {
  final map = <String, Object?>{};
  map['event'] = event;
  return map;
}

/// Typed event dispatch for `LabelCaptureListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseLabelCaptureListenerEvent` in schemaTypes.ts.
dynamic parseLabelCaptureListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'didUpdateSession':
      return LabelCaptureListenerDidUpdateSession.fromJson(raw);
    default:
      throw ArgumentError("LabelCaptureListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `LabelCaptureBasicOverlayListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseLabelCaptureBasicOverlayListenerEvent` in schemaTypes.ts.
dynamic parseLabelCaptureBasicOverlayListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'didTapLabel':
      return LabelCaptureBasicOverlayListenerDidTapLabel.fromJson(raw);
    case 'brushForLabel':
      return LabelCaptureBasicOverlayListenerBrushForLabel.fromJson(raw);
    case 'brushForFieldOfLabel':
      return LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.fromJson(raw);
    default:
      throw ArgumentError("LabelCaptureBasicOverlayListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `LabelCaptureAdvancedOverlayListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseLabelCaptureAdvancedOverlayListenerEvent` in schemaTypes.ts.
dynamic parseLabelCaptureAdvancedOverlayListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'viewForLabel':
      return LabelCaptureAdvancedOverlayListenerViewForLabel.fromJson(raw);
    case 'viewForFieldOfLabel':
      return LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.fromJson(raw);
    case 'anchorForLabel':
      return LabelCaptureAdvancedOverlayListenerAnchorForLabel.fromJson(raw);
    case 'anchorForFieldOfLabel':
      return LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.fromJson(raw);
    case 'offsetForLabel':
      return LabelCaptureAdvancedOverlayListenerOffsetForLabel.fromJson(raw);
    case 'offsetForFieldOfLabel':
      return LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.fromJson(raw);
    default:
      throw ArgumentError("LabelCaptureAdvancedOverlayListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `LabelCaptureValidationFlowListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseLabelCaptureValidationFlowListenerEvent` in schemaTypes.ts.
dynamic parseLabelCaptureValidationFlowListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'didCaptureLabelWithFields':
      return LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.fromJson(raw);
    case 'didSubmitManualInputForField':
      return LabelCaptureValidationFlowListenerDidSubmitManualInputForField.fromJson(raw);
    case 'didUpdateValidationFlowResult':
      return LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.fromJson(raw);
    default:
      throw ArgumentError("LabelCaptureValidationFlowListener: unknown event '$eventName'");
  }
}

/// Typed event dispatch for `LabelCaptureAdaptiveRecognitionListener`: parses the raw payload
/// for [eventName] into its matching generated type. Throws
/// [ArgumentError] for an event name this listener doesn't declare, and
/// [FormatException] (via the target type's `fromJson`) on a payload shape
/// mismatch -- mirrors `parseLabelCaptureAdaptiveRecognitionListenerEvent` in schemaTypes.ts.
dynamic parseLabelCaptureAdaptiveRecognitionListenerEvent(String eventName, Object? raw) {
  switch (eventName) {
    case 'recognized':
      return LabelCaptureAdaptiveRecognitionListenerRecognized.fromJson(raw);
    case 'failure':
      return LabelCaptureAdaptiveRecognitionListenerFailure.fromJson(raw);
    default:
      throw ArgumentError("LabelCaptureAdaptiveRecognitionListener: unknown event '$eventName'");
  }
}
