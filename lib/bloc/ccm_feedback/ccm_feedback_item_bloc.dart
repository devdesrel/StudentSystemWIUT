import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';
import 'package:http/http.dart' as http;

class CCMFeedbackItemBloc {
  Sink<bool> get setIsPositive => _setIsPositiveController.sink;

  final _setIsPositiveController = StreamController<bool>();

  Stream<bool> get isPositive => _isPositiveSubject.stream;

  final _isPositiveSubject = BehaviorSubject<bool>(seedValue: true);

  // Stream<String> get memberNames => _memberNamesSubject.stream;

  // final _memberNamesSubject = BehaviorSubject<String>();

  Stream<List<CCMFeedbackModel>> get feedbackList =>
      _feedbackListSubject.stream;

  final _feedbackListSubject =
      BehaviorSubject<List<CCMFeedbackModel>>(seedValue: null);

  int feedbackType = 0;
  int depOrModID = 0;
  int groupID = 0;

  CCMFeedbackItemBloc(String depOrModID, String groupID) {
    if (depOrModID == null || depOrModID == '') depOrModID = '0';
    if (groupID == null || groupID == '') groupID = '0';

    this.depOrModID = int.parse(depOrModID);
    this.groupID = int.parse(groupID);

    _setIsPositiveController.stream.listen((_value) {
      _isPositiveSubject.add(_value);
      feedbackType = _value ? 0 : 1;
    });
  }

  List<CCMFeedbackModel> _lists = [];
  // List<CCMFeedbackAsSelectedList> categoriesList = [];

  void sortFeedbackList(bool isPositive) {
    _feedbackListSubject.add(_lists.reversed
        .where((item) => item.isPositive == isPositive)
        .toList());
  }

  // void getModuleRepresentatives(String moduleID) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final _token = prefs.getString(token);

  //   try {
  //     final response = await http.get(
  //         "$apiCCMFeedbackGetModuleRepresentatives?moduleID=$moduleID",
  //         headers: {
  //           "Accept": "application/json",
  //           "Authorization": "Bearer $_token"
  //         });

  //     if (response.statusCode == 200) {
  //       final parsed = json.decode(response.body);
  //       String members = '';
  //       bool isFirst = true;

  //       parsed.forEach((k, v) {
  //         members += isFirst ? k + ': ' + v : '\n\n' + k + ': ' + v;
  //         isFirst = false;
  //       });

  //       members = members.replaceAll('[', '');
  //       members = members.replaceAll(']', '');

  //       _memberNamesSubject.add(members);

  //       // List<CCMFeedbackModel> _lists = parsed
  //       //     .map<CCMFeedbackModel>((item) => CCMFeedbackModel.fromJson(item))
  //       //     .toList();

  //       // _feedbackListSubject.add(_lists);
  //     } else {
  //       // _feedbackListSubject.add(null);
  //     }
  //   } catch (e) {
  //     // _feedbackListSubject.add(null);
  //   }
  // }

  void getFeedback(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _userRole = prefs.getString(userRole) ?? 'student';
    Response response;

    try {
      print(depOrModID);

      if (_userRole == 'staff') {
        response = await http.get(
            groupID == 0
                ? "$apiCCMFeedbackGetFeedbackAsStaff?type=$type&depOrModID=0&addressedToMe=true"
                : "$apiCCMFeedbackGetFeedbackAsStaff?type=$type&depOrModID=0&groupID=$groupID&addressedToMe=true",
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $_token"
            });
      } else {
        response = await http.get(
            groupID == 0
                ? "$apiCCMFeedbackGetFeedback?type=$type&depOrModID=$depOrModID"
                : "$apiCCMFeedbackGetFeedback?type=$type&depOrModID=$depOrModID&groupID=$groupID",
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $_token"
            });
      }

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        _lists = parsed
            .map<CCMFeedbackModel>((item) => CCMFeedbackModel.fromJson(item))
            .toList();

        _feedbackListSubject
            .add(_lists.reversed.where((item) => item.isPositive).toList());
      } else {
        _feedbackListSubject.add(null);
      }
    } catch (e) {
      _feedbackListSubject.add(null);
    }
  }

  void dispose() {
    _setIsPositiveController.close();
    _isPositiveSubject.close();
    // _memberNamesSubject.close();
    _feedbackListSubject.close();
  }
}
