import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class SettingsBloc {
  SharedPreferences prefs;

  ///[Streams] receiving
  Stream<bool> get switchtileValue => _switchtileValueSubject.stream;

  final _switchtileValueSubject = BehaviorSubject<bool>();

  Stream<bool> get pinDataValidity => _pinDataValiditySubject.stream;

  final _pinDataValiditySubject = BehaviorSubject<bool>();

  /// [Sinks] sending
  Sink<bool> get setSwitchtileValue => _setSwitchtileValueController.sink;

  final _setSwitchtileValueController = StreamController<bool>();
  Sink<bool> get setPinDataValidity => _setPinDataValidityController.sink;

  final _setPinDataValidityController = StreamController<bool>();

  SettingsBloc() {
    // getting Switchtile value from Sharedpreferences
    getSwitchtileValue();

    _setSwitchtileValueController.stream.listen((switchtileValue) {
      // setting new Switchtile value to Sharedpreferences
      setSwitchValue(switchtileValue);
      _switchtileValueSubject.add(switchtileValue);
    });
    _setPinDataValidityController.stream.listen((dataValidity) {
      _pinDataValiditySubject.add(dataValidity);
    });
  }
  setSwitchValue(bool switchValue) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(useFingerprint, switchValue);
  }

  getSwitchtileValue() async {
    prefs = await SharedPreferences.getInstance();
    var _switchValue = prefs.getBool(useFingerprint) ?? true;
    _switchtileValueSubject.add(_switchValue);
    return _switchValue;
  }

  void dispose() {
    _switchtileValueSubject.close();
    _setSwitchtileValueController.close();
    _pinDataValiditySubject.close();
    _setPinDataValidityController.close();
  }
}
