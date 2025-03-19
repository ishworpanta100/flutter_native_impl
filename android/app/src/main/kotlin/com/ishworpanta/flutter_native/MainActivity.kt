package com.ishworpanta.flutter_native

import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "device_info_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getBatteryLevel" -> {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                "getOSVersion" -> {
                    val osVersion = getOSVersion()
                    result.success(osVersion)
                }
                "enableScreenGuard"-> {
                  enableScreenGuard()
                    result.success("Secure mode enabled")
                }
                "disableScreenGuard" ->{
                   disableScreenGuard()
                    result.success("Secure mode disabled")
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            -1
        }

    }
    private fun getOSVersion(): String {
        return "Android ${Build.VERSION.RELEASE} (SDK ${Build.VERSION.SDK_INT})"
    }

    private fun enableScreenGuard() {
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }
    private fun disableScreenGuard() {
        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
