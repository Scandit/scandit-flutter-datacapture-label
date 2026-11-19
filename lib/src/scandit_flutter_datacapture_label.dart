/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

// ignore: avoid_classes_with_only_static_members
class ScanditFlutterDataCaptureLabel {
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureBarcode.initialize();
    await LabelCaptureDefaults.initializeDefaults();
  }
}
