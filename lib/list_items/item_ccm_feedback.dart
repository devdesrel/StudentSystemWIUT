import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_item_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_add_feedback_page_model.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';
import 'package:student_system_flutter/models/actions_taken_model.dart';
import 'package:student_system_flutter/pages/ccm_add_feedback_page.dart';

class ItemCCMFeedback extends StatelessWidget {
  final CCMFeedbackModel feedbackModel;
  final CCMFeedbackItemBloc bloc;
  final CCMFeedbackCategory requestType;

  ItemCCMFeedback(
      {@required this.feedbackModel,
      @required this.bloc,
      @required this.requestType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomCard(Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(8.0),
                  color: greyColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'To ${feedbackModel.staffFullName}',
                        style: TextStyle(color: Colors.white),
                      ),
                      feedbackModel.isRepliable
                          ? InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ccmAddFeedbackPage);
                              },
                              child: Text(
                                'Reply',
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      getSharedPrefData().then((val) => val
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CCMAddFeedBackPage(
                                  model: CCMAddFeedbackPageModel(
                                      feedback: feedbackModel,
                                      viewType: FeedbackViewType.Edit,
                                      depOrMod: requestType,
                                      depOrModID: bloc.depOrModID,
                                      feedbackType: bloc.feedbackType))))
                          : null);
                    },
                    child: DrawFeedbackCardBody(
                      groupCoverage: feedbackModel.groupCoverage,
                      feedback: feedbackModel.text,
                    )),
                Container(
                    margin: EdgeInsets.all(0.0),
                    padding: EdgeInsets.all(8.0),
                    color: CupertinoColors.lightBackgroundGray,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('From ${feedbackModel.groupName}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0)),
                        Text(feedbackModel.dateCreatedStr,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0)),
                      ],
                    )),
              ])),
          feedbackModel.comments.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 40.0),
                  child: Text(
                    'Actions Taken',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                        fontSize: 16.0),
                  ),
                )
              : Container(),
          SizedBox(
            height: 300.0,
            child: ListView.builder(
                itemCount: feedbackModel.comments.length ?? 0,
                itemBuilder: (c, i) => ItemCCMFeedbackComment(
                      actionTakenModel: feedbackModel.comments[i],
                    )),
          )
        ],
      ),
    );
  }
}

class DrawFeedbackCardBody extends StatelessWidget {
  final int groupCoverage;
  final String feedback;

  DrawFeedbackCardBody(
      {Key key, @required this.groupCoverage, @required this.feedback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Group coverage:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5.0),
              Text('$groupCoverage%', textAlign: TextAlign.left),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(feedback),
        ),
      ],
    );
  }
}

class ItemCCMFeedbackComment extends StatelessWidget {
  final ActionsTakenModel actionTakenModel;

  ItemCCMFeedbackComment({@required this.actionTakenModel});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35.0),
      child: CustomCard(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(actionTakenModel.text),
          ),
          Container(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(8.0),
              color: CupertinoColors.lightBackgroundGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('From ${actionTakenModel.creator}',
                      style: TextStyle(color: Colors.black, fontSize: 12.0)),
                  Text(actionTakenModel.dateCreatedStr,
                      style: TextStyle(color: Colors.black, fontSize: 12.0)),
                ],
              ))
        ],
      )),
    );
  }
}
