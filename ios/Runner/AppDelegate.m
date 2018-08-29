#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

    FlutterMethodChannel* channel = [FlutterMethodChannel
                                            methodChannelWithName:@"com.rtoshmukhamedov.flutter.fileopener"
                                            binaryMessenger:controller];

    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSString *filePath = call.arguments[@"filePath"];
        NSString *mimeType = call.arguments[@"mimeType"];
        
        if([@"openFile" isEqualToString:call.method]){
          
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
