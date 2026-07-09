/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_label/src/captured_label.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_field.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/ui/label_capture_advanced_overlay_widget.dart';

abstract class LabelCaptureAdvancedOverlayListener {
  Future<LabelCaptureAdvancedOverlayWidget?> widgetForCapturedLabel(
    LabelCaptureAdvancedOverlay overlay,
    CapturedLabel capturedLabel,
  );
  Future<Anchor> anchorForCapturedLabel(LabelCaptureAdvancedOverlay overlay, CapturedLabel capturedLabel);
  Future<PointWithUnit> offsetForCapturedLabel(LabelCaptureAdvancedOverlay overlay, CapturedLabel capturedLabel);
  Future<LabelCaptureAdvancedOverlayWidget?> widgetForCapturedLabelField(
    LabelCaptureAdvancedOverlay overlay,
    LabelField labelField,
  );
  Future<Anchor> anchorForCapturedLabelField(LabelCaptureAdvancedOverlay overlay, LabelField labelField);
  Future<PointWithUnit> offsetForCapturedLabelField(LabelCaptureAdvancedOverlay overlay, LabelField labelField);
}

class LabelCaptureAdvancedOverlay extends DataCaptureOverlay
    with ViewAttachable, _LabelCaptureAdvancedOverlayViewAttachable {
  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureAdvancedOverlay._(this._mode) : super('labelCaptureAdvanced');

  LabelCaptureAdvancedOverlay(LabelCapture mode) : this._(mode);

  @override
  DataCaptureView? get view => attachedView;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      attachedView?.unregisterAttachable(this);
      return;
    }

    newValue.registerAttachable(this);
  }

  LabelCaptureAdvancedOverlayListener? _listener;

  LabelCaptureAdvancedOverlayListener? get listener => _listener;

  set listener(LabelCaptureAdvancedOverlayListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  bool _shouldShowScanAreaGuides = false;

  bool get shouldShowScanAreaGuides => _shouldShowScanAreaGuides;

  set shouldShowScanAreaGuides(bool newValue) {
    _shouldShowScanAreaGuides = newValue;
    _controller?.update();
  }

  Future<void> setWidgetForCapturedLabel(CapturedLabel capturedLabel, LabelCaptureAdvancedOverlayWidget? widget) {
    return _controller?.setWidgetForCapturedLabel(capturedLabel, widget) ?? Future.value();
  }

  Future<void> setAnchorForCapturedLabel(CapturedLabel capturedLabel, Anchor anchor) {
    return _controller?.setAnchorForCapturedLabel(capturedLabel, anchor) ?? Future.value();
  }

  Future<void> setOffsetForCapturedLabel(CapturedLabel capturedLabel, PointWithUnit offset) {
    return _controller?.setOffsetForCapturedLabel(capturedLabel, offset) ?? Future.value();
  }

  Future<void> setWidgetForCapturedLabelField(
    LabelField labelField,
    CapturedLabel capturedLabel,
    LabelCaptureAdvancedOverlayWidget? widget,
  ) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setWidgetForCapturedLabelField(labelFieldId, widget) ?? Future.value();
  }

  Future<void> setAnchorForCapturedLabelField(LabelField labelField, CapturedLabel capturedLabel, Anchor anchor) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setAnchorForCapturedLabelField(labelFieldId, anchor) ?? Future.value();
  }

  Future<void> setOffsetForCapturedLabelField(
    LabelField labelField,
    CapturedLabel capturedLabel,
    PointWithUnit offset,
  ) {
    final labelFieldId = '${capturedLabel.trackingId}§${labelField.name}';
    return _controller?.setOffsetForCapturedLabelField(labelFieldId, offset) ?? Future.value();
  }

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
            dataCaptureViewId: overlay._dataCaptureViewId, trackingId: capturedLabel.trackingId, viewBytes: viewBytes)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(capturedLabel.trackingId.toString()));
  }

  Future<void> setWidgetForCapturedLabelField(String labelFieldId, LabelCaptureAdvancedOverlayWidget? widget) async {
    final viewBytes = await widget?.toImage;
    return labelMethodHandler
        .setViewForCapturedLabelFieldFromBytes(
            dataCaptureViewId: overlay._dataCaptureViewId, identifier: labelFieldId, viewBytes: viewBytes)
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
            dataCaptureViewId: overlay._dataCaptureViewId, advancedOverlayJson: jsonEncode(overlay.toMap()))
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
        var capturedLabel =
            CapturedLabel.fromJSON(jsonDecode(event.payload['label']), event.payload['frameSequenceId']);
        // this is to avoid processing multiple requests for the same
        // captured at the same time.
        if (_widgetRequestsCache.contains(capturedLabel.trackingId.toString())) return;
        _widgetRequestsCache.add(capturedLabel.trackingId.toString());

        var widget = await overlay._listener?.widgetForCapturedLabel(overlay, capturedLabel);
        if (widget == null) return;
        // ignore: unnecessary_lambdas
        setWidgetForCapturedLabel(capturedLabel, widget).catchError((error) => log(error));
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.anchorForLabel')) {
        var capturedLabel =
            CapturedLabel.fromJSON(jsonDecode(event.payload['label']), event.payload['frameSequenceId']);
        var anchor = await overlay._listener?.anchorForCapturedLabel(overlay, capturedLabel);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabel(capturedLabel, anchor).catchError((error) => log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.offsetForLabel')) {
        var capturedLabel =
            CapturedLabel.fromJSON(jsonDecode(event.payload['label']), event.payload['frameSequenceId']);
        var offset = await overlay._listener?.offsetForCapturedLabel(overlay, capturedLabel);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabel(capturedLabel, offset).catchError((error) => log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel')) {
        final labelFieldId = event.payload['identifier'] as String?;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(event.payload['field']));

        // this is to avoid processing multiple requests for the same
        // captured at the same time.
        if (_widgetRequestsCache.contains(labelFieldId)) return;
        _widgetRequestsCache.add(labelFieldId);

        var widget = await overlay._listener?.widgetForCapturedLabelField(overlay, labelField);
        if (widget != null) {
          // ignore: unnecessary_lambdas
          setWidgetForCapturedLabelField(labelFieldId, widget).catchError((error) => log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel')) {
        final labelFieldId = event.payload['identifier'] as String?;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(event.payload['field']));
        var anchor = await overlay._listener?.anchorForCapturedLabelField(overlay, labelField);
        if (anchor != null) {
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabelField(labelFieldId, anchor).catchError((error) => log(error));
        }
      } else if (event.isEvent('LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel')) {
        final labelFieldId = event.payload['identifier'] as String?;
        if (labelFieldId == null) return;
        var labelField = LabelField.fromJSON(jsonDecode(event.payload['field']));
        var offset = await overlay._listener?.offsetForCapturedLabelField(overlay, labelField);
        if (offset != null) {
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabelField(labelFieldId, offset).catchError((error) => log(error));
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
