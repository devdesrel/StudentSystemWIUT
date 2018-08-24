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
            body: ListView(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'If you have faced technical problems (e.g. Pin code was not changed, no marks or timetable displayed) hit the call button. You will be contacted with IT-support of the current application',
                      style: TextStyle(
                        fontSize: 16.0,
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
                  color: greenColor,
                  onPressed: () {
                    launchURL('tel:+998909276478', false);
                  },
                  child: Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          )
        : CupertinoPageScaffold(
            backgroundColor: backgroundColor,
            navigationBar: CupertinoNavigationBar(
              middle: Text('Support'),
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  // margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'If you have faced technical problems (e.g. Pin code was not changed, no marks or timetable displayed) hit the call button. You will be contacted with IT-support of the current application',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  // elevation: 8.0,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  // ),
                  color: accentColor,
                  onPressed: () {
                    launchURL('tel:+998909276478', false);
                  },
                  child: Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
  }
}
