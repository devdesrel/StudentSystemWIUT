import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class AppUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  height: 45.0,
                ),
                Image.asset(
                  Platform.isAndroid
                      ? 'assets/playmarket.png'
                      : 'assets/appstore.png',
                  height: 60.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Application Update',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    )),
                // Text(
                //   'Version 2.0',
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 15.0,
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Bug fixes, performance enhancements, feature additions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontFamily: 'RalewayRegular'),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                color: Colors.white,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Text(
                  'Upgrade now'.toUpperCase(),
                  style: TextStyle(color: accentColor),
                ),
                onPressed: () {
                  launchURL(
                      Platform.isAndroid ? playStoreUrl : appStoreUrl, false);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Not now'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
