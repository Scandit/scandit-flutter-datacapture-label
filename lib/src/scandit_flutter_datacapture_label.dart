/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';

import 'internal/generated/label_log_metadata.dart';

// ignore: avoid_classes_with_only_static_members
/// The container class of the module. Includes only one method, which initializes the label, core and the barcode plugins.
///
/// Added in version 7.2.0
class ScanditFlutterDataCaptureLabel {
  /// Initializes the label, core and the barcode plugins. You need to invoke this method before accessing any of the Scandit Data Capture SDK functionality.
  ///
  /// Added in version 6.7.0
  static Future<void> initialize() async {
    await ScanditFlutterDataCaptureBarcode.initialize();
    registerLabelLogMetadata();
    await LabelCaptureDefaults.initializeDefaults();
  }
}
