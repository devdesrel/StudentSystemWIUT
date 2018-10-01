import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';
import 'package:http/http.dart' as http;

class CCMFeedbackItemBloc {
  Stream<String> get memberNames => _memberNamesSubject.stream;

  final _memberNamesSubject = BehaviorSubject<String>();

  Stream<List<CCMFeedbackModel>> get feedbackList =>
      _feedbackListSubject.stream;

  final _feedbackListSubject =
      BehaviorSubject<List<CCMFeedbackModel>>(seedValue: null);

  CCMFeedbackItemBloc(List<CCMFeedbackAsSelectedList> list) {
    categoriesList = list;
  }

  List<CCMFeedbackModel> _lists = [];
  List<CCMFeedbackAsSelectedList> categoriesList = [];

  void sortFeedbackList(bool isPositive) {
    _feedbackListSubject.add(_lists.reversed
        .where((item) => item.isPositive == isPositive)
        .toList());
  }

  void getModuleRepresentatives(String moduleID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      final response = await http.get(
          "$apiCCMFeedbackGetModuleRepresentatives?moduleID=$moduleID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);
        String members = '';
        bool isFirst = true;

        parsed.forEach((k, v) {
          members += isFirst ? k + ': ' + v : '\n\n' + k + ': ' + v;
          isFirst = false;
        });

        members = members.replaceAll('[', '');
        members = members.replaceAll(']', '');

        _memberNamesSubject.add(members);

        // List<CCMFeedbackModel> _lists = parsed
        //     .map<CCMFeedbackModel>((item) => CCMFeedbackModel.fromJson(item))
        //     .toList();

        // _feedbackListSubject.add(_lists);
      } else {
        // _feedbackListSubject.add(null);
      }
    } catch (e) {
      // _feedbackListSubject.add(null);
    }
  }

  void getFeedback(int pageIndex, String type) async {
    String depOrModID = categoriesList[pageIndex].value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      final response = await http.get(
          "$apiCCMFeedbackGetFeedback?type=$type&depOrModID=$depOrModID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

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
    _memberNamesSubject.close();
    _feedbackListSubject.close();
  }
}
