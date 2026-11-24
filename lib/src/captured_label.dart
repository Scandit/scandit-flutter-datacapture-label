/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';

/// A captured label tracked over multiple frames. This class holds the list of label fields as well as the predicted boundary of the label. Each instance of a found label has a unique tracking Id which remains constant over multiple frames.
///
/// Captured labels represent the result of successfully identifying and tracking a label based on a [LabelDefinition]. The label becomes “complete” when all required fields have been captured, though optional fields may still be added in subsequent frames.
///
/// The tracking system allows labels to be followed across multiple camera frames, enabling progressive capture where individual fields are recognized over time until the complete label structure is assembled.
///
/// Added in version 7.2.0
class CapturedLabel implements Serializable {
  final List<LabelField> _fields;
  final String _name;
  final bool _isComplete;
  final Quadrilateral _predictedBounds;
  final Duration _deltaTimeToPrediction;
  final int _trackingId;
  final int? _frameSequenceId;

  CapturedLabel._(
    this._fields,
    this._name,
    this._isComplete,
    this._predictedBounds,
    this._deltaTimeToPrediction,
    this._trackingId,
    this._frameSequenceId,
  );

  /// List of fields in the label. For each field defined in the corresponding [LabelDefinition], exactly one captured field is returned. The fields contain the actual captured data (barcode values, text content, etc.).
  ///
  /// Added in version 7.2.0
  List<LabelField> get fields => _fields;

  /// The name of this label, e.g. *label-a*. This property can be used in case multiple different label definitions are used at the same time.
  ///
  /// Added in version 7.2.0
  String get name => _name;

  /// Whether the label has been completely scanned. Returns true as soon as all the required fields defined in the [LabelDefinition] are present and successfully captured. Optional fields do not need to be present for this property to be true.
  ///
  /// This property is useful for determining when to stop scanning and process the captured label data.
  ///
  /// Added in version 7.2.0
  bool get isComplete => _isComplete;

  /// The predicted label bounds in image coordinates. These coordinates represent the estimated outline of the entire label area and will need to be converted to view coordinates before they can be visualized in UI overlays.
  ///
  /// The prediction takes into account the label’s movement across frames and provides a more stable bounding box for display purposes.
  ///
  /// Added in version 7.2.0
  Quadrilateral get predictedBounds => _predictedBounds;

  /// The delta time used for predicting the label bounds ([CapturedLabel.predictedBounds]) as well as the field locations (available as [LabelField.predictedLocation]).
  ///
  /// Added in version 7.2.0
  Duration get deltaTimeToPrediction => _deltaTimeToPrediction;

  /// The tracking identifier for this label.
  ///
  /// Added in version 7.2.0
  int get trackingId => _trackingId;

  factory CapturedLabel.fromJSON(Map<String, dynamic> json, int? frameSequenceId) {
    return CapturedLabel._(
      (json['fields'] as List).map((field) => LabelField.fromJSON(field)).toList(),
      json['name'],
      json['isComplete'],
      Quadrilateral.fromJSON(json['predictedBounds']),
      Duration(milliseconds: (json['deltaTimeToPrediction'] as num).toInt()),
      json['trackingId'],
      frameSequenceId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'fields': fields.map((field) => field.toMap()).toList(),
      'name': name,
      'isComplete': isComplete,
      'predictedBounds': predictedBounds.toMap(),
      'deltaTimeToPrediction': deltaTimeToPrediction.inMilliseconds,
      'trackingId': trackingId,
      'frameSequenceId': _frameSequenceId,
    };
  }
}
