/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'label_capture_advanced_overlay_container.dart';

/// The widget you have to extend to display a custom widget for a [CapturedLabel] through a [LabelCaptureAdvancedOverlay].
///
/// Added in version 7.2.0
abstract class LabelCaptureAdvancedOverlayWidget extends StatefulWidget {
  final double? _width;
  final double? _height;

  const LabelCaptureAdvancedOverlayWidget({
    super.key,
    double? width,
    double? height,
  })  : _width = width,
        _height = height;

  /// The optional width of the overlay widget.
  ///
  /// Added in version 7.2.0
  double? get width => _width;

  /// The optional height of the overlay widget.
  ///
  /// Added in version 7.2.0
  double? get height => _height;

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 7.2.0
  @override
  LabelCaptureAdvancedOverlayWidgetState createState();
}

/// An interface that represents the state for a [LabelCaptureAdvancedOverlayWidget].
///
/// Added in version 7.2.0
abstract class LabelCaptureAdvancedOverlayWidgetState<T extends LabelCaptureAdvancedOverlayWidget> extends State<T> {
  /// Builds the widget’s visual representation.
  ///
  /// Added in version 7.2.0
  @override
  LabelCaptureAdvancedOverlayContainer build(BuildContext context);
}
