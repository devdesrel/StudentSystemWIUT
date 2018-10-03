import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_add_feedback_page_model.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';

class CCMAddFeedbackBloc {
  double groupCoverage = 0.0;
  String teacherName = '';
  bool isPositive = true;
  String feedbackCategory;
  String staffID;
  int depOrModID;
  CCMAddFeedbackPageModel model;
  BuildContext context;
  String commentMessage;

  //sending
  Sink<CCMFeedbackAsSelectedList> get setTeacherName =>
      _setTeacherNameController.sink;

  final _setTeacherNameController =
      StreamController<CCMFeedbackAsSelectedList>();

  Sink<bool> get setAutoValidation => _setAutoValidationController.sink;

  final _setAutoValidationController = StreamController<bool>();

  Sink<double> get setGroupCoverageValue =>
      _setGroupCoverageValueController.sink;

  final _setGroupCoverageValueController = StreamController<double>();

  Sink<bool> get setGroupCoverageDataValidation =>
      _setGroupCoverageDataValidationController.sink;

  final _setGroupCoverageDataValidationController = StreamController<bool>();

  Sink<bool> get setTeacherNameDatavalidation =>
      _setTeacherNameDataValidationController.sink;

  final _setTeacherNameDataValidationController = StreamController<bool>();

  Sink<String> get setFeedbackType => _setFeedbackTypeController.sink;

  final _setFeedbackTypeController = StreamController<String>();

  //receiving
  Stream<String> get teacherNameValue => _teacherNameValueSubject.stream;

  final _teacherNameValueSubject = BehaviorSubject<String>();

  Stream<double> get groupCoverageValue => _groupCoverageValueSubject.stream;

  final _groupCoverageValueSubject = BehaviorSubject<double>();

  Stream<bool> get autoValidation => _autoValidationSubject.stream;

  final _autoValidationSubject = BehaviorSubject<bool>();

  Stream<bool> get groupCoverageDataValidation =>
      _groupCoverageDataValidationSubject.stream;

  final _groupCoverageDataValidationSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<bool> get teacherNameDataValidation =>
      _teacherNameDataValidationSubject.stream;

  final _teacherNameDataValidationSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<String> get feedbackType => _feedbackTypeSubject.stream;

  final _feedbackTypeSubject = BehaviorSubject<String>();

  CCMAddFeedbackBloc(BuildContext context, CCMAddFeedbackPageModel model) {
    this.context = context;
    this.model = model;

    feedbackCategory = model.depOrMod == CCMFeedbackCategory.ModulesFeedback
        ? 'modules'
        : 'departments';
    isPositive = model.feedbackType == 0 ? true : false;

    _setTeacherNameController.stream.listen((_teacherName) {
      _teacherNameValueSubject.add(_teacherName.text);
      staffID = _teacherName.value;
    });

    _setGroupCoverageValueController.stream.listen((_groupCoverageValue) {
      _groupCoverageValueSubject.add(_groupCoverageValue);
    });

    _setGroupCoverageDataValidationController.stream
        .listen((_groupCoverageDataValidation) {
      _groupCoverageDataValidationSubject.add(_groupCoverageDataValidation);
    });

    _setTeacherNameDataValidationController.stream
        .listen((_teacherNameDataVAlidation) {
      _teacherNameDataValidationSubject.add(_teacherNameDataVAlidation);
    });

    _setAutoValidationController.stream.listen((autoValidationValue) {
      _autoValidationSubject.add(autoValidationValue);
    });

    _setFeedbackTypeController.stream.listen((_feedbackType) {
      _feedbackTypeSubject.add(_feedbackType);
      if (_feedbackType == 'Positive comments') {
        isPositive = true;
      } else {
        isPositive = false;
      }
    });
  }

  Future<List<CCMFeedbackAsSelectedList>> getModuleRepresentatives() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    int modID = model.depOrModID;

    if (model.depOrMod == CCMFeedbackCategory.ModulesFeedback) {
      try {
        final response = await http.get(
            "$apiCCMFeedbackGetModuleRepresentativesAsSelectList?moduleID=$modID",
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $_token"
            });

        if (response.statusCode == 200) {
          return _parseModuleRepresentatives(response.body);
        } else {
          showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
          return null;
        }
      } catch (e) {
        showFlushBar(connectionFailure, checkInternetConnection,
            MessageTypes.ERROR, context, 2);
        return null;
      }
    }
    return null;
  }

  List<CCMFeedbackAsSelectedList> _parseModuleRepresentatives(
      String responseBody) {
    final parsed = json.decode(responseBody);

    List<CCMFeedbackAsSelectedList> lists = parsed
        .map<CCMFeedbackAsSelectedList>(
            (item) => CCMFeedbackAsSelectedList.fromJson(item))
        .toList();

    return lists;
  }

  void postFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    String postJson;

    if (feedbackCategory == 'modules') {
      postJson =
          '{"Type": "$feedbackCategory", "IsPositive": $isPositive, "DepOrModID": ${model.depOrModID}, "StaffID": ${int.tryParse(staffID)}, "GroupCoverage": ${groupCoverage.toInt()}, "Text": "$commentMessage"}';
    } else {
      postJson =
          '{"Type": "$feedbackCategory", "IsPositive": $isPositive, "DepOrModID": ${model.depOrModID}, "GroupCoverage": ${groupCoverage.toInt()}, "Text": "$commentMessage"}';
    }

    // print(postData.toString());
    try {
      http.Response res = await http.post(apiCCMFeedbackAddFeedback,
          body: postJson,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          }); // post api call

      if (res.statusCode == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }

  void editFeedback(int feedbackID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    String postJson;

    if (feedbackCategory == 'modules') {
      postJson =
          '{"ID": $feedbackID, "Type": "$feedbackCategory", "IsPositive": $isPositive, "DepOrModID": $depOrModID, "StaffID": ${int.parse(staffID)}, "GroupCoverage": ${groupCoverage.toInt()}, "Text": "$commentMessage"}';
    } else {
      postJson =
          '{"ID": $feedbackID, "Type": "$feedbackCategory", "IsPositive": $isPositive, "DepOrModID": $depOrModID, "GroupCoverage": ${groupCoverage.toInt()}, "Text": "$commentMessage"}';
    }
    // print(postData.toString());
    try {
      http.Response res = await http.post(apiCCMFeedbackEditFeedback,
          body: postJson,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $_token"
          }); // post api call

      if (res.statusCode == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }

  void deleteFeedback(CCMFeedbackModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      http.Response res = await http.delete(
          '$apiCCMFeedbackDeleteFeedback?type=${model.type}&id=${model.id}',
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          }); // post api call

      if (res.statusCode == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }

  void dispose() {
    _setTeacherNameController.close();

    _setAutoValidationController.close();
    _setGroupCoverageValueController.close();
    _setGroupCoverageDataValidationController.close();
    _setTeacherNameDataValidationController.close();
    _setFeedbackTypeController.close();

    _teacherNameValueSubject.close();
    _autoValidationSubject.close();
    _groupCoverageValueSubject.close();
    _groupCoverageDataValidationSubject.cast();
    _teacherNameDataValidationSubject.close();
    _feedbackTypeSubject.close();
  }
}
