import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';

import 'app_constants.dart';

void showSnackBar(String text, GlobalKey<ScaffoldState> scaffoldKey,
    [int duration = 2, bool isSuccessful = false]) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: isSuccessful ? greenColor : redColor,
    content: Text(text),
    duration: Duration(seconds: duration),
  ));
}

void showFlushBar(
    String title, String message, MessageTypes type, BuildContext context,
    [int duration = 0]) {
  switch (type) {
    case MessageTypes.INFO:
      Flushbar()
        ..title = title
        ..icon = Icon(
          Icons.info,
          color: Colors.white,
        )
        ..message = message
        ..backgroundColor = greyColor
        ..shadowColor = Colors.red[800]
        ..duration = Duration(seconds: duration)
        ..show(context);
      break;
    case MessageTypes.ERROR:
      Flushbar()
        ..title = title
        ..icon = Icon(
          Icons.error,
          color: Colors.white,
        )
        ..message = message
        ..backgroundColor = redColor
        ..shadowColor = Colors.red[800]
        ..duration = Duration(seconds: duration)
        ..show(context);
      break;
    case MessageTypes.SUCCESS:
      Flushbar()
        ..title = title
        ..icon = Icon(
          Icons.check_circle,
          color: Colors.white,
        )
        ..message = message
        ..backgroundColor = greenColor
        ..shadowColor = Colors.red[800]
        ..duration = Duration(seconds: duration)
        ..show(context);
      break;
    case MessageTypes.INFINITE_INFO:
      Flushbar()
        ..icon = Icon(
          Icons.info,
          color: Colors.white,
        )
        ..title = title
        ..message = message
        ..backgroundColor = greyColor
        ..shadowColor = Colors.red[800]
        ..show(context);
      break;
    default:
  }
}

Future<File> getImage(bool isFromCamera) async {
  return await ImagePicker.pickImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery);
}

//Sign out Dialog
Future<Null> showSignOutDialog(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Sign out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Do you want to sign out from the system?'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'.toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop();
              _cleanUserData();
              Navigator.of(context).pushReplacementNamed(loginPage);
            },
          ),
          FlatButton(
            child: Text('No'.toUpperCase()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//Remove local User data from Storage
void _cleanUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(token, "");
  await prefs.setString(studentID, "");
  await prefs.setString(firstName, "");
  await prefs.setString(lastName, "");
  await prefs.setString(groupID, "");
  await prefs.setBool(isLoggedIn, false);
}
