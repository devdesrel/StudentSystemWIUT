import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';

void showSnackBar(String text, GlobalKey<ScaffoldState> scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    backgroundColor: redColor,
    content: Text(text),
    duration: Duration(seconds: 2),
  ));
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
  await prefs.setBool(isLoggedIn, false);
}
