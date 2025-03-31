/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksLabel
import scandit_flutter_datacapture_core
import ScanditFrameworksCore

class LabelMethodCallHandler {
    private enum FunctionNames {
        static let getLabelCaptureDefaults = "getLabelCaptureDefaults"
        static let finishLabelCaptureListenerDidUpdateSession = "finishLabelCaptureListenerDidUpdateSession"
        static let addLabelCaptureListener = "addLabelCaptureListener"
        static let setLabelCaptureModeEnabledState = "setLabelCaptureModeEnabledState"
        static let updateLabelCaptureMode = "updateLabelCaptureMode"
        static let applyLabelCaptureModeSettings = "applyLabelCaptureModeSettings"
        static let removeLabelCaptureListener = "removeLabelCaptureListener"
        static let setViewForCapturedLabel = "setViewForCapturedLabel"
        static let setViewForCapturedLabelField = "setViewForCapturedLabelField"
        static let setAnchorForCapturedLabel = "setAnchorForCapturedLabel"
        static let setAnchorForCapturedLabelField = "setAnchorForCapturedLabelField"
        static let setOffsetForCapturedLabel = "setOffsetForCapturedLabel"
        static let setOffsetForCapturedLabelField = "setOffsetForCapturedLabelField"
        static let clearCapturedLabelViews = "clearCapturedLabelViews"
        static let updateLabelCaptureAdvancedOverlay = "updateLabelCaptureAdvancedOverlay"
        static let addLabelCaptureAdvancedOverlayListener = "addLabelCaptureAdvancedOverlayListener"
        static let removeLabelCaptureAdvancedOverlayListener = "removeLabelCaptureAdvancedOverlayListener"
        static let addLabelCaptureBasicOverlayListener = "addLabelCaptureBasicOverlayListener"
        static let removeLabelCaptureBasicOverlayListener = "removeLabelCaptureBasicOverlayListener"
        static let updateLabelCaptureBasicOverlay = "updateLabelCaptureBasicOverlay"
        static let setLabelCaptureBasicOverlayBrushForFieldOfLabel = "setLabelCaptureBasicOverlayBrushForFieldOfLabel"
        static let setLabelCaptureBasicOverlayBrushForLabel = "setLabelCaptureBasicOverlayBrushForLabel"
    }

    private let labelModule: LabelModule

    init(labelModule: LabelModule) {
        self.labelModule = labelModule
    }

    @objc
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case FunctionNames.getLabelCaptureDefaults:
            let defaults = labelModule.defaults.stringValue
            result(defaults)

        case FunctionNames.finishLabelCaptureListenerDidUpdateSession:
            let enabled = call.arguments as? Bool ?? false
            labelModule.finishDidUpdateCallback(enabled: enabled)
            result(nil)

        case FunctionNames.addLabelCaptureListener:
            labelModule.addListener()
            result(nil)

        case FunctionNames.setLabelCaptureModeEnabledState:
            guard let enabled = call.arguments as? Bool else {
                result(FlutterError(code: "error", message: "enabled argument is missing", details: nil))
                return
            }
            labelModule.setModeEnabled(enabled: enabled)
            result(nil)

        case FunctionNames.updateLabelCaptureMode:
            guard let modeJson = call.arguments as? String else {
                result(FlutterError(code: "error", message: "mode json is missing", details: nil))
                return
            }
            labelModule.updateModeFromJson(modeJson: modeJson, result: FlutterFrameworkResult(reply: result))

        case FunctionNames.applyLabelCaptureModeSettings:
            guard let modeSettingsJson = call.arguments as? String else {
                result(FlutterError(code: "error", message: "settings json is missing", details: nil))
                return
            }
            labelModule.applyModeSettings(modeSettingsJson: modeSettingsJson, result: FlutterFrameworkResult(reply: result))

        case FunctionNames.removeLabelCaptureListener:
            labelModule.removeListener()
            result(nil)

        case FunctionNames.setViewForCapturedLabel:
            guard let viewParams = call.arguments as? [String: Any?] else {
                result(FlutterError(code: "error", message: "View parameters are missing", details: nil))
                return
            }

            labelModule.setViewForCapturedLabel(with: viewParams, result: FlutterFrameworkResult(reply: result))
        case FunctionNames.setViewForCapturedLabelField:
            guard var args = call.arguments as? [String: Any?] else {
                result(FlutterError(code: "error", message: "View parameters are missing", details: nil))
                return
            }
            let regularData = args["view"] as? FlutterStandardTypedData
            args["view"] = regularData?.data
            labelModule.setViewForCapturedLabelField(with: args, result: FlutterFrameworkResult(reply: result))
            result(nil)

        case FunctionNames.setAnchorForCapturedLabel:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setAnchorForCapturedLabel", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setAnchorForCapturedLabel", details: nil))
                return
            }
            let anchorForLabel = AnchorForLabel(
                anchorString: json["anchor"] as! String,
                trackingId: json["identifier"] as! Int
            )
            labelModule.setAnchorForCapturedLabel(
                anchorForLabel: anchorForLabel,
                result: FlutterFrameworkResult(reply: result)
            )

        case FunctionNames.setAnchorForCapturedLabelField:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setAnchorForCapturedLabelField", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setAnchorForCapturedLabelField", details: nil))
                return
            }
            let fieldLabelKey = json["identifier"] as! String
            let components = fieldLabelKey.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0])!
            let fieldName = components[1]
            let anchorForLabelField = AnchorForLabel(
                anchorString: json["anchor"] as! String,
                trackingId: trackingId,
                fieldName: fieldName
            )
            labelModule.setAnchorForFieldOfLabel(
                anchorForFieldOfLabel: anchorForLabelField,
                result: FlutterFrameworkResult(reply: result)
            )

        case FunctionNames.setOffsetForCapturedLabel:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setOffsetForCapturedLabel", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setOffsetForCapturedLabel", details: nil))
                return
            }
            let offsetForLabel = OffsetForLabel(
                offsetJson: json["offset"] as! String,
                trackingId: json["identifier"] as! Int
            )
            labelModule.setOffsetForCapturedLabel(
                offsetForLabel: offsetForLabel,
                result: FlutterFrameworkResult(reply: result)
            )

        case FunctionNames.setOffsetForCapturedLabelField:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setOffsetForCapturedLabelField", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setOffsetForCapturedLabelField", details: nil))
                return
            }
            let fieldLabelKey = json["identifier"] as! String
            let components = fieldLabelKey.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0])!
            let fieldName = components[1]
            let offsetForLabelField = OffsetForLabel(
                offsetJson: json["offset"] as! String,
                trackingId: trackingId,
                fieldName: fieldName
            )
            labelModule.setOffsetForFieldOfLabel(
                offsetForFieldOfLabel: offsetForLabelField,
                result: FlutterFrameworkResult(reply: result)
            )

        case FunctionNames.clearCapturedLabelViews:
            labelModule.clearTrackedCapturedLabelViews()
            result(nil)

        case FunctionNames.updateLabelCaptureAdvancedOverlay:
            guard let advancedOverlayJson = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid argument received for updateLabelCaptureAdvancedOverlay", details: nil))
                return
            }
            labelModule.updateAdvancedOverlay(
                overlayJson: advancedOverlayJson,
                result: FlutterFrameworkResult(reply: result)
            )

        case FunctionNames.addLabelCaptureAdvancedOverlayListener:
            labelModule.addAdvancedOverlayListener()
            result(nil)

        case FunctionNames.removeLabelCaptureAdvancedOverlayListener:
            labelModule.removeAdvancedOverlayListener()
            result(nil)

        case FunctionNames.addLabelCaptureBasicOverlayListener:
            labelModule.addBasicOverlayListener()
            result(nil)

        case FunctionNames.removeLabelCaptureBasicOverlayListener:
            labelModule.removeBasicOverlayListener()
            result(nil)

        case FunctionNames.updateLabelCaptureBasicOverlay:
            guard let basicOverlayJson = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received in updateLabelCaptureBasicOverlay", details: nil))
                return
            }
            labelModule.updateBasicOverlay(overlayJson: basicOverlayJson, result: FlutterFrameworkResult(reply: result))

        case FunctionNames.setLabelCaptureBasicOverlayBrushForFieldOfLabel:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setLabelCaptureBasicOverlayBrushForFieldOfLabel", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setLabelCaptureBasicOverlayBrushForFieldOfLabel", details: nil))
                return
            }

            let fieldLabelKey = json["identifier"] as! String
            let components = fieldLabelKey.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0])!
            let fieldName = components[1]
            let brushForField = BrushForLabelField(
                brushJson: json["brush"] as? String,
                labelTrackingId: trackingId,
                fieldName: fieldName
            )
            labelModule.setBrushForFieldOfLabel(brushForFieldOfLabel: brushForField, result: FlutterFrameworkResult(reply: result))

        case FunctionNames.setLabelCaptureBasicOverlayBrushForLabel:
            guard let jsonString = call.arguments as? String else {
                result(FlutterError(code: "error", message: "Invalid arguments received for setLabelCaptureBasicOverlayBrushForLabel", details: nil))
                return
            }
            
            guard let jsonData = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                result(FlutterError(code: "error", message: "Failed to parse JSON string for setLabelCaptureBasicOverlayBrushForLabel", details: nil))
                return
            }
            let brushForLabel = BrushForLabelField(
                brushJson: json["brush"] as? String,
                labelTrackingId: json["identifier"] as! Int
            )
            labelModule.setBrushForLabel(
                brushForLabel: brushForLabel,
                result: FlutterFrameworkResult(reply: result)
            )

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
