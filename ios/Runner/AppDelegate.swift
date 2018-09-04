import UIKit
import Flutter



@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  var flutterChannelManager : FlutterChannelManager!
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    
    
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
   


    flutterChannelManager = FlutterChannelManager(flutterViewController: controller)
    flutterChannelManager.setup()


    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
