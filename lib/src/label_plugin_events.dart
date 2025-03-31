/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';

class LabelPluginEvents {
  static Stream labelEventStream = _getLabelEventStream();

  static Stream _getLabelEventStream() {
    return const EventChannel('com.scandit.datacapture.label/event_channel').receiveBroadcastStream();
  }
}
