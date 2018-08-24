import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text('Support'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'If you have faced technical problems or suggest improvements, feel free to contact IT-support',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    ),
                    color: accentColor,
                    onPressed: () {
                      launchURL('https://t.me/wiutintranetsupport', false);
                    },
                    child: Text(
                      'Contact',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        : CupertinoPageScaffold(
            backgroundColor: backgroundColor,
            navigationBar: CupertinoNavigationBar(
              middle: Text('Support'),
            ),
            child: Material(
              child: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Container(
                            // margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'If you have faced technical problems or suggest improvements, feel free to contact IT-support',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0, color: lightGreyTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                        ),
                        // elevation: 8.0,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        // ),
                        color: accentColor,
                        onPressed: () {
                          launchURL('https://t.me/wiutintranetsupport', false);
                        },
                        child: Text(
                          'Contact',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
