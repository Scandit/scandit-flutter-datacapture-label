/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'label_capture_advanced_overlay_container.dart';

abstract class LabelCaptureAdvancedOverlayWidget extends StatefulWidget {
  final double? _width;
  final double? _height;

  const LabelCaptureAdvancedOverlayWidget({
    super.key,
    double? width,
    double? height,
  })  : _width = width,
        _height = height;

  double? get width => _width;

  double? get height => _height;

  @override
  LabelCaptureAdvancedOverlayWidgetState createState();
}

abstract class LabelCaptureAdvancedOverlayWidgetState<T extends LabelCaptureAdvancedOverlayWidget> extends State<T> {
  @override
  LabelCaptureAdvancedOverlayContainer build(BuildContext context);
}
