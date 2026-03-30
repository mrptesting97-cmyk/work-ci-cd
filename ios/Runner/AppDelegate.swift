// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     let controller = window?.rootViewController as! FlutterViewController
//     let channel = FlutterMethodChannel(
//       name: "app.icon",
//       binaryMessenger: controller.binaryMessenger
//     )
    
//     channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
//       switch call.method {
//       case "setLauncherIcon":
//         if let args = call.arguments as? [String: Any],
//            let iconName = args["icon"] as? String {
//           self.setAppIcon(iconName, result: result)
//         } else {
//           result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
//         }
//       default:
//         result(FlutterMethodNotImplemented)
//       }
//     }
    
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
  
//   private func setAppIcon(_ iconName: String, result: @escaping FlutterResult) {
//     let validIcons = ["DefaultIcon", "IconOne", "IconTwo"]
    
//     guard validIcons.contains(iconName) else {
//       result(FlutterError(code: "INVALID_ICON", message: "Invalid icon name: \(iconName)", details: nil))
//       return
//     }
    
//     // For default icon, pass nil to setAlternateIconName
//     let iconNameForSystem: String? = iconName == "DefaultIcon" ? nil : iconName
    
//     // Perform UI-related API calls on the main thread
//     DispatchQueue.main.async {
//       // Check if the icon change is supported on this device/iOS version
//       guard UIApplication.shared.supportsAlternateIcons else {
//         result(FlutterError(code: "NOT_SUPPORTED", message: "Alternate icons not supported on this device", details: nil))
//         return
//       }

//       UIApplication.shared.setAlternateIconName(iconNameForSystem) { error in
//         if let error = error {
//           result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
//         } else {
//           result(true)
//         }
//       }
//     }
//   }
// }
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Register plugins FIRST
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "app.icon",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "setLauncherIcon":
        if let args = call.arguments as? [String: Any],
           let iconName = args["icon"] as? String {
          self.setAppIcon(iconName, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setAppIcon(_ iconName: String, result: @escaping FlutterResult) {
    let validIcons = ["DefaultIcon", "IconOne", "IconTwo"]

    guard validIcons.contains(iconName) else {
      result(FlutterError(code: "INVALID_ICON", message: "Invalid icon name: \(iconName)", details: nil))
      return
    }

    // nil = reset to default app icon
    let iconNameForSystem: String? = iconName == "DefaultIcon" ? nil : iconName

    DispatchQueue.main.async {
      guard UIApplication.shared.supportsAlternateIcons else {
        result(FlutterError(code: "NOT_SUPPORTED", message: "Alternate icons not supported on this device", details: nil))
        return
      }

      UIApplication.shared.setAlternateIconName(iconNameForSystem) { error in
        if let error = error {
          result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
        } else {
          result(true)
        }
      }
    }
  }
}
