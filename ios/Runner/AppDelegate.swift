import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var secureTextField = UITextField()
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
     } else if (call.method == "enableScreenGuard") {
        self.enableScreenGuard()
        result("Secure mode enabled")
      } else if(call.method == "disableScreenGuard") {
        self.disableScreenGuard()
      }
      else {
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

@objc func enableScreenGuard() {
          DispatchQueue.main.async {
              let field = UITextField()
                         self.secureTextField = field 
                         let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))
                         let image = UIImageView(image: UIImage())
                         image.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                         field.isSecureTextEntry = true
                         self.window?.addSubview(field)
                         view.addSubview(image)
                         self.window?.layer.superlayer?.addSublayer(field.layer)
                         field.layer.sublayers?.last?.addSublayer(self.window?.layer ?? CALayer())
                         field.leftView = view
                         field.leftViewMode = .always
          }
      }
 @objc func disableScreenGuard() {
          DispatchQueue.main.async {
              let field = UITextField()
              self.secureTextField = field
              field.isSecureTextEntry = false
              field.removeFromSuperview()
                    if let window = self.window {
                        let rootViewController = window.rootViewController
                        window.rootViewController = nil
                        window.rootViewController = rootViewController
                        window.makeKeyAndVisible()
                    }
          }
      }
}
