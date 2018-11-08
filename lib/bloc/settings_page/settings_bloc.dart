import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';

import 'package:student_system_flutter/helpers/app_constants.dart';

class SettingsBloc {
  SharedPreferences prefs;
  bool switchValue;
  bool securityValue;
  String webMailTypeEnum;
  FixedExtentScrollController webMailScrollController =
      FixedExtentScrollController(initialItem: 0);

  ///[Streams] receiving
  Stream<bool> get switchtileValue => _switchtileValueSubject.stream;

  final _switchtileValueSubject = BehaviorSubject<bool>();

  Stream<bool> get pinDataValidity => _pinDataValiditySubject.stream;

  final _pinDataValiditySubject = BehaviorSubject<bool>();

  Stream<bool> get isAutoValidationOn => _isAutoValidationOnSubject.stream;

  final _isAutoValidationOnSubject = BehaviorSubject<bool>();

  Stream<bool> get isSecurityOn => _isSecurityOnSubject.stream;

  final _isSecurityOnSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<String> get webMailType => _webMailTypeSubject.stream;

  final _webMailTypeSubject = BehaviorSubject<String>();
  // Stream<int> get iosWebMailPickerIndex => _iosWebMailPickerIndexSubject.stream;

  // final _iosWebMailPickerIndexSubject = BehaviorSubject<int>();

  /// [Sinks] sending
  Sink<bool> get setSwitchtileValue => _setSwitchtileValueController.sink;

  final _setSwitchtileValueController = StreamController<bool>();
  Sink<bool> get setPinDataValidity => _setPinDataValidityController.sink;

  final _setPinDataValidityController = StreamController<bool>();

  Sink<bool> get setAutoValidation => _setAutoValidationController.sink;

  final _setAutoValidationController = StreamController<bool>();

  Sink<bool> get setSecurityValue => _setSecurityValueController.sink;

  final _setSecurityValueController = StreamController<bool>();

  Sink<String> get setWebMailType => _setWebMailTypeController.sink;

  final _setWebMailTypeController = StreamController<String>();
  Sink<int> get setIosWebMailPickerIndex =>
      _setIosWebMailPickerIndexController.sink;

  final _setIosWebMailPickerIndexController = StreamController<int>();

  SettingsBloc() {
    // getting Switchtile value from Sharedpreferences
    getSwitchtileValue();
    getSecurity();
    getWebMail();

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

    _setWebMailTypeController.stream.listen((type) {
      setWebMail(type);
      _webMailTypeSubject.add(type);
    });
    _setIosWebMailPickerIndexController.stream.listen((index) {
      // _iosWebMailPickerIndexSubject.add(index);
      webMailScrollController = FixedExtentScrollController(initialItem: index);
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

  setWebMail(String webMail) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(webMailTypePrefs, webMail);
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

  getWebMail() async {
    prefs = await SharedPreferences.getInstance();

    webMailTypeEnum =
        prefs.getString(webMailTypePrefs) ?? WebMailType.Outlook.toString();
    webMailTypeEnum == WebMailType.Outlook.toString()
        ? webMailScrollController = FixedExtentScrollController(initialItem: 0)
        : webMailScrollController = FixedExtentScrollController(initialItem: 1);

    _webMailTypeSubject.add(webMailTypeEnum);
    return webMailTypeEnum;
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
    _setWebMailTypeController.close();
    _webMailTypeSubject.close();
    _setIosWebMailPickerIndexController.close();
  }
}
