/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.label;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.label.LabelCaptureModule;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class LabelMethodHandler implements MethodChannel.MethodCallHandler {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.label/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.label/method_channel";

    public LabelMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean executionResult = getSharedModule().execute(
                new FlutterMethodCall(call),
                new FlutterResult(result)
        );

        if (!executionResult) {
            result.notImplemented();
        }
    }

    private volatile LabelCaptureModule sharedModuleInstance;

    private LabelCaptureModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (LabelCaptureModule) this.serviceLocator.resolve(LabelCaptureModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
