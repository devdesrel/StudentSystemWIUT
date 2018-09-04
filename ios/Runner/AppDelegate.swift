import UIKit
import Flutter



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    
    
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    // let fileOpenerChannel = FlutterMethodChannel.init(name: "com.rtoshmukhamedov.flutter.fileopener",
    //                                                binaryMessenger: controller);


    flutterChannelManager = FlutterChannelManager(flutterViewController: controller)
    flutterChannelManager.setup()

//     fileOpenerChannel.setMethodCallHandler({
//         (call: FlutterMethodCall, result: FlutterResult) -> Void in
//         let filePath = call.arguments as! String;
//         //        NSString *mimeType = call.arguments[@"mimeType"];

//         if ("openFile" == call.method) {
// //
//         } else {
//             result(FlutterMethodNotImplemented);
//         }
        
//     });
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
