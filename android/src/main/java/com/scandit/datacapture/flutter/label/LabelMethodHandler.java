/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.label;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;
import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.label.LabelCaptureModule;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

public class LabelMethodHandler implements MethodChannel.MethodCallHandler {

    private final ServiceLocator<FrameworkModule> serviceLocator;

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.label/event_channel";
    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.label/method_channel";

    public LabelMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this.serviceLocator = serviceLocator;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getDefaults")) {
            result.success(new JSONObject(getLabelCaptureModule().getDefaults()).toString());
            return;
        } else if (call.method.equals("executeLabel")) {
            CoreModule coreModule = (CoreModule) getModule(CoreModule.class.getSimpleName());
            if (coreModule == null) {
                result.error("-1", "Unable to retrieve the CoreModule from the locator.", null);
                return;
            }
            boolean executionResult = coreModule.execute(new FlutterMethodCall(call), new FlutterResult(result), getLabelCaptureModule());
            if (!executionResult) {
                String methodName = call.argument("methodName");
                if (methodName == null) {
                    methodName = "unknown";
                }

                result.error("METHOD_NOT_FOUND", "Unknown Core method: " + methodName, null);
            }
            return;
        }
        result.notImplemented();
    }

    private volatile LabelCaptureModule sharedModuleInstance;

    private LabelCaptureModule getLabelCaptureModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (LabelCaptureModule) getModule(LabelCaptureModule.class.getSimpleName());
                }
            }
        }
        return sharedModuleInstance;
    }

    private FrameworkModule getModule(String moduleName) {
        return this.serviceLocator.resolve(moduleName);
    }
}
