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
import 'package:scandit_flutter_datacapture_label/src/adaptive_recognition_result.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/label_method_handler.dart';
import 'package:scandit_flutter_datacapture_label/src/internal/generated/schema_types.dart'
    show LabelCaptureAdaptiveRecognitionListenerRecognized;
import 'package:scandit_flutter_datacapture_label/src/label_capture.dart';
import 'package:scandit_flutter_datacapture_label/src/label_capture_adaptive_recognition_settings.dart';
import 'package:scandit_flutter_datacapture_label/src/label_plugin_events.dart';
import 'package:scandit_flutter_datacapture_label/src/receipt_scanning_result.dart';
import '../tolerant_payload_parser.dart';

/// Interface to receive callbacks from [LabelCaptureAdaptiveRecognitionOverlay] during adaptive recognition.
///
/// Added in version 8.2.0
abstract class LabelCaptureAdaptiveRecognitionListener {
  /// Invoked when a document has been successfully recognized. The result contains the recognized data based on the result type.
  ///
  /// Added in version 8.2.0
  void didRecognize(AdaptiveRecognitionResult result);
  /// Invoked when a connection error occurs while trying to recognize a document.
  ///
  /// Added in version 8.2.0
  void didFail();
}

/// Specialized overlay that provides a guided adaptive recognition experience for Label Capture. The overlay coordinates the UI during the adaptive recognition flow and reports results through the [LabelCaptureAdaptiveRecognitionListener].
///
/// Added in version 8.2.0
class LabelCaptureAdaptiveRecognitionOverlay extends DataCaptureOverlay
    with ViewAttachable, _LabelCaptureAdaptiveRecognitionOverlayViewAttachable {
  final LabelCapture _mode;

  int get _dataCaptureViewId => view?.viewId ?? -1;

  LabelCaptureAdaptiveRecognitionSettings? _settings;

  LabelCaptureAdaptiveRecognitionOverlay._(this._mode) : super('receiptScanning');

  /// Constructs a new overlay for the specified LabelCapture mode.
  ///
  /// Added in version 8.2.0
  LabelCaptureAdaptiveRecognitionOverlay(LabelCapture mode) : this._(mode);

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 8.2.0
  @override
  DataCaptureView? get view => attachedView;

  /// The view this data capture overlay is attached to. When the data capture overlay is currently not attached to a view, *null* is returned.
  ///
  /// Added in version 8.2.0
  @override
  set view(DataCaptureView? newValue) {
    if (newValue == null) {
      attachedView?.unregisterAttachable(this);
      return;
    }

    newValue.registerAttachable(this);
  }

  LabelCaptureAdaptiveRecognitionListener? _listener;

  /// Sets the listener to observe adaptive recognition events from this overlay.
  ///
  /// Added in version 8.2.0
  LabelCaptureAdaptiveRecognitionListener? get listener => _listener;

  /// Sets the listener to observe adaptive recognition events from this overlay.
  ///
  /// Added in version 8.2.0
  set listener(LabelCaptureAdaptiveRecognitionListener? newValue) {
    _controller?.unsubscribeListener(); // cleanup first
    if (newValue != null) {
      _controller?.subscribeListener();
    }

    _listener = newValue;
  }

  /// Applies settings that customize the adaptive recognition UI and behavior. Use this to configure properties such as the processing hint text displayed while the overlay processes captured data.
  ///
  /// Added in version 8.2.0
  Future<void> applySettings(LabelCaptureAdaptiveRecognitionSettings settings) {
    _settings = settings;
    return _controller?.applyAdaptiveRecognitionSettings() ?? Future.value();
  }

  @override
  Map<String, dynamic> toMap() {
    final json = super.toMap();
    json['hasListener'] = listener != null;
    json['settings'] = _settings?.toMap();
    json['modeId'] = _mode.toMap()['modeId'];
    return json;
  }
}

/// Holds the [ViewAttachable] lifecycle for [LabelCaptureAdaptiveRecognitionOverlay].
///
/// Kept in a (private) mixin so the docs signature collector — which only inspects class
/// declarations — does not treat these callbacks as public API. (Mirrors `PrivateZoomGesture`.)
///
/// [SDC-30872] Register the listener in [onViewInitialized] (once the viewId is valid) and
/// re-register on view recreation, instead of eagerly at view-set time when the id may still
/// be -1 — which on iOS silently leaves the overlay delegate unset.
mixin _LabelCaptureAdaptiveRecognitionOverlayViewAttachable on ViewAttachable {
  _LabelCaptureAdaptiveRecognitionOverlayController? _controller;

  @override
  void onAttachToView(DataCaptureView view) {
    super.onAttachToView(view);
    _controller ??= _LabelCaptureAdaptiveRecognitionOverlayController(this as LabelCaptureAdaptiveRecognitionOverlay);
  }

  @override
  void onViewInitialized(int viewId) {
    if ((this as LabelCaptureAdaptiveRecognitionOverlay)._listener != null) {
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

class _LabelCaptureAdaptiveRecognitionOverlayController extends BaseController {
  StreamSubscription<dynamic>? _overlaySubscription;
  late final LabelMethodHandler labelMethodHandler;

  final LabelCaptureAdaptiveRecognitionOverlay overlay;

  bool _isRegistered = false;

  _LabelCaptureAdaptiveRecognitionOverlayController(this.overlay)
      : super('com.scandit.datacapture.label/method_channel') {
    labelMethodHandler = LabelMethodHandler(methodChannel);
  }

  void subscribeListener() {
    if (_isRegistered) return;
    _isRegistered = true;
    labelMethodHandler
        .registerListenerForAdaptiveRecognitionOverlayEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => _listenToEvents(), onError: onError);
  }

  void unsubscribeListener() {
    if (!_isRegistered) return;
    _isRegistered = false;
    _overlaySubscription?.cancel();
    _overlaySubscription = null;
    labelMethodHandler
        .unregisterListenerForAdaptiveRecognitionOverlayEvents(dataCaptureViewId: overlay._dataCaptureViewId)
        .then((value) => null, onError: onError);
  }

  void _listenToEvents() {
    if (_overlaySubscription != null) return;

    _overlaySubscription = LabelPluginEvents.labelEventStream.asFlutterEvents().listen((event) async {
      if (overlay._listener == null) return;

      if (event.isEvent('LabelCaptureAdaptiveRecognitionListener.recognized')) {
        // `result` is required and non-null in the generated schema, but native may still omit
        // it; treat a missing/null result the same as SKIP rather than forcing the strict parser
        // to throw on every such frame.
        final rawResult = event.payload['result'];
        if (rawResult == null) return;
        // Both platforms emit `result` as an object now; keep guarding the shape rather than
        // letting a malformed payload throw once per frame.
        if (rawResult is! Map<String, dynamic>) {
          logPayloadIssueOnce(
            'LabelCaptureAdaptiveRecognitionOverlay',
            'recognized.unsupportedResultShape',
            'recognized payload result is not a Map; skipping event',
          );
          return;
        }
        // The strict parse gates delivery, matching Android and iOS: a payload that
        // fails schema validation drops the event on every platform. [SDC-33900]
        // Parsed once via the generated schema type; the public result is built from
        // that parse instead of re-parsing the same bytes. [SDC-34081]
        final ReceiptScanningResult result;
        try {
          final parsed = LabelCaptureAdaptiveRecognitionListenerRecognized.fromJson(event.payload);
          result = receiptScanningResultFromGenerated(parsed.result);
        } catch (error) {
          logPayloadIssueOnce(
            'LabelCaptureAdaptiveRecognitionOverlay',
            'recognized.schemaValidation',
            'recognized payload failed schema validation: $error',
          );
          return;
        }
        overlay._listener?.didRecognize(result);
      } else if (event.isEvent('LabelCaptureAdaptiveRecognitionListener.failure')) {
        overlay._listener?.didFail();
      }
    });
  }

  Future<void> applyAdaptiveRecognitionSettings() {
    return labelMethodHandler
        .applyLabelCaptureAdaptiveRecognitionSettings(
          dataCaptureViewId: overlay._dataCaptureViewId,
          overlayJson: jsonEncode(overlay.toMap()),
        )
        .then((value) => null, onError: onError);
  }

  @override
  void dispose() {
    unsubscribeListener();
    super.dispose();
  }
}
