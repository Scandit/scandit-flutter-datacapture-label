/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';

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

  List<LabelField> get fields => _fields;

  String get name => _name;

  bool get isComplete => _isComplete;

  Quadrilateral get predictedBounds => _predictedBounds;

  Duration get deltaTimeToPrediction => _deltaTimeToPrediction;

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
