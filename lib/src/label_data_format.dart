/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';

class LabelDateFormat implements Serializable {
  final LabelDateComponentFormat _componentFormat;
  final bool _acceptPartialDates;

  LabelDateFormat(this._componentFormat, this._acceptPartialDates);

  LabelDateComponentFormat get componentFormat => _componentFormat;

  bool get acceptPartialDates => _acceptPartialDates;

  @override
  Map<String, dynamic> toMap() {
    return {
      'componentFormat': componentFormat.toString(),
      'acceptPartialDates': acceptPartialDates,
    };
  }
}
