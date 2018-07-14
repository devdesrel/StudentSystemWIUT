package com.example.studentsystemflutter;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.rtoshmukhamedov.flutter.fileopener";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                final Map<String, Object> arguments = methodCall.arguments();
                if (methodCall.method.equals("getMessage")) {
                   openWebPage("https://flutter.io");
                }
            }
      });

    //    var sendMap = <String, dynamic>{
    //   'filePath': filePath,
    // };

    // try {
    //   await platform.invokeMethod('openFile', sendMap);
  }
}
