/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksCore
import ScanditFrameworksLabel
import scandit_flutter_datacapture_core

class LabelMethodCallHandler {
    private let labelModule: LabelCaptureModule

    init(labelModule: LabelCaptureModule) {
        self.labelModule = labelModule
    }

    @objc
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDefaults":
            do {
                let defaultsJSONString = String(
                    data: try JSONSerialization.data(
                        withJSONObject: self.labelModule.getDefaults(),
                        options: []
                    ),
                    encoding: .utf8
                )
                result(defaultsJSONString)
            } catch let error as NSError {
                result(
                    FlutterError(code: "-1", message: "Unable to load the defaults. \(error)", details: error.domain)
                )
            }
        case "executeLabel":
            let coreModuleName = String(describing: CoreModule.self)
            guard let coreModule = DefaultServiceLocator.shared.resolve(clazzName: coreModuleName) as? CoreModule else {
                result(
                    FlutterError(
                        code: "-1",
                        message: "Unable to retrieve the CoreModule from the locator.",
                        details: nil
                    )
                )
                return
            }

            let flutterResult = FlutterFrameworkResult(reply: result)
            let handled = coreModule.execute(
                FlutterFrameworksMethodCall(call),
                result: flutterResult,
                module: self.labelModule
            )

            if !handled {
                let methodName = call.stringValue(for: "methodName", from: call.params() ?? [:]) ?? "unknown"
                result(FlutterError(code: "-1", message: "Unknown Core method: \(methodName)", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
