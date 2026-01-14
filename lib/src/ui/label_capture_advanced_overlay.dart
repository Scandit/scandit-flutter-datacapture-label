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

class LabelCaptureAdvancedOverlay extends DataCaptureOverlay {
  _LabelCaptureAdvancedOverlayController? _controller;

  DataCaptureView? _view;

  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureAdvancedOverlay._(this._mode) : super('labelCaptureAdvanced');

  LabelCaptureAdvancedOverlay(LabelCapture mode) : this._(mode);

  @override
  DataCaptureView? get view => _view;

  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      _view = null;
      _controller?.dispose();
      _controller = null;
      return;
    }

    _view = newValue;
    _controller ??= _LabelCaptureAdvancedOverlayController(this);
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

class _LabelCaptureAdvancedOverlayController extends BaseController {
  final LabelCaptureAdvancedOverlay overlay;

  StreamSubscription<dynamic>? _overlaySubscription;

  final List<String> _widgetRequestsCache = [];

  _LabelCaptureAdvancedOverlayController(this.overlay) : super('com.scandit.datacapture.label/method_channel') {
    initialize();
  }

  void initialize() {
    if (overlay._listener != null) {
      subscribeListener();
    }
  }

  Future<void> setWidgetForCapturedLabel(CapturedLabel capturedLabel, LabelCaptureAdvancedOverlayWidget? widget) async {
    var arguments = <String, dynamic>{
      'identifier': capturedLabel.trackingId,
      'dataCaptureViewId': overlay._dataCaptureViewId,
    };

    if (widget != null) {
      arguments['view'] = await widget.toImage;
    } else {
      arguments['view'] = null;
    }
    return methodChannel
        .invokeMethod('setViewForCapturedLabel', arguments)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(capturedLabel.trackingId.toString()));
  }

  Future<void> setWidgetForCapturedLabelField(String labelFieldId, LabelCaptureAdvancedOverlayWidget? widget) async {
    var arguments = <String, dynamic>{'identifier': labelFieldId, 'dataCaptureViewId': overlay._dataCaptureViewId};

    if (widget != null) {
      arguments['view'] = await widget.toImage;
    } else {
      arguments['view'] = null;
    }

    return methodChannel
        .invokeMethod('setViewForCapturedLabelField', arguments)
        // once the widget is sent we do remove the request from the cache
        .then((value) => _widgetRequestsCache.remove(labelFieldId));
  }

  Future<void> setAnchorForCapturedLabel(CapturedLabel capturedLabel, Anchor anchor) {
    var arguments = {
      'anchor': anchor.toString(),
      'identifier': capturedLabel.trackingId,
      'dataCaptureViewId': overlay._dataCaptureViewId,
    };
    return methodChannel.invokeMethod('setAnchorForCapturedLabel', jsonEncode(arguments));
  }

  Future<void> setAnchorForCapturedLabelField(String labelFieldId, Anchor anchor) {
    var arguments = {
      'anchor': anchor.toString(),
      'identifier': labelFieldId,
      'dataCaptureViewId': overlay._dataCaptureViewId,
    };
    return methodChannel.invokeMethod('setAnchorForCapturedLabelField', jsonEncode(arguments));
  }

  Future<void> setOffsetForCapturedLabel(CapturedLabel capturedLabel, PointWithUnit offset) {
    var arguments = {
      'offset': jsonEncode(offset.toMap()),
      'identifier': capturedLabel.trackingId,
      'dataCaptureViewId': overlay._dataCaptureViewId,
    };
    return methodChannel.invokeMethod('setOffsetForCapturedLabel', jsonEncode(arguments));
  }

  Future<void> setOffsetForCapturedLabelField(String labelFieldId, PointWithUnit offset) {
    var arguments = {
      'offset': jsonEncode(offset.toMap()),
      'identifier': labelFieldId,
      'dataCaptureViewId': overlay._dataCaptureViewId,
    };
    return methodChannel.invokeMethod('setOffsetForCapturedLabelField', jsonEncode(arguments));
  }

  Future<void> clearCapturedLabelWidgets() {
    return methodChannel.invokeMethod('clearCapturedLabelViews', {'dataCaptureViewId': overlay._dataCaptureViewId});
  }

  Future<void> update() {
    return methodChannel.invokeMethod('updateLabelCaptureAdvancedOverlay', {
      'dataCaptureViewId': overlay._dataCaptureViewId,
      'advancedOverlayJson': jsonEncode(overlay.toMap()),
    }).then((value) => null, onError: onError);
  }

  void subscribeListener() {
    methodChannel.invokeMethod('addLabelCaptureAdvancedOverlayListener',
        {'dataCaptureViewId': overlay._dataCaptureViewId}).then((value) => _listenToEvents(), onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.listen((event) async {
      if (overlay._listener == null) return;

      var json = jsonDecode(event as String);
      switch (json['event'] as String) {
        case 'LabelCaptureAdvancedOverlayListener.viewForLabel':
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          // this is to avoid processing multiple requests for the same
          // captured at the same time.
          if (_widgetRequestsCache.contains(capturedLabel.trackingId.toString())) return;
          _widgetRequestsCache.add(capturedLabel.trackingId.toString());

          var widget = await overlay._listener?.widgetForCapturedLabel(overlay, capturedLabel);
          if (widget == null) return;
          // ignore: unnecessary_lambdas
          setWidgetForCapturedLabel(capturedLabel, widget).catchError((error) => log(error));
          break;
        case 'LabelCaptureAdvancedOverlayListener.anchorForLabel':
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          var anchor = await overlay._listener?.anchorForCapturedLabel(overlay, capturedLabel);
          if (anchor == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabel(capturedLabel, anchor).catchError((error) => log(error));
          break;
        case 'LabelCaptureAdvancedOverlayListener.offsetForLabel':
          var capturedLabel = CapturedLabel.fromJSON(jsonDecode(json['label']), json['frameSequenceId']);
          var offset = await overlay._listener?.offsetForCapturedLabel(overlay, capturedLabel);
          if (offset == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabel(capturedLabel, offset).catchError((error) => log(error));
          break;
        case 'LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel':
          final labelFieldId = json['identifier'] as String?;
          if (labelFieldId == null) {
            break;
          }
          var labelField = LabelField.fromJSON(jsonDecode(json['field']));

          // this is to avoid processing multiple requests for the same
          // captured at the same time.
          if (_widgetRequestsCache.contains(labelFieldId)) return;
          _widgetRequestsCache.add(labelFieldId);

          var widget = await overlay._listener?.widgetForCapturedLabelField(overlay, labelField);
          if (widget == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setWidgetForCapturedLabelField(labelFieldId, widget).catchError((error) => log(error));
          break;

        case 'LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel':
          final labelFieldId = json['identifier'] as String?;
          if (labelFieldId == null) {
            break;
          }
          var labelField = LabelField.fromJSON(jsonDecode(json['field']));
          var anchor = await overlay._listener?.anchorForCapturedLabelField(overlay, labelField);
          if (anchor == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setAnchorForCapturedLabelField(labelFieldId, anchor).catchError((error) => log(error));
          break;
        case 'LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel':
          final labelFieldId = json['identifier'] as String?;
          if (labelFieldId == null) {
            break;
          }
          var labelField = LabelField.fromJSON(jsonDecode(json['field']));
          var offset = await overlay._listener?.offsetForCapturedLabelField(overlay, labelField);
          if (offset == null) {
            break;
          }
          // ignore: unnecessary_lambdas
          setOffsetForCapturedLabelField(labelFieldId, offset).catchError((error) => log(error));
          break;
      }
    });
  }

  void unsubscribeListener() {
    _overlaySubscription?.cancel();
    _overlaySubscription = null;

    methodChannel.invokeMethod('removeLabelCaptureAdvancedOverlayListener',
        {'dataCaptureViewId': overlay._dataCaptureViewId}).then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
