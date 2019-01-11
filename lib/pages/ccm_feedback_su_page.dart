import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_add_feedback_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/pages/ccm_feedback_category_page.dart';

class CCMFeedbackForSUPage extends StatefulWidget {
  @override
  _CCMFeedbackForSUPageState createState() => _CCMFeedbackForSUPageState();
}

class _CCMFeedbackForSUPageState extends State<CCMFeedbackForSUPage> {
  List<CCMFeedbackAsSelectedList> groupList;

  CCMAddFeedbackBloc bloc;

  Future<List<CCMFeedbackAsSelectedList>> getGroupList(
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    try {
      final response = await http.get("$getAllCurrentGroupsAsSelectList",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        groupList = parsed
            .map<CCMFeedbackAsSelectedList>(
                (item) => CCMFeedbackAsSelectedList.fromJson(item))
            .toList();

        // var list = groupList.sort();
        groupList.sort((a, b) {
          return a.text.toLowerCase().compareTo(b.text.toLowerCase());
        });

        return groupList;
        // _feedbackCategoriesListSubject.add(_categoriesList);
      } else {
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
      return null;

      // _feedbackCategoriesListSubject.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('CCM Feedback'),
              centerTitle: true,
            ),
            backgroundColor: backgroundColor,
            body: FutureBuilder(
              future: getGroupList(context),
              builder: (context, snapshot) => snapshot.hasData
                  ? ListView.builder(
                      itemCount: groupList.length,
                      itemBuilder: (context, i) => Padding(
                            padding: EdgeInsets.only(
                              top: i == 0 || i == groupList.length - 1
                                  ? 5.0
                                  : 2.0,
                              bottom: 2.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CCMFeedbackCategoryPage(
                                            groupID: groupList[i].value)));
                              },
                              child: CustomCard(Center(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(groupList[i].text),
                              ))),
                            ),
                          ))
                  : DrawPlatformCircularIndicator(),
            ))
        : Material(
            child: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('CCM Feedback'),
                ),
                backgroundColor: backgroundColor,
                child: FutureBuilder(
                  //Check
                  future: getGroupList(context),
                  builder: (context, snapshot) => snapshot.hasData
                      ? ListView.builder(
                          itemCount: groupList.length,
                          itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.only(
                                  top: i == 0 || i == groupList.length - 1
                                      ? 5.0
                                      : 2.0,
                                  bottom: 2.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CCMFeedbackCategoryPage(
                                                    groupID:
                                                        groupList[i].value)));
                                  },
                                  child: CustomCard(Center(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(groupList[i].text),
                                  ))),
                                ),
                              ))
                      : DrawPlatformCircularIndicator(),
                )),
          );
  }
}
