import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
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
    final response = await http.get(Platform.isAndroid
        ? "$apiMinAppVersionByPlatform?isAndroid=true"
        : "$apiMinAppVersionByPlatform?isAndroid=false");

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
    Navigator.of(context).pushNamed(appUpdatesPage);
  }
}

// void getDeadlinesListDetails(BuildContext context) async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   bool isInfoDetailsSeen = pref.getBool(isDeadlinesListInfoSeen) ?? false;

//   if (!isInfoDetailsSeen) {
//     isInfoDetailsSeen = true;
//     pref.setBool(isDeadlinesListInfoSeen, true);

//     Navigator.of(context).pushNamed(deadlinesListInfoPage);
//   }
// }

// void getStudentsProfileForSelectedYear() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final _token = prefs.getString(token);
//   final _studentID = prefs.getString(userID);

//   try {
//     final response = await http.post(
//         "$apiStudentProfileForSelectedAcademicYear?StudentID=$_studentID&AcadYearID=$currentYearID",
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $_token"
//         });

//     if (response.statusCode == 200) {
//       final _parsed = json.decode(response.body);

//       List<ProfileModel> profile = _parsed
//           .map<ProfileModel>((item) => ProfileModel.fromJson(item))
//           .toList();

//       var currentProfile = profile[profile.length - 1];

//       prefs.setString(groupNameSharedPref, currentProfile.groupName);
//       prefs.setInt(academicYearIDSharedPref, currentProfile.acadYearIDField);
//     }
//   } catch (e) {
//     print('Error');
//   }
// }

Future<bool> isCCMFeedbackApplicable() async {
  bool isCCMFeedbackable = await getUserProfileForTheCurrentYear();

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // isCCMFeedbackable = prefs.getBool(isApplicableForCCMFeedback) ?? false;
  return isCCMFeedbackable;
}

Future<bool> getUserProfileForTheCurrentYear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString(token);
  final _userName = prefs.getString(userID);
  final _role = prefs.getString(userRole);

  try {
    if (_role == "student") {
      final response = await http
          .post("$apiStudentProfile?StudentID=$_userName", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        final _parsed = json.decode(response.body);

        List<ProfileModel> profile = _parsed
            .map<ProfileModel>((item) => ProfileModel.fromJson(item))
            .toList();

        if (profile != null && profile.length > 0) {
          var currentProfile = profile[profile.length - 1];

          prefs.setString(groupNameSharedPref, currentProfile.groupName);
          prefs.setInt(
              academicYearIDSharedPref, currentProfile.acadYearIDField);
        }
      }
    }

    final res = await http
        .post("$apiProfileGetProfileByUserName?userName=$_userName", headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    });

    if (res.statusCode == 200) {
      Map data = json.decode(res.body);

      await prefs.setString(firstName, data['FirstName']);
      await prefs.setString(lastName, data['LastName']);
      var teacherFullName =
          prefs.getString(firstName) + " " + prefs.getString(lastName);
      await prefs.setString(teacherNameSharedPref, teacherFullName);
      await prefs.setBool(
          isApplicableForCCMFeedback, data['IsApplicableForCCMFeedback']);

      return data['IsApplicableForCCMFeedback'];
    }
  } catch (e) {
    print('Error');
    return false;
  }
  return false;
}

Color getMarkColor(String moduleMark) {
  if (isNumeric(moduleMark)) {
    if (int.parse(moduleMark) >= 40) {
      return greenColor;
    } else {
      return redColor;
    }
  } else {
    return accentColor;
  }
}

double getMarkInDouble(String moduleMark) {
  if (isNumeric(moduleMark)) {
    return double.parse(moduleMark);
  } else {
    return 0.0;
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  // return double.parse(s, (e) => null) != null;
  return double.tryParse(s) != null;
}

Future<String> openCCMFeedbackPageByRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool val = prefs.getBool(isSU);

  if (val) {
    return ccmFeedbackForSUPage;
  } else {
    String _role = prefs.getString(userRole);
    if (_role == 'student') {
      return ccmCategoryPage;
    } else {
      return ccmRoleSelectPage;
    }
  }
}

Future<bool> checkIsFeedbackEditable() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool val = prefs.getBool(feedbackIsEditable);

  return val;
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
    print('Could not launch $url');
  }
}

//Sign out Dialog
Future<Null> showSignOutDialog(BuildContext context) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      if (Platform.isAndroid) {
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
      } else if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text('Sign out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to sign out from the system?'),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Yes'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                _cleanUserData();
                Navigator.of(context).pushReplacementNamed(loginPage);
              },
            ),
            CupertinoDialogAction(
              child: Text('No'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    },
  );
}

//Remove local User data from Storage
void _cleanUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(token, "");
  await prefs.setString(tokenExpireDay, null);
  await prefs.setString(userID, "");
  await prefs.setString(userPasssword, "");
  await prefs.setString(firstName, "");
  await prefs.setString(lastName, "");
  await prefs.setString(groupID, "");
  await prefs.setString(groupNameSharedPref, "");
  await prefs.setBool(isLoggedIn, false);
  await prefs.setString(userRole, "");
  await prefs.setString(teacherID, "");
  await prefs.setString(teacherNameSharedPref, "");
  await prefs.setBool(isApplicableForCCMFeedback, false);
  await prefs.setBool(isSU, false);
  await prefs.setBool(feedbackIsEditable, false);
}
