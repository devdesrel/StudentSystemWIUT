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
    let outlookOpenerChannel = FlutterMethodChannel.init(name: "com.rtoshmukhamedov.flutter.outlookappopener",
                                                   binaryMessenger: controller);

     outlookOpenerChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if ("openOutlookApp" == call.method) {
          let packageName = "com.microsoft.Office.Outlook";
          Intent launchIntent = getPackageManager().getLaunchIntentForPackage(packageName);

          if (launchIntent != null) {
              result.success(true);
              startActivity(launchIntent);
          } else {
              result.success(false);
//                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + packageName)));
          }
        } else {
          result(FlutterMethodNotImplemented);
        }
    });
                                                  


    // flutterChannelManager = FlutterChannelManager(flutterViewController: controller)
    // flutterChannelManager.setup()


    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
