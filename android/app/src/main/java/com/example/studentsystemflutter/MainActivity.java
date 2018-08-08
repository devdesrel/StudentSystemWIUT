package com.example.studentsystemflutter;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.content.FileProvider;
import android.webkit.MimeTypeMap;

import java.io.File;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
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
                if (methodCall.method.equals("openFile")) {
                   openFile((String) arguments.get("filePath"), (String) arguments.get("mimeType"));
                }
            }
      });
  }

  private void openFile(String filePath, String mimeType){
      File file = new File(filePath);
//      MimeTypeMap map = MimeTypeMap.getSingleton();
//      String ext = MimeTypeMap.getFileExtensionFromUrl(file.getName());
//      String mimeType = map.getMimeTypeFromExtension(ext);

      if (mimeType == null)
          mimeType = "*/*";

      Intent intent = new Intent(Intent.ACTION_VIEW);
       Uri data = FileProvider.getUriForFile(
        MainActivity.this, 
        BuildConfig.APPLICATION_ID + ".com.example.studentsystemflutter.provider", file);

        intent.setDataAndType(data, mimeType);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

      startActivity(intent);
  }
}
