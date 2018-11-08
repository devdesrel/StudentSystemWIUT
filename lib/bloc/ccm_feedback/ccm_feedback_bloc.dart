import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:http/http.dart' as http;

class CCMFeedbackBloc {
  Stream<List<CCMFeedbackAsSelectedList>> get feedbackCategoriesList =>
      _feedbackCategoriesListSubject.stream;

  final _feedbackCategoriesListSubject =
      BehaviorSubject<List<CCMFeedbackAsSelectedList>>(seedValue: null);

  Stream<bool> get isFeedbackEditable => _isFeedbackEditableSubject.stream;

  final _isFeedbackEditableSubject = BehaviorSubject<bool>(seedValue: false);

  String _type = 'modules';
  String groupID;
  int currentPageIndex = 0;
  List<CCMFeedbackAsSelectedList> _categoriesList = [];

  CCMFeedbackBloc(BuildContext context, String requestType, String groupID) {
    _type = requestType;
    this.groupID = groupID;
    _getCategorySelectionList(context);
  }

  void dispose() {
    _feedbackCategoriesListSubject.close();
    _isFeedbackEditableSubject.close();
  }

  void _getCategorySelectionList(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      final response = await http.get(
          groupID == null
              ? "$apiCCMFeedbackGetCategoriesSelectionList?type=$_type"
              : "$apiCCMFeedbackGetCategoriesSelectionList?type=$_type&groupID=$groupID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        _isFeedbackEditableSubject.add(parsed['feedbackIsEditable']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(feedbackIsEditable, parsed['feedbackIsEditable']);

        _categoriesList = parsed['categories']
            .map<CCMFeedbackAsSelectedList>(
                (item) => CCMFeedbackAsSelectedList.fromJson(item))
            .toList();

        _feedbackCategoriesListSubject.add(_categoriesList);
      } else {
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        _feedbackCategoriesListSubject.add(null);
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
      _feedbackCategoriesListSubject.add(null);
    }
  }
}
