/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/label.json

import 'package:flutter/services.dart';

/// Generated Label method handler for Flutter.
/// Routes all Label method calls through a single executeLabel entry point.
class LabelMethodHandler {
  final MethodChannel _methodChannel;

  LabelMethodHandler(this._methodChannel);

  /// Single entry point for all Label operations.
  /// Routes to appropriate native command based on moduleName and methodName.
  Future<dynamic> executeLabel(String moduleName, String methodName, Map<String, dynamic> params) async {
    final arguments = {
      'moduleName': moduleName,
      'methodName': methodName,
      ...params,
    };
    return await _methodChannel.invokeMethod('executeLabel', arguments);
  }

  /// Finish callback for label capture did update session event
  Future<void> finishLabelCaptureListenerDidUpdateSession({required int modeId, required bool isEnabled}) async {
    final params = {
      'modeId': modeId,
      'isEnabled': isEnabled,
    };
    return await executeLabel('LabelCaptureModule', 'finishLabelCaptureListenerDidUpdateSession', params);
  }

  /// Register persistent event listener for label capture events
  Future<void> addLabelCaptureListener({required int modeId}) async {
    final params = {
      'modeId': modeId,
    };
    return await executeLabel('LabelCaptureModule', 'addLabelCaptureListener', params);
  }

  /// Unregister event listener for label capture events
  Future<void> removeLabelCaptureListener({required int modeId}) async {
    final params = {
      'modeId': modeId,
    };
    return await executeLabel('LabelCaptureModule', 'removeLabelCaptureListener', params);
  }

  /// Sets the enabled state of the label capture mode
  Future<void> setLabelCaptureModeEnabledState({required int modeId, required bool isEnabled}) async {
    final params = {
      'modeId': modeId,
      'isEnabled': isEnabled,
    };
    return await executeLabel('LabelCaptureModule', 'setLabelCaptureModeEnabledState', params);
  }

  /// Updates the label capture mode configuration
  Future<void> updateLabelCaptureMode({required Map<String, dynamic> modeJson}) async {
    final params = {
      'modeJson': modeJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureMode', params);
  }

  /// Updates the label capture mode settings
  Future<void> updateLabelCaptureSettings({required int modeId, required Map<String, dynamic> settingsJson}) async {
    final params = {
      'modeId': modeId,
      'settingsJson': settingsJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureSettings', params);
  }

  /// Updates the label capture feedback configuration
  Future<void> updateLabelCaptureFeedback({required int modeId, required String feedbackJson}) async {
    final params = {
      'modeId': modeId,
      'feedbackJson': feedbackJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureFeedback', params);
  }

  /// Sets the view for a captured label in advanced overlay
  Future<void> setViewForCapturedLabel(
      {required int dataCaptureViewId, String? viewJson, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (viewJson != null) 'viewJson': viewJson,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setViewForCapturedLabel', params);
  }

  /// Sets the view for a captured label in advanced overlay using byte array
  Future<void> setViewForCapturedLabelFromBytes(
      {required int dataCaptureViewId, Uint8List? viewBytes, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (viewBytes != null) 'viewBytes': viewBytes,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setViewForCapturedLabelFromBytes', params);
  }

  /// Sets the view for a captured label field in advanced overlay
  Future<void> setViewForCapturedLabelField(
      {required int dataCaptureViewId, required String identifier, String? viewJson}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'identifier': identifier,
      if (viewJson != null) 'viewJson': viewJson,
    };
    return await executeLabel('LabelCaptureModule', 'setViewForCapturedLabelField', params);
  }

  /// Sets the view for a captured label field in advanced overlay using byte array
  Future<void> setViewForCapturedLabelFieldFromBytes(
      {required int dataCaptureViewId, Uint8List? viewBytes, required String identifier}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (viewBytes != null) 'viewBytes': viewBytes,
      'identifier': identifier,
    };
    return await executeLabel('LabelCaptureModule', 'setViewForCapturedLabelFieldFromBytes', params);
  }

  /// Sets the anchor for a captured label in advanced overlay
  Future<void> setAnchorForCapturedLabel(
      {required int dataCaptureViewId, required String anchorJson, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'anchorJson': anchorJson,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setAnchorForCapturedLabel', params);
  }

  /// Sets the anchor for a captured label field in advanced overlay
  Future<void> setAnchorForCapturedLabelField(
      {required int dataCaptureViewId, required String anchorJson, required String identifier}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'anchorJson': anchorJson,
      'identifier': identifier,
    };
    return await executeLabel('LabelCaptureModule', 'setAnchorForCapturedLabelField', params);
  }

  /// Sets the offset for a captured label in advanced overlay
  Future<void> setOffsetForCapturedLabel(
      {required int dataCaptureViewId, required String offsetJson, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'offsetJson': offsetJson,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setOffsetForCapturedLabel', params);
  }

  /// Sets the offset for a captured label field in advanced overlay
  Future<void> setOffsetForCapturedLabelField(
      {required int dataCaptureViewId, required String offsetJson, required String identifier}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'offsetJson': offsetJson,
      'identifier': identifier,
    };
    return await executeLabel('LabelCaptureModule', 'setOffsetForCapturedLabelField', params);
  }

  /// Clears all views for captured labels in advanced overlay
  Future<void> clearCapturedLabelViews({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'clearCapturedLabelViews', params);
  }

  /// Register persistent event listener for label capture basic overlay events
  Future<void> addLabelCaptureBasicOverlayListener({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'addLabelCaptureBasicOverlayListener', params);
  }

  /// Unregister event listener for label capture basic overlay events
  Future<void> removeLabelCaptureBasicOverlayListener({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'removeLabelCaptureBasicOverlayListener', params);
  }

  /// Updates the label capture basic overlay configuration
  Future<void> updateLabelCaptureBasicOverlay(
      {required int dataCaptureViewId, required String basicOverlayJson}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'basicOverlayJson': basicOverlayJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureBasicOverlay', params);
  }

  /// Sets the brush for a captured label in basic overlay
  Future<void> setLabelCaptureBasicOverlayBrushForLabel(
      {required int dataCaptureViewId, String? brushJson, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (brushJson != null) 'brushJson': brushJson,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setLabelCaptureBasicOverlayBrushForLabel', params);
  }

  /// Sets the brush for a captured label field in basic overlay
  Future<void> setLabelCaptureBasicOverlayBrushForFieldOfLabel(
      {required int dataCaptureViewId, String? brushJson, required String fieldName, required int trackingId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      if (brushJson != null) 'brushJson': brushJson,
      'fieldName': fieldName,
      'trackingId': trackingId,
    };
    return await executeLabel('LabelCaptureModule', 'setLabelCaptureBasicOverlayBrushForFieldOfLabel', params);
  }

  /// Register persistent event listener for label capture advanced overlay events
  Future<void> addLabelCaptureAdvancedOverlayListener({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'addLabelCaptureAdvancedOverlayListener', params);
  }

  /// Unregister event listener for label capture advanced overlay events
  Future<void> removeLabelCaptureAdvancedOverlayListener({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'removeLabelCaptureAdvancedOverlayListener', params);
  }

  /// Updates the label capture advanced overlay configuration
  Future<void> updateLabelCaptureAdvancedOverlay(
      {required int dataCaptureViewId, required String advancedOverlayJson}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'advancedOverlayJson': advancedOverlayJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureAdvancedOverlay', params);
  }

  /// Register persistent event listener for label capture validation flow overlay events
  Future<void> registerListenerForValidationFlowEvents({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'registerListenerForValidationFlowEvents', params);
  }

  /// Unregister event listener for label capture validation flow overlay events
  Future<void> unregisterListenerForValidationFlowEvents({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'unregisterListenerForValidationFlowEvents', params);
  }

  /// Updates the label capture validation flow overlay configuration
  Future<void> updateLabelCaptureValidationFlowOverlay(
      {required int dataCaptureViewId, required String overlayJson}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'overlayJson': overlayJson,
    };
    return await executeLabel('LabelCaptureModule', 'updateLabelCaptureValidationFlowOverlay', params);
  }

  /// Register persistent event listener for label capture adaptive recognition overlay events
  Future<void> registerListenerForAdaptiveRecognitionOverlayEvents({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'registerListenerForAdaptiveRecognitionOverlayEvents', params);
  }

  /// Unregister event listener for label capture adaptive recognition overlay events
  Future<void> unregisterListenerForAdaptiveRecognitionOverlayEvents({required int dataCaptureViewId}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
    };
    return await executeLabel('LabelCaptureModule', 'unregisterListenerForAdaptiveRecognitionOverlayEvents', params);
  }

  /// Applies adaptive recognition settings to the label capture overlay
  Future<void> applyLabelCaptureAdaptiveRecognitionSettings(
      {required int dataCaptureViewId, required String overlayJson}) async {
    final params = {
      'dataCaptureViewId': dataCaptureViewId,
      'overlayJson': overlayJson,
    };
    return await executeLabel('LabelCaptureModule', 'applyLabelCaptureAdaptiveRecognitionSettings', params);
  }
}
