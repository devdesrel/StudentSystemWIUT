import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/offences/acad_offences_model.dart';
import 'package:student_system_flutter/models/offences/atten_offences_model.dart';
import 'package:student_system_flutter/models/offences/discip_offences_model.dart';
import 'package:http/http.dart' as http;

class OffencesBloc {
  OffencesBloc() {
    parseAcademOffences().then((acadOffenceList) {
      if (acadOffenceList != null || acadOffenceList.length > 0) {
        _academOffencesListSubject.add(acadOffenceList);
      } else {
        return null;
      }
    });
    parseAttenOffences().then((attenOffenceList) {
      if (attenOffenceList != null || attenOffenceList != []) {
        _attendanceOffencesListSubject.add(attenOffenceList);
      } else {
        return null;
      }
    });
    parseDiscipOffences().then((dicipOffenceList) {
      if (dicipOffenceList != null || dicipOffenceList != []) {
        _disciplinaryOffencesListSubject.add(dicipOffenceList);
      } else {
        return null;
      }
    });
  }
//00007460
  Future<List<AcademicOffencesModel>> parseAcademOffences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _userID = prefs.getString(userID);
    try {
      final response = await http.post("$apiAcadOffences?StudentID=$_userID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseAcadOffences(response.body);
      } else {
        print("Academic offences not parsed");
        // showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      print(e);

      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);
      return null;
    }
  }

  List<AcademicOffencesModel> _parseAcadOffences(String responseBody) {
    final parsed = json.decode(responseBody);

    List<AcademicOffencesModel> lists = parsed
        .map<AcademicOffencesModel>(
            (item) => AcademicOffencesModel.fromJson(item))
        .toList();

    return lists;
  }

//00002417
  Future<List<AttendanceOffencesModel>> parseAttenOffences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _userID = prefs.getString(userID);
    try {
      final response = await http
          .post("$apiAttendanceOffences?StudentID=$_userID", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        return _parseAttenOffences(response.body);
      } else {
        print("Attendance offences not parsed");
        // showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      print(e);
      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);
      return null;
    }
  }

  List<AttendanceOffencesModel> _parseAttenOffences(String responseBody) {
    final parsed = json.decode(responseBody);

    List<AttendanceOffencesModel> lists = parsed
        .map<AttendanceOffencesModel>(
            (item) => AttendanceOffencesModel.fromJson(item))
        .toList();

    return lists;
  }

//00007289
  Future<List<DisciplinaryOffencesModel>> parseDiscipOffences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _userID = prefs.getString(userID);
    try {
      final response = await http
          .post("$apiDisciplinaryOffences?StudentID=$_userID", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        return _parseDiscipOffences(response.body);
      } else {
        print("Disciplinary offences not parsed");
        // showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      print(e);

      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);
      return null;
    }
  }

  List<DisciplinaryOffencesModel> _parseDiscipOffences(String responseBody) {
    final parsed = json.decode(responseBody);

    List<DisciplinaryOffencesModel> lists = parsed
        .map<DisciplinaryOffencesModel>(
            (item) => DisciplinaryOffencesModel.fromJson(item))
        .toList();

    return lists;
  }

  Stream<List<AcademicOffencesModel>> get academOffencesList =>
      _academOffencesListSubject.stream;

  final _academOffencesListSubject =
      BehaviorSubject<List<AcademicOffencesModel>>();

  Stream<List<AttendanceOffencesModel>> get attendanceOffencesList =>
      _attendanceOffencesListSubject.stream;

  final _attendanceOffencesListSubject =
      BehaviorSubject<List<AttendanceOffencesModel>>();

  Stream<List<DisciplinaryOffencesModel>> get disciplinaryOffencesList =>
      _disciplinaryOffencesListSubject.stream;

  final _disciplinaryOffencesListSubject =
      BehaviorSubject<List<DisciplinaryOffencesModel>>();

  dispose() {
    _academOffencesListSubject.close();
    _attendanceOffencesListSubject.close();
    _disciplinaryOffencesListSubject.close();
  }
}
//no sink will be created the
//when method gives a result, list will be added to subjectBehavior
//hope this works
