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
        // Only the defaults Dart cannot source from its generated static consts.
        case "getDynamicDefaults":
            self.reply(defaults: self.labelModule.getDynamicDefaults(), result: result)
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

    private func reply(defaults: [String: Any?], result: @escaping FlutterResult) {
        do {
            let defaultsJSONString = String(
                data: try JSONSerialization.data(
                    withJSONObject: defaults,
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
    }
}
