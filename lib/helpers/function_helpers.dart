import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/models/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_constants.dart';

void getMinimumAppVersion(BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int minVersion = pref.getInt(minAppVersion) ?? 0;

  try {
    final response = await http.get("$apiGetMinAppVersion");

    if (response.statusCode == 200) {
      final version = json.decode(response.body);

      minVersion = version;
      pref.setInt(minAppVersion, version);
    }
  } catch (e) {
    print('Error');
  }

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  int buildNumber = int.parse(packageInfo.buildNumber);

  if (buildNumber < minVersion) {
    Navigator.of(context).pushReplacementNamed(appUpdatesPage);
  }
}

void getStudentsProfile(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString(token);
  final _studentID = prefs.getString(studentID);

  try {
    final response = await http.post("$apiStudentProfile?StudentID=$_studentID",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        });

    if (response.statusCode == 200) {
      final _parsed = json.decode(response.body);

      List<ProfileModel> profile = _parsed
          .map<ProfileModel>((item) => ProfileModel.fromJson(item))
          .toList();

      var currentProfile = profile[profile.length - 1];

      prefs.setString(groupNameSharedPref, currentProfile.groupName);
      prefs.setInt(academicYearIDSharedPref, currentProfile.acadYearIDField);
    }
  } catch (e) {
    print('Error');
  }
}

Color getMarkColor(int moduleMark) {
  if (moduleMark >= 40) {
    return greenColor;
  } else {
    return redColor;
  }
}

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

launchURL(String urlFrom, bool isWebView) async {
  final url = urlFrom;

  if (await canLaunch(url)) {
    if (isWebView != null && isWebView) {
      await launch(url, forceWebView: true);
    } else {
      await launch(url);
    }
  } else {
    throw 'Could not launch $url';
  }
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
  await prefs.setString(groupNameSharedPref, "");
  await prefs.setBool(isLoggedIn, false);
}
