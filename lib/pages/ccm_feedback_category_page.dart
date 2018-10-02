import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/pages/ccm_feedback_page.dart';

class CCMFeedbackCategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('CCM Feedback'),
              centerTitle: true,
            ),
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    CustomCard(
                      ListTile(
                        title: Text('Modules'),
                        leading: Icon(FontAwesomeIcons.book),
                        trailing: Icon(CupertinoIcons.right_chevron),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CCMFeedbackPage(
                                  requestType:
                                      CCMFeedbackCategory.ModulesFeedback)));
                        },
                      ),
                    ),
                    CustomCard(
                      ListTile(
                        title: Text('Departments'),
                        trailing: Icon(CupertinoIcons.right_chevron),
                        leading: Icon(FontAwesomeIcons.solidBuilding),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CCMFeedbackPage(
                                  requestType: CCMFeedbackCategory
                                      .DepartmentsFeedback)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Material(
            child: CupertinoPageScaffold(
              backgroundColor: backgroundColor,
              navigationBar: CupertinoNavigationBar(
                middle: Text('CCM Feedback'),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    child: Column(
                      children: <Widget>[
                        CustomCard(
                          ListTile(
                            title: Text('Modules'),
                            leading: Icon(FontAwesomeIcons.book),
                            trailing: Icon(CupertinoIcons.right_chevron),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CCMFeedbackPage(
                                      requestType: CCMFeedbackCategory
                                          .ModulesFeedback)));
                            },
                          ),
                        ),
                        CustomCard(
                          ListTile(
                            title: Text('Departments'),
                            trailing: Icon(CupertinoIcons.right_chevron),
                            leading: Icon(FontAwesomeIcons.solidBuilding),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CCMFeedbackPage(
                                      requestType: CCMFeedbackCategory
                                          .DepartmentsFeedback)));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
