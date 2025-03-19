import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  static const platform = MethodChannel('device_info_channel');

  final ValueNotifier<int> _batteryLevel = ValueNotifier<int>(0);
  final ValueNotifier<String> _osVersion = ValueNotifier<String>("Unknown");

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      _batteryLevel.value = result;
    } on PlatformException catch (e) {
      _batteryLevel.value = -1;
      log("Failed to get battery level: '${e.message}'.");
    }
  }

  Future<void> _getOSVersion() async {
    try {
      final String result = await platform.invokeMethod('getOSVersion');
      _osVersion.value = result;
    } on PlatformException catch (e) {
      _osVersion.value = "Failed to get OS version: '${e.message}'";
    }
  }

  @override
  void initState() {
    _enableScreenGuard();
    super.initState();
  }

  @override
  void dispose() {
    _disableScreenGuard();
    _batteryLevel.dispose();
    _osVersion.dispose();
    super.dispose();
  }

  Future<void> _enableScreenGuard() async {
    try {
      platform.invokeMethod('enableScreenGuard');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to enable screen guard: $e');
      }
    }
  }

  Future<void> _disableScreenGuard() async {
    try {
      platform.invokeMethod('disableScreenGuard');
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to disable screen guard: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Device Info')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _batteryLevel,
              builder: (context, value, child) {
                return Text('Battery Level: $value%', style: const TextStyle(fontSize: 20));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _getBatteryLevel, child: const Text('Get Battery Level')),
            const SizedBox(height: 30),
            ValueListenableBuilder<String>(
              valueListenable: _osVersion,
              builder: (context, value, child) {
                return Text('OS Version: $value', style: const TextStyle(fontSize: 20));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _getOSVersion, child: const Text('Get OS Version')),
          ],
        ),
      ),
    );
  }
}
