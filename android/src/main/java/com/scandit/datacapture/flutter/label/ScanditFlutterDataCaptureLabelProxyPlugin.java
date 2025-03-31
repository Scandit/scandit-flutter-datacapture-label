/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.label;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.flutter.core.BaseFlutterPlugin;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.label.LabelCaptureModule;

import java.util.concurrent.atomic.AtomicInteger;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

public class ScanditFlutterDataCaptureLabelProxyPlugin extends BaseFlutterPlugin implements FlutterPlugin, ActivityAware {
    private final static FlutterEmitter emitter = new FlutterEmitter(LabelMethodHandler.EVENT_CHANNEL_NAME);

    private static final AtomicInteger activePluginInstances = new AtomicInteger(0);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.incrementAndGet();
        super.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.decrementAndGet();
        super.onDetachedFromEngine(binding);
    }

    @Override
    protected int getActivePluginInstanceCount() {
        return activePluginInstances.get();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        setupEventChannels();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        disposeEventChannels();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        disposeEventChannels();
    }

    @Override
    protected void setupMethodChannels(@NonNull FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        LabelMethodHandler methodHandler = new LabelMethodHandler(serviceLocator);
        MethodChannel channel = new MethodChannel(
                binding.getBinaryMessenger(),
                LabelMethodHandler.METHOD_CHANNEL_NAME
        );
        channel.setMethodCallHandler(methodHandler);
        registerChannel(channel);
    }

    @Override
    protected void setupModules(@NonNull FlutterPluginBinding binding) {
        LabelCaptureModule labelCaptureModule = resolveModule(LabelCaptureModule.class);
        if (labelCaptureModule != null) return;

        labelCaptureModule = LabelCaptureModule.create(emitter);
        labelCaptureModule.onCreate(binding.getApplicationContext());
        registerModule(labelCaptureModule);
    }

    private void setupEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            emitter.addChannel(binding.getBinaryMessenger());
        }
    }

    private void disposeEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            emitter.removeChannel(binding.getBinaryMessenger());
        }
    }

    @VisibleForTesting
    public static void resetActiveInstances() {
        activePluginInstances.set(0);
    }
}
