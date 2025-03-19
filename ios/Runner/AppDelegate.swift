import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let deviceInfoChannel = FlutterMethodChannel(name: "device_info_channel",
                                              binaryMessenger: controller.binaryMessenger)

    deviceInfoChannel.setMethodCallHandler { (call, result) in
      if call.method == "getBatteryLevel" {
        result(self.getBatteryLevel())
      } else if call.method == "getOSVersion" {
        result(self.getOSVersion())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
     GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getBatteryLevel() -> Int {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
    return batteryLevel >= 0 ? batteryLevel : -1
  }

  private func getOSVersion() -> String {
    return "iOS \(UIDevice.current.systemVersion)"
  }
}
