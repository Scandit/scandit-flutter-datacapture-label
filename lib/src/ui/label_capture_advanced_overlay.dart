/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart'
    show
        LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel,
        LabelCaptureAdvancedOverlayListenerAnchorForLabel,
        LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel,
        LabelCaptureAdvancedOverlayListenerOffsetForLabel,
        LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel,
        LabelCaptureAdvancedOverlayListenerViewForLabel;
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/ui/label_capture_advanced_overlay_widget.dart';
import '../tolerant_payload_parser.dart';

/// The listener interface for configuring advanced overlays in label capture. This interface allows you to provide custom views, anchors, and offsets for captured labels and their individual fields, enabling rich AR-style overlays.
///
/// Added in version 7.2.0
abstract class LabelCaptureAdvancedOverlayListener {
  /// View to be drawn corresponding to the given [CapturedLabel]. This method will be called before [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabel] and [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabel]. Called from the main thread. Beware that this view can be overridden with LabelCaptureAdvancedOverlay.setWidgetForCapturedLabel() method. This method will only be called for new tracked labels that do not have a view yet, e.g. a view set by a call to LabelCaptureAdvancedOverlay.setWidgetForCapturedLabel().
  ///
  /// Added in version 7.2.0
  Future<LabelCaptureAdvancedOverlayWidget?> widgetForCapturedLabel(
    LabelCaptureAdvancedOverlay overlay,
    CapturedLabel capturedLabel,
  );
  /// Anchor point that should be used for the view corresponding to the given [CapturedLabel]. This method will be called after widgetForCapturedLabel() and before [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabel]. Called from the main thread. Beware that this anchor can be overridden with [LabelCaptureAdvancedOverlay.setAnchorForCapturedLabel] method. This method will only be called for new tracked labels that do not have an anchor yet, e.g. an anchor set by a call to [LabelCaptureAdvancedOverlay.setAnchorForCapturedLabel].
  ///
  /// Added in version 7.2.0
  Future<Anchor> anchorForCapturedLabel(LabelCaptureAdvancedOverlay overlay, CapturedLabel capturedLabel);
  /// Offset to be set to the view corresponding to the given [CapturedLabel]. The offset is relative to the anchor point of the tracked label. This method will be called after widgetForCapturedLabel() and [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabel]. Called from the main thread. Beware that this offset can be overridden with [LabelCaptureAdvancedOverlay.setOffsetForCapturedLabel] method. This method will only be called for new tracked labels that do not have an offset yet, e.g. an offset set by a call to [LabelCaptureAdvancedOverlay.setOffsetForCapturedLabel].
  ///
  /// Added in version 7.2.0
  Future<PointWithUnit> offsetForCapturedLabel(LabelCaptureAdvancedOverlay overlay, CapturedLabel capturedLabel);
  /// View to be drawn corresponding to the given [LabelField]. This method will be called before [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField] and [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField]. Called from the main thread. Beware that this view can be overridden with `SetViewForCapturedLabelField` method. This method will only be called for new tracked fields that do not have a view yet, e.g. a view set by a call to `SetViewForCapturedLabelField`.
  ///
  /// Added in version 7.2.0
  Future<LabelCaptureAdvancedOverlayWidget?> widgetForCapturedLabelField(
    LabelCaptureAdvancedOverlay overlay,
    LabelField labelField,
  );
  /// Anchor point that should be used for the view corresponding to the given [LabelField]. This method will be called after widgetForCapturedLabelField() and before [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField]. Called from the main thread. Beware that this anchor can be overridden with `SetAnchorForCapturedLabelField` method. This method will only be called for new tracked fields that do not have an anchor yet, e.g. an anchor set by a call to `SetAnchorForCapturedLabelField`.
  ///
  /// Added in version 7.2.0
  Future<Anchor> anchorForCapturedLabelField(LabelCaptureAdvancedOverlay overlay, LabelField labelField);
  /// Offset to be set to the view corresponding to the given [LabelField]. The offset is relative to the anchor point of the tracked field. This method will be called after widgetForCapturedLabelField() and [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField]. Called from the main thread. Beware that this offset can be overridden with `SetOffsetForCapturedLabelField` method. This method will only be called for new tracked fields that do not have an offset yet, e.g. an offset set by a call to `SetOffsetForCapturedLabelField`.
  ///
  /// Added in version 7.2.0
  Future<PointWithUnit> offsetForCapturedLabelField(LabelCaptureAdvancedOverlay overlay, LabelField labelField);
}

/// An advanced overlay for [DataCaptureView] that enables rich AR-style experiences by allowing custom views to be anchored to captured labels and their individual fields (label location is only supported in some use cases at the moment).This overlay provides sophisticated augmented reality capabilities, allowing you to create dynamic AR elements that react to captured label content. The provided views maintain their relative position to labels and fields as they move in the camera preview, enabling real-time contextual information display.Advanced AR use cases include:**Dynamic warnings** - Display alerts for items near expiration based on captured dates**Contextual information** - Show additional product details or pricing information**Field-specific feedback** - Provide targeted visual feedback for individual label fields**Custom validation indicators** - Create sophisticated validation interfacesThe overlay supports both label-level and field-level view anchoring, providing fine-grained control over AR element positioning and behavior.To display the views, this overlay must be attached to a [DataCaptureView]. This can be done by passing this overlay to [DataCaptureView.addOverlay].A user of this class may configure what view is displayed for the given label and the relative position between the two by implementing [LabelCaptureAdvancedOverlayListener].
///
/// Added in version 7.2.0
class LabelCaptureAdvancedOverlay extends DataCaptureOverlay
    with ViewAttachable, _LabelCaptureAdvancedOverlayViewAttachable {
  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureAdvancedOverlay._(this._mode) : super('labelCaptureAdvanced');

  /// Constructs a new overlay to visualize the process of label capture. For the overlay to be displayed on screen, it must be added to a [DataCaptureView].
  ///
  /// Added in version 7.6.0
  LabelCaptureAdvancedOverlay(LabelCapture mode) : this._(mode);

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 7.2.0
  @override
  DataCaptureView? get view => attachedView;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
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

  LabelCaptureAdvancedOverlayListener? _listener;

  /// The listener which is called whenever a view, an anchor point and an offset must be defined for a tracked [CapturedLabel].
  ///
  /// Added in version 7.2.0
  LabelCaptureAdvancedOverlayListener? get listener => _listener;

  /// The listener which is called whenever a view, an anchor point and an offset must be defined for a tracked [CapturedLabel].
  ///
  /// Added in version 7.2.0
  set listener(LabelCaptureAdvancedOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  bool _shouldShowScanAreaGuides = false;

  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 7.2.0
  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  /// Whether to show scan area guides on top of the preview. This property is useful during development to visualize the current scan areas on screen. It is not meant to be used for production. By default this property is *false*.
  ///
  /// Added in version 7.2.0
  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  /// The method can be called to change the view drawn for the given tracked label. Setting the view to *null* will unset the view from the tracked label and will effectively remove it from the overlay. This method is thread-safe, it can be called from any thread. The view set via this method will take precedence over the one set via LabelCaptureAdvancedOverlayListener.widgetForCapturedLabel(): in case a view is set before LabelCaptureAdvancedOverlayListener.widgetForCapturedLabel() got called, no call to LabelCaptureAdvancedOverlayListener.widgetForCapturedLabel() will happen.
  ///
  /// Added in version 7.2.0
  Future<void> setWidgetForCapturedLabel(CapturedLabel capturedLabel, LabelCaptureAdvancedOverlayWidget? widget) {
    return _controller?.setWidgetForCapturedLabel(capturedLabel, widget) ?? Future.value();
  }

  /// The method can be called to change the anchor point for the view associated with the given tracked label. This method is thread-safe, it can be called from any thread. The anchor set via this method will take precedence over the one set via [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabel]: in case a view is set before [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabel] got called, no call to [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabel] will happen.
  ///
  /// Added in version 7.2.0
  Future<void> setAnchorForCapturedLabel(CapturedLabel capturedLabel, Anchor anchor) {
    return _controller?.setAnchorForCapturedLabel(capturedLabel, anchor) ?? Future.value();
  }

  /// The method can be called to change the offset for the view associated with the given tracked label. This method is thread-safe, it can be called from any thread. The offset set via this method will take precedence over the one set via [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabel]: in case a view is set before [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabel] got called, no call to [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabel] will happen. If the [MeasureUnit] of the offset is [MeasureUnit.fraction], the offset is calculated relative to view’s dimensions.
  ///
  /// Added in version 7.2.0
  Future<void> setOffsetForCapturedLabel(CapturedLabel capturedLabel, PointWithUnit offset) {
    return _controller?.setOffsetForCapturedLabel(capturedLabel, offset) ?? Future.value();
  }

  /// The method can be called to change the view drawn for the given tracked field of the captured label. Setting the view to *null* will unset the view from the tracked field of the captured label and will effectively remove it from the overlay. This method is thread-safe, it can be called from any thread. The view set via this method will take precedence over the one set via LabelCaptureAdvancedOverlayListener.widgetForCapturedLabelField(): in case a view is set before LabelCaptureAdvancedOverlayListener.widgetForCapturedLabelField() got called, no call to LabelCaptureAdvancedOverlayListener.widgetForCapturedLabelField() will happen.
  ///
  /// Added in version 7.2.0
  Future<void> setWidgetForCapturedLabelField(
    LabelField labelField,
    CapturedLabel capturedLabel,
    LabelCaptureAdvancedOverlayWidget? widget,
  ) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setWidgetForCapturedLabelField(labelFieldId, widget) ?? Future.value();
  }

  /// The method can be called to change the anchor point for the view associated with the given tracked field of the captured label. This method is thread-safe, it can be called from any thread. The anchor set via this method will take precedence over the one set via [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField]: in case a view is set before [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField] got called, no call to [LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField] will happen.
  ///
  /// Added in version 7.2.0
  Future<void> setAnchorForCapturedLabelField(LabelField labelField, CapturedLabel capturedLabel, Anchor anchor) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setAnchorForCapturedLabelField(labelFieldId, anchor) ?? Future.value();
  }

  /// The method can be called to change the offset for the view associated with the given tracked field of the captured label. This method is thread-safe, it can be called from any thread. The offset set via this method will take precedence over the one set via [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField]: in case a view is set before [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField] got called, no call to [LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField] will happen. If the [MeasureUnit] of the offset is [MeasureUnit.fraction], the offset is calculated relative to view’s dimensions.
  ///
  /// Added in version 7.2.0
  Future<void> setOffsetForCapturedLabelField(
    LabelField labelField,
    CapturedLabel capturedLabel,
    PointWithUnit offset,
  ) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setOffsetForCapturedLabelField(labelFieldId, offset) ?? Future.value();
  }

  /// Clears all the views for the currently tracked labels from this overlay. This method is thread-safe, it can be called from any thread.
  ///
  /// Added in version 7.2.0
  Future<void> clearCapturedLabelWidgets() {
    return _controller?.clearCapturedLabelWidgets() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['shouldShowScanAreaGuides'] = _shouldShowScanAreaGuides;
    json['hasListener'] = _listener != null;
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

/// Holds the [ViewAttachable] lifecycle for [LabelCaptureAdvancedOverlay].
///
/// Kept in a (private) mixin so the docs signature collector — which only inspects class
/// declarations — does not treat these callbacks as public API. (Mirrors `PrivateZoomGesture`.)
///
/// [SDC-30872] Register the listener in [onViewInitialized] (once the viewId is valid) and
/// re-register on view recreation, instead of eagerly at view-set time when the id may still
/// be -1 — which on iOS silently leaves the overlay delegate unset.
mixin _LabelCaptureAdvancedOverlayViewAttachable on ViewAttachable {
  _LabelCaptureAdvancedOverlayController? _controller;

  @override
  void onAttachToView(DataCaptureView view) {
    super.onAttachToView(view);
    _controller ??= _LabelCaptureAdvancedOverlayController(this as LabelCaptureAdvancedOverlay);
  }

  @override
  void onViewInitialized(int viewId) {
    if ((this as LabelCaptureAdvancedOverlay)._listener != null) {
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

class _LabelCaptureAdvancedOverlayController extends BaseController {
  final LabelCaptureAdvancedOverlay overlay;
  late final LabelMethodHandler labelMethodHandler;

  StreamSubscription<dynamic>? _overlaySubscription;

  final List<String> _widgetRequestsCache = [];

  bool _isRegistered = false;

  _LabelCaptureAdvancedOverlayController(this.overlay) : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
  }

  Future<void> setWidgetForCapturedLabel(CapturedLabel capturedLabel, LabelCaptureAdvancedOverlayWidget? widget) async {
    final viewBytes = await widget?.toImage;
    return labelMethodHandler
        .setViewForCapturedLabelFromBytes(
          dataCaptureViewId: overlay._dataCaptureViewId,
          trackingId: capturedLabel.trackingId,
          viewBytes: viewBytes,
        )
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(capturedLabel.trackingId.toString()));
  }

  Future<void> setWidgetForCapturedLabelField(String labelFieldId, LabelCaptureAdvancedOverlayWidget? widget) async {
    final viewBytes = await widget?.toImage;
    return labelMethodHandler
        .setViewForCapturedLabelFieldFromBytes(
          dataCaptureViewId: overlay._dataCaptureViewId,
          identifier: labelFieldId,
          viewBytes: viewBytes,
        )
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(labelFieldId));
  }

  Future<void> setAnchorForCapturedLabel(CapturedLabel capturedLabel, Anchor anchor) {
    return labelMethodHandler.setAnchorForCapturedLabel(
      dataCaptureViewId: overlay._dataCaptureViewId,
      anchorJson: anchor.toString(),
      trackingId: capturedLabel.trackingId,
    );
  }

  Future<void> setAnchorForCapturedLabelField(String labelFieldId, Anchor anchor) {
    return labelMethodHandler.setAnchorForCapturedLabelField(
      dataCaptureViewId: overlay._dataCaptureViewId,
      anchorJson: anchor.toString(),
      identifier: labelFieldId,
    );
  }

  Future<void> setOffsetForCapturedLabel(CapturedLabel capturedLabel, PointWithUnit offset) {
    return labelMethodHandler.setOffsetForCapturedLabel(
      dataCaptureViewId: overlay._dataCaptureViewId,
      offsetJson: jsonEncode(offset.toMap()),
      trackingId: capturedLabel.trackingId,
    );
  }

  Future<void> setOffsetForCapturedLabelField(String labelFieldId, PointWithUnit offset) {
    return labelMethodHandler.setOffsetForCapturedLabelField(
      dataCaptureViewId: overlay._dataCaptureViewId,
      offsetJson: jsonEncode(offset.toMap()),
      identifier: labelFieldId,
    );
  }

  Future<void> clearCapturedLabelWidgets() {
    return labelMethodHandler.clearCapturedLabelViews(dataCaptureViewId: overlay._dataCaptureViewId);
  }

  Future<void> update() {
    return labelMethodHandler
        .updateLabelCaptureAdvancedOverlay(
          dataCaptureViewId: overlay._dataCaptureViewId,
          advancedOverlayJson: jsonEncode(overlay.toMap()),
        )
        .then((value) => null, onError: onError);
  }

  void subscribeListener() {
    if (_isRegistered) return;
    _isRegistered = true;
    labelMethodHandler
        .addLabelCaptureAdvancedOverlayListener(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.asFlutterEvents().listen((event) async {
      if (overlay._listener == null) return;

      if (event.isEvent('LabelCaptureAdvancedOverlayListener.viewForLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerViewForLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerViewForLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `label` is required (fed into jsonDecode below); decline rather than fabricate ''.
            if (map['label'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerViewForLabel(
              label: map['label'] as String,
              event: 'LabelCaptureAdvancedOverlayListener.viewForLabel',
            );
          },
          'viewForLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        // this is to avoid processing multiple requests for the same
        // captured at the same time.
        if (_widgetRequestsCache.contains(capturedLabel.trackingId.toString())) return;
        _widgetRequestsCache.add(capturedLabel.trackingId.toString());

        var widget = await overlay._listener?.widgetForCapturedLabel(overlay, capturedLabel);
        if (widget == null) return;
        // ignore: unnecessary_lambdas
        setWidgetForCapturedLabel(capturedLabel, widget).catchError((error) => developer.log(error));
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.anchorForLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerAnchorForLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerAnchorForLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `label` is required (fed into jsonDecode below); decline rather than fabricate ''.
            if (map['label'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerAnchorForLabel(
              label: map['label'] as String,
              event: 'LabelCaptureAdvancedOverlayListener.anchorForLabel',
            );
          },
          'anchorForLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        var anchor = await overlay._listener?.anchorForCapturedLabel(overlay, capturedLabel);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabel(capturedLabel, anchor).catchError((error) => developer.log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.offsetForLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerOffsetForLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerOffsetForLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `label` is required (fed into jsonDecode below); decline rather than fabricate ''.
            if (map['label'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerOffsetForLabel(
              label: map['label'] as String,
              event: 'LabelCaptureAdvancedOverlayListener.offsetForLabel',
            );
          },
          'offsetForLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        var capturedLabel = CapturedLabel.fromJSON(jsonDecode(payload.label), event.payload['frameSequenceId']);
        var offset = await overlay._listener?.offsetForCapturedLabel(overlay, capturedLabel);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabel(capturedLabel, offset).catchError((error) => developer.log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `field` is required (fed into jsonDecode below); decline rather than fabricate ''.
            // `identifier` is nullable on the wire, so null is a legitimate reconstructed value.
            if (map['field'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel(
              field: map['field'] as String,
              identifier: map['identifier'] is String ? map['identifier'] as String : null,
              event: 'LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel',
            );
          },
          'viewForFieldOfLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        // `identifier` is nullable on the wire: a null identifier cannot be routed to a
        // specific field view, so bail out explicitly rather than forwarding it.
        final labelFieldId = payload.identifier;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(payload.field));

        // this is to avoid processing multiple requests for the same
        // captured at the same time.
        if (_widgetRequestsCache.contains(labelFieldId)) return;
        _widgetRequestsCache.add(labelFieldId);

        var widget = await overlay._listener?.widgetForCapturedLabelField(overlay, labelField);
        if (widget != null) {
          // ignore: unnecessary_lambdas
          setWidgetForCapturedLabelField(labelFieldId, widget).catchError((error) => developer.log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `field` is required (fed into jsonDecode below); decline rather than fabricate ''.
            // `identifier` is nullable on the wire, so null is a legitimate reconstructed value.
            if (map['field'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel(
              field: map['field'] as String,
              identifier: map['identifier'] is String ? map['identifier'] as String : null,
              event: 'LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel',
            );
          },
          'anchorForFieldOfLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        final labelFieldId = payload.identifier;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(payload.field));
        var anchor = await overlay._listener?.anchorForCapturedLabelField(overlay, labelField);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabelField(labelFieldId, anchor).catchError((error) => developer.log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel')) {
        final payload = parsePayloadTolerantly<LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel>(
          event.payload,
          (raw) => LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.fromJson(raw),
          (raw) {
            final map = raw is Map ? raw : const <String, dynamic>{};
            // `field` is required (fed into jsonDecode below); decline rather than fabricate ''.
            // `identifier` is nullable on the wire, so null is a legitimate reconstructed value.
            if (map['field'] is! String) return null;
            return LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel(
              field: map['field'] as String,
              identifier: map['identifier'] is String ? map['identifier'] as String : null,
              event: 'LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel',
            );
          },
          'offsetForFieldOfLabel',
          'LabelCaptureAdvancedOverlay',
        );
        if (payload == null) return;
        final labelFieldId = payload.identifier;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(payload.field));
        var offset = await overlay._listener?.offsetForCapturedLabelField(overlay, labelField);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabelField(labelFieldId, offset).catchError((error) => developer.log(error));
        }
      }
    });
  }

  void unsubscribeListener() {
    if (!_isRegistered) return;
    _isRegistered = false;
    _overlaySubscription?.cancel();
    _overlaySubscription = null;

    labelMethodHandler
        .removeLabelCaptureAdvancedOverlayListener(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
