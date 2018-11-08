import 'dart:async';
import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:http/http.dart' as http;

import 'app_constants.dart';

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(isSecurityValueOn) == null) {
      await prefs.setBool(isSecurityValueOn, true);
    }

    int _lastAppVersion = prefs.getInt(lastAppVersion) ?? 1;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int _buildNumber = int.parse(packageInfo.buildNumber);

    if (_buildNumber > _lastAppVersion) {
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
      await prefs.setBool(feedbackIsEditable, false);
    }

    await prefs.setInt(lastAppVersion, _buildNumber);

    bool _isLoggedIn = prefs.getBool(isLoggedIn) ?? false;
    bool _isPreviewSeen = prefs.getBool(isPreviewSeen) ?? false;

    if (_isPreviewSeen) {
      if (_isLoggedIn)
        _setMainPage();
      else
        notify(AuthState.LOGGED_OUT);
    } else {
      notify(AuthState.SHOW_PREVIEW_PAGE);
    }
  }

  void _setMainPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _tokenExpireDay = prefs.getString(tokenExpireDay);
    var username = prefs.getString(userID);
    var password = prefs.getString(userPasssword);
    var userToken = prefs.getString(token);

    bool _isPinFilled = prefs.getBool(isPinFilled) ?? false;

    DateTime _expirationDate;

    if (_tokenExpireDay != null && _tokenExpireDay != '') {
      _expirationDate = DateTime.tryParse(_tokenExpireDay);
    }

    if (_isPinFilled) {
      if (userToken != null && userToken != '') {
        if (_expirationDate != null &&
            _expirationDate is DateTime &&
            _expirationDate.difference(DateTime.now().toUtc()).inDays <= 0) {
          postAuthData(username, password);
        } else {
          notify(AuthState.LOGGED_IN);
        }
      } else {
        notify(AuthState.LOGGED_OUT);
      }
    } else {
      notify(AuthState.LOGGED_OUT);
    }
  }

  Future postAuthData(String username, String password) async {
    try {
      http.Response res = await http.post(apiAuthenticate,
          body: {"Username": username, "Password": password},
          headers: {"Accept": "application/json"}); // post api call

      print('${res.body}');
      Map data = json.decode(res.body);
      print(data['token']);

      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(token, data['token']);
        await prefs.setString(tokenExpireDay,
            DateTime.now().toUtc().add(Duration(days: 6)).toString());
        await prefs.setString(userID, username);
        await prefs.setString(userPasssword, password);
        await prefs.setBool(isLoggedIn, true);

        getUserProfileForTheCurrentYear();

        notify(AuthState.LOGGED_IN);
      } else
        notify(AuthState.LOGGED_OUT);

      print(authProblems);
    } catch (e) {
      notify(AuthState.LOGGED_OUT);

      print(checkInternetConnection);
    }
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}
