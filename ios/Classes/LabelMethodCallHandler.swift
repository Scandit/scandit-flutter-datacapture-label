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
    private let labelModule: LabelModule

    init(labelModule: LabelModule) {
        self.labelModule = labelModule
    }

    @objc
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let executionResult = labelModule.execute(
            method: FlutterFrameworksMethodCall(call),
            result: FlutterFrameworkResult(reply: result)
        )

        if !executionResult {
            result(FlutterMethodNotImplemented)
        }
    }
}
