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
  // Sink<bool> get setIsPositive => _setIsPositiveController.sink;

  // final _setIsPositiveController = StreamController<bool>();

  // Stream<bool> get isPositive => _isPositiveSubject.stream;

  // final _isPositiveSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<List<CCMFeedbackAsSelectedList>> get feedbackCategoriesList =>
      _feedbackCategoriesListSubject.stream;

  final _feedbackCategoriesListSubject =
      BehaviorSubject<List<CCMFeedbackAsSelectedList>>(seedValue: null);

  // Stream<List<CCMFeedbackModel>> get feedbackList =>
  //     _feedbackListSubject.stream;

  // final _feedbackListSubject =
  //     BehaviorSubject<List<CCMFeedbackModel>>(seedValue: null);

  // Stream<String> get memberNames => _memberNamesSubject.stream;

  // final _memberNamesSubject = BehaviorSubject<String>();

  // int feedbackType = 0;
  String _type = 'modules';
  String groupID;
  // int depOrModID = 0;
  int currentPageIndex = 0;
  List<CCMFeedbackAsSelectedList> _categoriesList = [];

  CCMFeedbackBloc(BuildContext context, String requestType, String groupID) {
    _type = requestType;
    this.groupID = groupID;
    _getCategorySelectionList(context);

    // _setIsPositiveController.stream.listen((_value) {
    //   _isPositiveSubject.add(_value);
    //   feedbackType = _value ? 0 : 1;
    // });
  }

  void dispose() {
    // _setIsPositiveController.close();
    // _isPositiveSubject.close();
    _feedbackCategoriesListSubject.close();
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
  //       parsed.forEach((k, v) => members += '${k}: ${v}\n');

  //       // members.replaceAll(RegExp(r'['), '');
  //       // members.replaceAll(RegExp(r']'), '');

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

  // void sortFeedbackList(bool isPositive) {
  //   _feedbackListSubject
  //       .add(_lists.where((item) => item.isPositive == isPositive).toList());
  // }

  // void getFeedback(int pageIndex) async {
  //   String depOrModID = categoriesList[pageIndex].value;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final _token = prefs.getString(token);

  //   try {
  //     final response = await http.get(
  //         "$apiCCMFeedbackGetFeedback?type=$_type&depOrModID=$depOrModID",
  //         headers: {
  //           "Accept": "application/json",
  //           "Authorization": "Bearer $_token"
  //         });

  //     if (response.statusCode == 200) {
  //       final parsed = json.decode(response.body);

  //       _lists = parsed
  //           .map<CCMFeedbackModel>((item) => CCMFeedbackModel.fromJson(item))
  //           .toList();

  //       _feedbackListSubject
  //           .add(_lists.where((item) => item.isPositive).toList());
  //     } else {
  //       _feedbackListSubject.add(null);
  //     }
  //   } catch (e) {
  //     _feedbackListSubject.add(null);
  //   }
  // }

}
