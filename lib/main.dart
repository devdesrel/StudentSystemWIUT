import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry/sentry.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_provider.dart';
import 'package:student_system_flutter/helpers/dsn.dart';
import 'helpers/app_constants.dart';
import 'helpers/routes.dart';

Future<Null> main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<Null>>(() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(MainApp());
    });
  }, onError: (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This will send
    // Dart errors to our dev console or Sentry depending on the environment.
    _reportError(error, stackTrace);
  });
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    TextTheme _textTheme = TextTheme(
      headline: TextStyle(color: textColor, fontSize: 20.0),
    );

    return TimetableProvider(
      child: MaterialApp(
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
          scaffoldBackgroundColor: backgroundColor,
          textSelectionColor: textColor,
          brightness: Brightness.light,
          textTheme: _textTheme,
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: <TargetPlatform, PageTransitionsBuilder>{
          //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          // TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          // TargetPlatform.android: FadeUpwardsTransitionsBuilder(),
          // },
          // ),
        ),
      ),
    );
  }
}

final SentryClient _sentry = SentryClient(dsn: sentryDSN);

bool get isInDebugMode {
  // Assume we're in production mode
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code will only turn `inDebugMode` to true
  // in our development environments!
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console
  print('Caught error: $error');
  if (isInDebugMode) {
    // Print the full stacktrace in debug mode
    print(stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode
    _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}
