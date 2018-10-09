import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class SettingsBloc {
  SharedPreferences prefs;
  bool switchValue;
  bool securityValue;

  ///[Streams] receiving
  Stream<bool> get switchtileValue => _switchtileValueSubject.stream;

  final _switchtileValueSubject = BehaviorSubject<bool>();

  Stream<bool> get pinDataValidity => _pinDataValiditySubject.stream;

  final _pinDataValiditySubject = BehaviorSubject<bool>();

  Stream<bool> get isAutoValidationOn => _isAutoValidationOnSubject.stream;

  final _isAutoValidationOnSubject = BehaviorSubject<bool>();

  Stream<bool> get isSecurityOn => _isSecurityOnSubject.stream;

  final _isSecurityOnSubject = BehaviorSubject<bool>(seedValue: true);

  /// [Sinks] sending
  Sink<bool> get setSwitchtileValue => _setSwitchtileValueController.sink;

  final _setSwitchtileValueController = StreamController<bool>();
  Sink<bool> get setPinDataValidity => _setPinDataValidityController.sink;

  final _setPinDataValidityController = StreamController<bool>();

  Sink<bool> get setAutoValidation => _setAutoValidationController.sink;

  final _setAutoValidationController = StreamController<bool>();

  Sink<bool> get setSecurityValue => _setSecurityValueController.sink;

  final _setSecurityValueController = StreamController<bool>();

  SettingsBloc() {
    // getting Switchtile value from Sharedpreferences
    getSwitchtileValue();
    getSecurity();

    _setSwitchtileValueController.stream.listen((switchtileValue) {
      // setting new Switchtile value to Sharedpreferences
      setSwitchValue(switchtileValue);
      _switchtileValueSubject.add(switchtileValue);
    });
    _setPinDataValidityController.stream.listen((dataValidity) {
      _pinDataValiditySubject.add(dataValidity);
    });

    _setAutoValidationController.stream.listen((autoValidation) {
      _isAutoValidationOnSubject.add(autoValidation);
    });

    _setSecurityValueController.stream.listen((value) {
      setSecurity(value);
      _isSecurityOnSubject.add(value);
    });
  }
  setSwitchValue(bool switchValue) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(useFingerprint, switchValue);
  }

  setSecurity(bool value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSecurityValueOn, value);
  }

  getSwitchtileValue() async {
    prefs = await SharedPreferences.getInstance();
    switchValue = prefs.getBool(useFingerprint) ?? true;
    _switchtileValueSubject.add(switchValue);
    return switchValue;
  }

  getSecurity() async {
    prefs = await SharedPreferences.getInstance();
    securityValue = prefs.getBool(isSecurityValueOn) ?? true;
    _isSecurityOnSubject.add(securityValue);
    return securityValue;
  }

  void dispose() {
    _switchtileValueSubject.close();
    _setSwitchtileValueController.close();
    _pinDataValiditySubject.close();
    _setPinDataValidityController.close();
    _isAutoValidationOnSubject.close();
    _setAutoValidationController.close();
    _isSecurityOnSubject.close();
    _setSecurityValueController.close();
  }
}
