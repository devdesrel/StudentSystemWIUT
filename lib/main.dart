import 'package:flutter/material.dart';
import 'helpers/app_constants.dart';
import 'helpers/routes.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    TextTheme _textTheme = TextTheme(
      headline: TextStyle(color: textColor, fontSize: 20.0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      routes: routes,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: primaryColor,
          accentColor: accentColor,
          primaryColorDark: primaryDarkColor,
          iconTheme: IconThemeData(color: accentColor),
          backgroundColor: backgroundColor,
          textSelectionColor: textColor,
          brightness: Brightness.light,
          textTheme: _textTheme),
    );
  }
}
