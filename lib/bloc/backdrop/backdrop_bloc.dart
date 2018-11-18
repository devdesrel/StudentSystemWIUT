import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/deadlines_model.dart';

class BackdropBloc {
  bool isBackdropPanelHidden = true;
  bool isDeadlineInfoScreenVisible = true;
  String minute;

  BackdropBloc() {
    getDeadlineInfoValue();
    _setBackdropPanelHiddenController.stream.listen((val) {
      _backdropPanelHiddenSubject.add(val);
      isBackdropPanelHidden = val;
    });
    _chooseDeadlineModuleController.stream.listen((mod) {
      if (mod.minute == 0 || mod.minute.toString().length == 1) {
        minute = mod.minute.toString();
        minute = minute.padLeft(2, '0');
      } else {
        minute = mod.minute.toString();
      }
      //  else if (mod.minute.toString().length == 1) {
      //   mod.minute = (mod.minute / 10).round();
      // }

      _showDeadlineModuleSubject.add(mod);
    });

    _setDeadlineInfoVisibleController.stream.listen((val) {
      setDeadlineInfoValue(val);
      _isDeadlineInfoVisibleSubject.add(val);
      isDeadlineInfoScreenVisible = val;
    });
  }
  getDeadlineInfoValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(isDeadlinesListInfoSeen) ?? false;
    _isDeadlineInfoVisibleSubject.add(value);
    isDeadlineInfoScreenVisible = value;
    return value;
  }

  setDeadlineInfoValue(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isDeadlinesListInfoSeen, value);
  }

  Sink<bool> get setBackdropPanelHidden =>
      _setBackdropPanelHiddenController.sink;

  final _setBackdropPanelHiddenController = StreamController<bool>();

  Sink<DeadlinesModel> get chooseDeadlineModule =>
      _chooseDeadlineModuleController.sink;

  final _chooseDeadlineModuleController = StreamController<DeadlinesModel>();

  Sink<bool> get setDeadlineInfoVisible =>
      _setDeadlineInfoVisibleController.sink;

  final _setDeadlineInfoVisibleController = StreamController<bool>();

  Stream<bool> get backdropPanelHidden => _backdropPanelHiddenSubject.stream;

  final _backdropPanelHiddenSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<DeadlinesModel> get showDeadlineModule =>
      _showDeadlineModuleSubject.stream;

  final _showDeadlineModuleSubject = BehaviorSubject<DeadlinesModel>();

  Stream<bool> get isDeadlineInfoVisible =>
      _isDeadlineInfoVisibleSubject.stream;

  final _isDeadlineInfoVisibleSubject = BehaviorSubject<bool>(seedValue: true);

  void dispose() {
    _setBackdropPanelHiddenController.close();
    _backdropPanelHiddenSubject.close();
    _chooseDeadlineModuleController.close();
    _showDeadlineModuleSubject.close();
    _setDeadlineInfoVisibleController.close();
    _isDeadlineInfoVisibleSubject.close();
  }
}
