/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksLabel
import scandit_flutter_datacapture_core

@objc
public class ScanditFlutterDataCaptureLabel: NSObject, FlutterPlugin {
    private let methodChannel: FlutterMethodChannel
    private let labelModule: LabelModule

    init(labelModule: LabelModule, methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
        self.labelModule = labelModule
    }

    @objc
    public static func register(with registrar: FlutterPluginRegistrar) {
        let prefix = "com.scandit.datacapture.label"
        let methodChannel = FlutterMethodChannel(
            name: "\(prefix)/method_channel",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "\(prefix)/event_channel",
            binaryMessenger: registrar.messenger()
        )

        let emitter = FlutterEventEmitter(eventChannel: eventChannel)
        let labelCaptureModule = LabelModule(
            emitter: emitter
        )

        let plugin = ScanditFlutterDataCaptureLabel(
            labelModule: labelCaptureModule,
            methodChannel: methodChannel
        )
        let methodHandler = LabelMethodCallHandler(labelModule: labelCaptureModule)
        labelCaptureModule.didStart()
        methodChannel.setMethodCallHandler(methodHandler.handleMethodCall(_:result:))
        registrar.publish(plugin)
    }

    @objc
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        labelModule.didStop()
        methodChannel.setMethodCallHandler(nil)
    }
}
