/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/map_helper.dart';
import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart'
    show
        LabelCaptureBasicOverlayListenerBrushForFieldOfLabel,
        LabelCaptureBasicOverlayListenerBrushForLabel,
        LabelCaptureBasicOverlayListenerDidTapLabel;
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_defaults.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import '../tolerant_payload_parser.dart';

/// [LabelCaptureBasicOverlayListener] can be implemented to customize the visual appearance of highlighted labels and their fields in the basic overlay. When label capture identifies a new field, or when the [LabelField.state] property changes, brushForFieldOfLabel() is called to determine the [Brush] of the field.
///
/// Added in version 7.2.0
abstract class LabelCaptureBasicOverlayListener {
  /// Called to determine the visual style for a specific field when its state changes. This method allows you to provide custom styling based on field content, validation status, or other contextual information.
  ///
  /// The method is called when a field is first detected, when its state changes (e.g., from predicted to captured), or when field data is updated. Return *null* to use the default brush for the field’s current state. The returned brush can be overridden by explicit calls to LabelCaptureBasicOverlay.setBrushForFieldOfLabel().
  ///
  /// Added in version 7.2.0
  Future<Brush?> brushForFieldOfLabel(LabelCaptureBasicOverlay overlay, LabelField field, CapturedLabel label);
  /// Called to determine the visual style for a label when any of its fields change state or data. This method allows you to provide custom styling for entire labels based on their completion status, validation results, or other contextual information.
  ///
  /// The method is called when any field within the label changes state or when field data is updated. Return *null* to use the default label brush. The returned brush can be overridden by explicit calls to [LabelCaptureBasicOverlay.setBrushForLabel].
  ///
  /// Added in version 7.2.0
  Future<Brush?> brushForLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label);
  /// Called when a user taps on a captured label in the overlay. This method allows you to handle user interactions with labels, such as showing detailed information, triggering validation flows, or providing additional options.
  ///
  /// This method is called from the main thread, making it safe to perform UI operations directly.
  ///
  /// Added in version 7.2.0
  void didTapLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label);
}

/// Overlay for label capture that provides visual feedback and customization capabilities for the scanning process. This overlay displays captured labels and their fields on top of the camera preview, offering extensive customization options through listener interfaces.
///
/// Key visualization features:
///
/// - **Label highlighting** - Configurable visual feedback for detected labels
/// - **Field state indication** - Different visual styles for predicted vs. captured fields
/// - **Custom brush configuration** - Fully customizable appearance for labels and fields
/// - **Listener-based customization** - Programmatic control over field appearances
///
/// The overlay distinguishes between different field states:
///
/// - **Predicted fields** - Fields that have been detected but not yet captured
/// - **Captured fields** - Fields that have been successfully scanned and validated
///
/// Advanced customization is available through [LabelCaptureBasicOverlayListener], allowing dynamic styling based on field content, validation status, or other contextual information.,
///
/// Fields are highlighted using a default brush ([LabelCaptureBasicOverlay.capturedFieldBrush], [LabelCaptureBasicOverlay.predictedFieldBrush]), a brush set through a user-defined [LabelCaptureBasicOverlayListener] or calls to setBrushForFieldOfLabel().
///
/// Added in version 7.2.0
class LabelCaptureBasicOverlay extends DataCaptureOverlay with ViewAttachable, _LabelCaptureBasicOverlayViewAttachable {
  /// The default brush applied to predicted fields. This is the brush used if [LabelCaptureBasicOverlayListener] is not set.
  ///
  /// Added in version 7.2.0
  static Brush get defaultPredictedFieldBrush =>
      LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultPredictedFieldBrush;

  /// The default brush applied to captured fields. This is the brush used if [LabelCaptureBasicOverlayListener] is not set.
  ///
  /// Added in version 7.2.0
  static Brush get defaultCapturedFieldBrush =>
      LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultCapturedFieldBrush;

  /// The default brush used for drawing labels. This brush is used when no [LabelCaptureBasicOverlay.listener] is set, or the [LabelCaptureBasicOverlayListener.brushForLabel] returns a *null* brush.
  ///
  /// Added in version 7.2.0
  static Brush get defaultLabelBrush => LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultLabelBrush;

  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureBasicOverlay._(this._mode) : super('labelCaptureBasic');

  /// Constructs a new overlay to visualize the process of label capture. The overlay needs to be added through a call to [DataCaptureView.addOverlay].
  ///
  /// Added in version 7.6.0
  LabelCaptureBasicOverlay(LabelCapture labelCapture) : this._(labelCapture);

  /// The data capture view that this overlay is attached to. This property allows you to access the parent view for overlay management or to perform view-related operations.
  ///
  /// Returns *null* when the overlay is not currently attached to any view.
  ///
  /// Added in version 7.2.0
  @override
  DataCaptureView? get view => attachedView;

  /// The data capture view that this overlay is attached to. This property allows you to access the parent view for overlay management or to perform view-related operations.
  ///
  /// Returns *null* when the overlay is not currently attached to any view.
  ///
  /// Added in version 7.2.0
  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      attachedView?.unregisterAttachable(this);
      return;
    }

    newValue.registerAttachable(this);
  }

  Brush? _predictedFieldBrush = LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultPredictedFieldBrush;
  /// The brush applied to predicted fields if no [LabelCaptureBasicOverlayListener] is set.
  ///
  /// Added in version 7.2.0
  Brush? get predictedFieldBrush => _predictedFieldBrush;
  /// The brush applied to predicted fields if no [LabelCaptureBasicOverlayListener] is set.
  ///
  /// Added in version 7.2.0
  set predictedFieldBrush(Brush? newBrush) {
    _predictedFieldBrush = newBrush;
    _controller?.updateBasicOverlay();
  }

  Brush? _capturedFieldBrush = LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultCapturedFieldBrush;
  /// Added in version 7.2.0
  Brush? get capturedFieldBrush => _capturedFieldBrush;
  /// Added in version 7.2.0
  set capturedFieldBrush(Brush? newBrush) {
    _capturedFieldBrush = newBrush;
    _controller?.updateBasicOverlay();
  }

  Brush? _labelBrush = LabelCaptureDefaults.labelCaptureBasicOverlayDefaults.defaultLabelBrush;
  /// Added in version 7.2.0
  Brush? get labelBrush => _labelBrush;
  /// Added in version 7.2.0
  set labelBrush(Brush? newBrush) {
    _labelBrush = newBrush;
    _controller?.updateBasicOverlay();
  }

  bool _shouldShowScanAreaGuides = false;
  /// Controls whether scan area guides are displayed over the camera preview. These guides help visualize the active scanning regions during development and debugging.
  ///
  /// This feature is intended for development purposes only and should not be enabled in production applications. By default this property is *false*.
  ///
  /// Added in version 7.2.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;
  /// Controls whether scan area guides are displayed over the camera preview. These guides help visualize the active scanning regions during development and debugging.
  ///
  /// This feature is intended for development purposes only and should not be enabled in production applications. By default this property is *false*.
  ///
  /// Added in version 7.2.0
  set shouldShowScanAreaGuides(bool shouldShow) {
    _shouldShowScanAreaGuides = shouldShow;
    _controller?.updateBasicOverlay();
  }

  Viewfinder? _viewfinder;
  /// The viewfinder used to guide users during the scanning process. The viewfinder provides visual cues about the optimal scanning area and helps users position labels correctly.
  ///
  /// By default, no viewfinder is displayed. Set this to an instance of [Viewfinder] (such as [RectangularViewfinder]) to provide scanning guidance to users.
  ///
  /// Added in version 7.2.0
  Viewfinder? get viewfinder => _viewfinder;
  /// The viewfinder used to guide users during the scanning process. The viewfinder provides visual cues about the optimal scanning area and helps users position labels correctly.
  ///
  /// By default, no viewfinder is displayed. Set this to an instance of [Viewfinder] (such as [RectangularViewfinder]) to provide scanning guidance to users.
  ///
  /// Added in version 7.2.0
  set viewfinder(Viewfinder? newViewfinder) {
    _viewfinder = newViewfinder;
    _controller?.updateBasicOverlay();
  }

  /// Sets a custom brush to visually highlight a specific field within a captured label. This allows for dynamic styling based on field content, validation status, or other contextual information.
  ///
  /// Use this method to provide visual feedback for specific fields, such as highlighting errors, successful captures, or fields requiring attention.
  ///
  /// This method is thread-safe; it can be called from any thread. When [LabelCaptureBasicOverlay.listener] is set to a non-*null* instance, the listener continues to be asked for the brush to use for this field whenever the state changes, thereby replacing any brushes set by calling setBrushForFieldOfLabel().
  ///
  /// Added in version 7.2.0
  Future<void> setBrushForFieldOfLabel(Brush? brush, LabelField field, CapturedLabel label) {
    final fieldId = '${label.trackingId}§${field.name}';
    return _controller?.setBrushForFieldOfLabel(brush, fieldId) ?? Future.value();
  }

  /// Sets a custom brush to visually highlight a specific captured label. This allows for dynamic styling of entire labels based on their completion status, validation results, or other contextual information.
  ///
  /// Use this method to provide visual feedback for labels, such as highlighting complete vs. incomplete labels, or marking labels that require validation. This method is thread-safe; it can be called from any thread.
  ///
  /// When [LabelCaptureBasicOverlay.listener] is set to a non-*null* instance, the listener continues to be asked for the brush to use for this label whenever the state of one its fields changes, thereby replacing any brushes set by calling [LabelCaptureBasicOverlay.setBrushForLabel].
  ///
  /// Added in version 7.2.0
  Future<void> setBrushForLabel(Brush? brush, CapturedLabel label) {
    return _controller?.setBrushForLabel(brush, label) ?? Future.value();
  }

  LabelCaptureBasicOverlayListener? _listener;

  /// Added in version 7.2.0
  LabelCaptureBasicOverlayListener? get listener => _listener;

  /// Added in version 7.2.0
  set listener(LabelCaptureBasicOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  @override
  Map<String, dynamic> toMap() {
    final json = super.toMap();
    json['viewfinder'] = viewfinder?.toMap();
    json['fieldBrushes'] = {'captured': capturedFieldBrush?.toMap(), 'predicted': predictedFieldBrush?.toMap()};
    json['labelBrush'] = labelBrush?.toMap();
    json['shouldShowScanAreaGuides'] = shouldShowScanAreaGuides;
    json['hasListener'] = _listener != null;
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

/// Holds the [ViewAttachable] lifecycle for [LabelCaptureBasicOverlay].
///
/// Kept in a (private) mixin so the docs signature collector — which only inspects class
/// declarations — does not treat these callbacks as public API. (Mirrors `PrivateZoomGesture`.)
///
/// [SDC-30872] Register the listener in [onViewInitialized] (once the viewId is valid) and
/// re-register on view recreation, instead of eagerly at view-set time when the id may still
/// be -1 — which on iOS silently leaves the overlay delegate unset.
mixin _LabelCaptureBasicOverlayViewAttachable on ViewAttachable {
  _LabelCaptureBasicOverlayController? _controller;

  @override
  void onAttachToView(DataCaptureView view) {
    super.onAttachToView(view);
    _controller ??= _LabelCaptureBasicOverlayController(this as LabelCaptureBasicOverlay);
  }

  @override
  void onViewInitialized(int viewId) {
    if ((this as LabelCaptureBasicOverlay)._listener != null) {
      _controller?.subscribeListener();
    }
  }

  @override
  void onDetachFromView() {
    _controller?.dispose();
    _controller = null;
    super.onDetachFromView();
  }
}

class _LabelCaptureBasicOverlayController extends BaseController {
  StreamSubscription<dynamic>? _overlaySubscription;
  late final LabelMethodHandler labelMethodHandler;

  final LabelCaptureBasicOverlay overlay;

  bool _isRegistered = false;

  _LabelCaptureBasicOverlayController(this.overlay) : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
  }

  void subscribeListener() {
    if (_isRegistered) return;
    _isRegistered = true;
    labelMethodHandler
        .addLabelCaptureBasicOverlayListener(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void unsubscribeListener() {
    if (!_isRegistered) return;
    _isRegistered = false;
    _overlaySubscription?.cancel();
    _overlaySubscription = null;

    labelMethodHandler
        .removeLabelCaptureBasicOverlayListener(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => null, onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.asFlutterEvents().listen((event) async {
      if (overlay._listener == null) return;

      if (event.isEvent('LabelCaptureBasicOverlayListener.brushForLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureBasicOverlayListenerBrushForLabel>(
          event.payload,
          (raw) => LabelCaptureBasicOverlayListenerBrushForLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `label` is required (fed straight into jsonDecode below); a missing/invalid
            // value can't be reconstructed, so decline instead of fabricating ''.
            if (map['label'] is! String) return null;
            return LabelCaptureBasicOverlayListenerBrushForLabel(
              label: map['label'] as String,
              event: 'LabelCaptureBasicOverlayListener.brushForLabel',
            );
          },
          'brushForLabel',
          'LabelCaptureBasicOverlay',
        );
        if (payload == null) return;
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        var brush = await overlay._listener?.brushForLabel(overlay, capturedLabel);
        if (brush != null) {
          await labelMethodHandler.setLabelCaptureBasicOverlayBrushForLabel(
            dataCaptureViewId: overlay._dataCaptureViewId,
            brushJson: jsonEncode(brush.toMap()),
            trackingId: capturedLabel.trackingId,
          );
        }
      } else if (event.isEvent('LabelCaptureBasicOverlayListener.brushForFieldOfLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureBasicOverlayListenerBrushForFieldOfLabel>(
          event.payload,
          (raw) => LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `field` and `label` are both required (fed into jsonDecode below); decline
            // rather than fabricating '' for either.
            if (map['field'] is! String || map['label'] is! String) return null;
            return LabelCaptureBasicOverlayListenerBrushForFieldOfLabel(
              field: map['field'] as String,
              label: map['label'] as String,
              event: 'LabelCaptureBasicOverlayListener.brushForFieldOfLabel',
            );
          },
          'brushForFieldOfLabel',
          'LabelCaptureBasicOverlay',
        );
        if (payload == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(payload.field));
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        var brush = await overlay._listener?.brushForFieldOfLabel(overlay, labelField, capturedLabel);
        if (brush != null) {
          await labelMethodHandler.setLabelCaptureBasicOverlayBrushForFieldOfLabel(
            dataCaptureViewId: overlay._dataCaptureViewId,
            brushJson: jsonEncode(brush.toMap()),
            fieldName: labelField.name,
            trackingId: capturedLabel.trackingId,
          );
        }
      } else if (event.isEvent('LabelCaptureBasicOverlayListener.didTapLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureBasicOverlayListenerDidTapLabel>(
          event.payload,
          (raw) => LabelCaptureBasicOverlayListenerDidTapLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `label` is required (fed into jsonDecode below); decline rather than fabricate ''.
            if (map['label'] is! String) return null;
            return LabelCaptureBasicOverlayListenerDidTapLabel(
              label: map['label'] as String,
              event: 'LabelCaptureBasicOverlayListener.didTapLabel',
            );
          },
          'didTapLabel',
          'LabelCaptureBasicOverlay',
        );
        if (payload == null) return;
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        overlay._listener?.didTapLabel(overlay, capturedLabel);
      }
    });
  }

  Future<void> updateBasicOverlay() {
    return labelMethodHandler
        .updateLabelCaptureBasicOverlay(
          dataCaptureViewId: overlay._dataCaptureViewId,
          basicOverlayJson: jsonEncode(overlay.toMap()),
        )
        .then((value) => null, onError: onError);
  }

  Future<void> setBrushForFieldOfLabel(Brush? brush, String fieldId) {
    // Parse fieldId: format is "trackingId§fieldName"
    final parts = fieldId.split('§');
    if (parts.length != 2) {
      return Future.error('Invalid fieldId format: $fieldId');
    }
    final trackingId = int.parse(parts[0]);
    final fieldName = parts[1];
    return labelMethodHandler.setLabelCaptureBasicOverlayBrushForFieldOfLabel(
      dataCaptureViewId: overlay._dataCaptureViewId,
      brushJson: jsonEncodeOrNull(brush),
      fieldName: fieldName,
      trackingId: trackingId,
    );
  }

  Future<void> setBrushForLabel(Brush? brush, CapturedLabel label) {
    return labelMethodHandler.setLabelCaptureBasicOverlayBrushForLabel(
      dataCaptureViewId: overlay._dataCaptureViewId,
      brushJson: jsonEncodeOrNull(brush),
      trackingId: label.trackingId,
    );
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
