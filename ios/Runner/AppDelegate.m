#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate


//- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller2;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

    FlutterMethodChannel* channel = [FlutterMethodChannel
                                            methodChannelWithName:@"com.rtoshmukhamedov.flutter.fileopener"
                                            binaryMessenger:controller];

    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSString *filePath = call.arguments[@"filePath"];
//        NSString *mimeType = call.arguments[@"mimeType"];
        
        if([@"openFile" isEqualToString:call.method]){
//            NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Your PDF Name" withExtension:@"pdf"];
            NSURL *url = [NSURL fileURLWithPath:[filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            
            UIDocumentInteractionController *documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:url];
              documentInteractionController.delegate = self.window.rootViewController;
            [documentInteractionController presentPreviewAnimated:YES];
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
