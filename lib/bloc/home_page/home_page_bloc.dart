import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class HomePageBloc {
  SharedPreferences prefs;

  Stream<bool> get isUnderDevelopmentFeaturesOn =>
      _isUnderDevelopmentFeaturesOnSubject.stream;

  final _isUnderDevelopmentFeaturesOnSubject =
      BehaviorSubject<bool>(seedValue: true);

  Sink<bool> get setUnderDevelopmentFeaturesVisibility =>
      _setUnderDevelopmentFeaturesVisibilityController.sink;

  final _setUnderDevelopmentFeaturesVisibilityController =
      StreamController<bool>();

  Stream<String> get userRoleStream => _userRoleStreamSubject.stream;

  final _userRoleStreamSubject = BehaviorSubject<String>(seedValue: 'staff');

  Sink<String> get setUserRole => _setUserRoleController.sink;

  final _setUserRoleController = StreamController<String>();

  HomePageBloc() {
    getSwitchValue();
    getUserRoleValue();

    _setUnderDevelopmentFeaturesVisibilityController.stream
        .listen((visibility) async {
      // _isUnderDevelopmentFeaturesOnSubject.add(visibility);

      // prefs.setBool(isUnderDevelopmentFeaturesOn, visibility);
      // print(prefs.getBool('isUnderDevelopmentFeaturesOn'));
      setSwitchValue(visibility);

      prefs = await SharedPreferences.getInstance();
      prefs.setBool(isUnderDevelopmentFeaturesInvisible, visibility);
      _isUnderDevelopmentFeaturesOnSubject.add(visibility);
    });
  }

  getSwitchValue() async {
    prefs = await SharedPreferences.getInstance();
    var _switchValue =
        prefs.getBool(isUnderDevelopmentFeaturesInvisible) ?? true;

    _setUnderDevelopmentFeaturesVisibilityController.add(_switchValue);
    // return _switchValue;
  }

  setSwitchValue(bool switchValue) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(isUnderDevelopmentFeaturesInvisible, switchValue);

    _isUnderDevelopmentFeaturesOnSubject.add(switchValue);
  }

  getUserRoleValue() async {
    prefs = await SharedPreferences.getInstance();
    var _userRole = prefs.getString(userRole) ?? "staff";
    _userRoleStreamSubject.add(_userRole);
  }

  dispose() {
    _isUnderDevelopmentFeaturesOnSubject.close();
    _setUnderDevelopmentFeaturesVisibilityController.close();
    _userRoleStreamSubject.close();
    _setUserRoleController.close();
  }
}
