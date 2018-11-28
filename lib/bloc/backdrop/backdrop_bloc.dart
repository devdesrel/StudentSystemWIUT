import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/deadlines_model.dart';
import 'package:http/http.dart' as http;

class BackdropBloc {
  bool isBackdropPanelHidden = true;
  bool isDeadlineInfoScreenVisible = true;
  String minute;

  BackdropBloc() {
    getDeadlineInfoValue();
    getDeadlines();
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

  Stream<List<DeadlinesModel>> get deadlineDatesList =>
      _deadlineDatesListSubject.stream;

  final _deadlineDatesListSubject = BehaviorSubject<List<DeadlinesModel>>();

  void dispose() {
    _setBackdropPanelHiddenController.close();
    _backdropPanelHiddenSubject.close();
    _chooseDeadlineModuleController.close();
    _showDeadlineModuleSubject.close();
    _setDeadlineInfoVisibleController.close();
    _isDeadlineInfoVisibleSubject.close();
    _deadlineDatesListSubject.close();
  }

  getDeadlineInfoValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(isDeadlinesListInfoVisible) ?? true;
    _isDeadlineInfoVisibleSubject.add(value);
    isDeadlineInfoScreenVisible = value;
    return value;
  }

  setDeadlineInfoValue(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isDeadlinesListInfoVisible, value);
  }

  List<DeadlinesModel> _parseDeadlines(String responseBody) {
    final parsed = json.decode(responseBody);

    List<DeadlinesModel> lists = parsed
        .map<DeadlinesModel>((item) => DeadlinesModel.fromJson(item))
        .toList();

    _deadlineDatesListSubject.add(lists);

    return lists;
  }

  Future<List<DeadlinesModel>> getDeadlines() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    // final _academYearID = prefs.getInt(academicYearIDSharedPref);
    final _academYear = 19;
    final _userID = prefs.getString(userID);
    // final _isStudent=true;
    final _isStudent = prefs.getString(userRole) == 'student' ? true : false;

    try {
      final response = await http.post(
          "$apiGetCourseworkDeadlinesByModules?AcademicYearID=$_academYear&UserID=$_userID&IsStudent=$_isStudent",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseDeadlines(response.body);
      } else {
        // showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);
      return null;
    }
  }
}
