package uz.wiut.flutterstudentsystems;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.rtoshmukhamedov.flutter.outlookappopener";
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                final Map<String, Object> arguments = methodCall.arguments();
                if (methodCall.method.equals("openOutlookApp")) {
                    String packageName = "com.microsoft.office.outlook";
                    Intent launchIntent = getPackageManager().getLaunchIntentForPackage(packageName);

                    if (launchIntent != null) {
                        startActivity(launchIntent);
                    } else {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + packageName)));
                    }
                }
            }
      });
  }
}
