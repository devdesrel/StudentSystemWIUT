import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_bloc.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/teacher_attaching_expansiontile.dart';

class CCMAddFeedBackPage extends StatefulWidget {
  final viewType;

  CCMAddFeedBackPage({this.viewType});
  @override
  _CCMAddFeedBackPageState createState() => _CCMAddFeedBackPageState();
}

class _CCMAddFeedBackPageState extends State<CCMAddFeedBackPage> {
  // AnimationController _controller;
  // Animation _animation;

  // FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();

  //   _controller =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  //   _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
  //     ..addListener(() {
  //       setState(() {});
  //     });

  //   _focusNode.addListener(() {
  //     if (_focusNode.hasFocus) {
  //       _controller.forward();
  //     } else {
  //       _controller.reverse();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   _focusNode.dispose();

  //   super.dispose();
  // }

  final GlobalKey<AppExpansionTileState> teacherExpansionTile = new GlobalKey();
  final GlobalKey<AppExpansionTileState> typeExpansionTile = new GlobalKey();
  var formKey = GlobalKey<FormState>();

  String commentMessage;
  double sliderErrorOpacity = 0.0;
  double teacherErrorOpacity = 0.0;
  double _value = 0.0;
  var bloc = CCMFeedbackBloc();

  bool progressDialogVisible = false;

  Future postFeedback() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    try {
      http.Response res = await http.post(apiCCMFeedbackAddFeedback, body: {
        "modelVM": 'something'
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      }); // post api call

      Map data = json.decode(res.body);
      if (res.statusCode == 200) {
        print(data[token]);
      }
    } catch (e) {
      setState(() {
        progressDialogVisible = false;
      });

      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }
  // Future<bool> _onBackPressed(BuildContext context) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var value = prefs.getBool(isLoggedIn);
  //   _focusNode.unfocus();
  //   _focusNode.dispose();
  //   // _focusNode
  //   // FocusScope.of(context).requestFocus(FocusNode());

  //   return value;
  // }

  @override
  Widget build(BuildContext context) {
    String teacherName = 'Select a teacher';
    final List<String> _teacherNamesList = [
      'Vasiliy Kuznetsov',
      'Mikhail Shpirko',
      'Abduvosid Malikov',
      'Aaaaand another guy',
    ];
    final List<String> _typeList = [
      'Positive comments',
      'Suggestions and improvements'
    ];

    bool checkErrors() {
      StreamBuilder(
          stream: bloc.groupCoverageValue,
          builder: (context, snapshot) => _value = snapshot.data);
      StreamBuilder(
          stream: bloc.teacherName,
          builder: (context, snapchot) => teacherName = snapchot.data);

      if (_value == 0.0) {
        return false;
      } else if (teacherName == 'Select a teacher') {
        return false;
      } else {
        return true;
      }
    }

    void saveComment() {
      final form = formKey.currentState;
      bloc.setAutoValidation.add(true);
      bloc.setGroupCoverageDataValidation.add(true);
      bloc.setTeacherNameDatavalidation.add(true);

      FocusScope.of(context).requestFocus(FocusNode());
      checkErrors();
      if (checkErrors()) {
        if (form.validate()) {
          form.save();
          print(commentMessage);
        }
      }
    }

    return CCMFeedbackProvider(
      ccmFeedbackBloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Feedback'),
          centerTitle: true,
        ),
        backgroundColor: backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                    child: Text(
                      'Feedback type',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0, color: accentColor),
                    ),
                  ),
                  StreamBuilder(
                    stream: bloc.feedbackType,
                    initialData: _typeList.first,
                    builder: (context, snapshot) => Card(
                          child: TeacherAttachingExpansionTile(
                              expansionTileType:
                                  ExpansionTileTypes.FeedbackType,
                              bloc: bloc,
                              expansionTile: typeExpansionTile,
                              value: snapshot.hasData
                                  ? snapshot.data
                                  : _typeList.first,
                              expansionChildrenList: _typeList),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                      top: 3.0,
                    ),
                    child: Text(
                      'Feedback',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0, color: accentColor),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    height: 138.0,
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: StreamBuilder(
                        stream: bloc.autoValidation,
                        initialData: false,
                        builder: (context, snapshot) => TextFormField(
                              style: Theme.of(context).textTheme.body2.copyWith(
                                  decorationColor: Colors.white,
                                  fontWeight: FontWeight.normal),
                              autovalidate:
                                  snapshot.hasData ? snapshot.data : false,
                              autofocus: false,
                              maxLines: 7,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  hintText: 'Write here'),
                              validator: (val) {
                                if (val.length == 0 || val == null) {
                                  return 'Comment section cannot be empty';
                                } else {
                                  val = commentMessage;
                                }
                              },
                              onSaved: (val) {
                                commentMessage = val;
                              },
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Group coverage',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16.0, color: accentColor),
                        ),
                        StreamBuilder(
                          stream: bloc.groupCoverageValue,
                          initialData: 0.0,
                          builder: (context, snapshot) => Text(
                                snapshot.hasData
                                    ? '${snapshot.data.round()} %'
                                    : '0 %',
                                style: TextStyle(fontSize: 18.0),
                                textAlign: TextAlign.end,
                              ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: bloc.groupCoverageValue,
                    builder: (context, snapshot) => Card(
                          child: Slider(
                              value: snapshot.hasData
                                  // ? [_value = snapshot.data, snapshot.data]
                                  ? _value = snapshot.data
                                  : 0.0,
                              min: 0.0,
                              max: 100.0,
                              onChanged: (double value) {
                                bloc.setGroupCoverageValue.add(value);
                                // if (value == 0.0) {fl
                                //   bloc.setGroupCoverageError.add(1.0);
                                // } else {
                                //   bloc.setGroupCoverageError.add(0.0);
                                // }
                              }),
                        ),
                  ),
                  StreamBuilder(
                    stream: bloc.groupCoverageValue,
                    initialData: 0.0,
                    builder: (context, snapshot) => StreamBuilder(
                          stream: bloc.groupCoverageDataValidation,
                          builder: (context2, shot) => Opacity(
                                opacity: shot.data == true
                                    ? snapshot.data > 0.0 ? 0.0 : 1.0
                                    : 0.0,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Group coverage is not indicated',
                                    style: TextStyle(
                                        color: redColor, fontSize: 12.0),
                                  ),
                                ),
                              ),
                        ),
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 3.0),
                    child: Text(
                      'Teacher',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.0, color: accentColor),
                    ),
                  ),
                  Card(
                    child: StreamBuilder(
                      initialData: 'Select a teacher',
                      stream: bloc.teacherName,
                      builder: (context, snapshot) =>
                          TeacherAttachingExpansionTile(
                              expansionTileType: ExpansionTileTypes.TeacherName,
                              bloc: bloc,
                              expansionTile: teacherExpansionTile,
                              value: snapshot.hasData
                                  ? snapshot.data
                                  : teacherName,
                              expansionChildrenList: _teacherNamesList),
                    ),
                  ),
                  StreamBuilder(
                    stream: bloc.teacherName,
                    initialData: 'Select a teacher',
                    builder: (context, snapshot) => StreamBuilder(
                          stream: bloc.teacherNameDataValidation,
                          builder: (context, shot) => Opacity(
                                opacity: shot.data == true
                                    ? snapshot.data != 'Select a teacher'
                                        ? 0.0
                                        : 1.0
                                    : 0.0,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Teacher is not chosen',
                                    style: TextStyle(
                                        color: redColor, fontSize: 12.0),
                                  ),
                                ),
                              ),
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 8.0, bottom: 8.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      color: accentColor,
                      onPressed: saveComment,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  widget.viewType == FeedbackViewType.Edit
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 8.0, bottom: 8.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            color: accentColor,
                            onPressed: () {},
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
