import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_add_feedback_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_feedback_type_expansiontile.dart';
import 'package:student_system_flutter/helpers/teacher_attaching_expansiontile.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_add_feedback_page_model.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';

class CCMAddFeedBackPage extends StatefulWidget {
  final CCMAddFeedbackPageModel model;

  CCMAddFeedBackPage({this.model});

  @override
  _CCMAddFeedBackPageState createState() => _CCMAddFeedBackPageState();
}

class _CCMAddFeedBackPageState extends State<CCMAddFeedBackPage> {
  final GlobalKey<AppExpansionTileState> teacherExpansionTile = GlobalKey();
  final GlobalKey<AppExpansionTile2State> typeExpansionTile = GlobalKey();
  var formKey = GlobalKey<FormState>();
  CCMAddFeedbackBloc bloc;
  bool isTextChanged = false;
  String oldText;
  TextEditingController _testController;

  void onChange() {
    // String text = _controller.text;
    //do your text transforming
    // _controller.text = newText;
  }

  // void onChange() {
  //   // _controller.text=_contr

  //   // _controller.
  //   // if (oldText != text) {
  //   //   isTextChanged = true;
  //   // }
  //   // bool hasFocus = _textFocus.hasFocus;
  //   //do your text transforming
  //   // _controller.text = newText;
  //   // _controller.selection = new TextSelection(
  //   //                               baseOffset: newText.length,
  //   //                               extentOffset: newText.length
  //   //                         );
  // }

  @override
  initState() {
    bloc = CCMAddFeedbackBloc(context, widget.model);

    if (widget.model.viewType == FeedbackViewType.Edit) {
      _testController = TextEditingController(text: widget.model.feedback.text);

      bloc.groupCoverage = widget.model.feedback.groupCoverage.toDouble();
      bloc.commentMessage = widget.model.feedback.text;
      //
      oldText = bloc.commentMessage = widget.model.feedback.text;
      //
      bloc.staffID = widget.model.feedback.staffID.toString();
      bloc.depOrModID = widget.model.feedback.depOrModID;
      bloc.isPositive = widget.model.feedback.isPositive;
      bloc.feedbackCategory = widget.model.feedback.type;
    } else if (widget.model.viewType == FeedbackViewType.Add) {
      _testController = TextEditingController(text: '');
      oldText = '';
    }
    // if(_controller.text==null || _controller.text==''){
    //   _controller.text = oldText;
    // }
    _testController.addListener(onChange);
    super.initState();
  }

  double sliderErrorOpacity = 0.0;
  double teacherErrorOpacity = 0.0;
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    String teacherName = 'Select a teacher';

    final List<String> _typeList = [
      'Positive comments',
      'Suggestions for improvements'
    ];

    bool checkErrors() {
      _value = widget.model.feedback == null ||
              widget.model.feedback.groupCoverage == 0
          ? bloc.groupCoverage
          : widget.model.feedback.groupCoverage.toDouble();
      teacherName = widget.model.feedback == null ||
              widget.model.feedback.staffFullName == ''
          ? bloc.teacherName
          : widget.model.feedback.staffFullName;

      if (_value == 0.0) {
        return false;
      } else if (widget.model.viewType == FeedbackViewType.Edit &&
              teacherName == '' ||
          widget.model.viewType == FeedbackViewType.Edit &&
              teacherName == 'Select a teacher') {
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

      if (checkErrors()) {
        if (form.validate() && bloc.groupCoverage != 0.0) {
          form.save();

          if (widget.model.viewType == FeedbackViewType.Add) {
            bloc.postFeedback();
          } else {
            bloc.editFeedback(widget.model.feedback.id);
          }
        }
      }
    }

    Future<Null> showDeleteDialog(BuildContext context) async {
      return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          if (Platform.isAndroid) {
            return AlertDialog(
              title: Text(
                'Delete',
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Do you want to delete the feedback?'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  textColor: redColor,
                  child: Text('Delete'.toUpperCase()),
                  onPressed: () {
                    if (widget.model.feedback != null)
                      bloc.deleteFeedback(widget.model.feedback);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text(
                'Delete',
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Do you want to delete the feedback?'),
                  ],
                ),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Delete'.toUpperCase()),
                  onPressed: () {
                    if (widget.model.feedback != null)
                      bloc.deleteFeedback(widget.model.feedback);
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Cancel'.toUpperCase()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        },
      );
    }

    Future<bool> _onBackPressed(BuildContext context) async {
      if (oldText != _testController.text) {
        return showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            if (Platform.isAndroid) {
              return AlertDialog(
                title: Text('Discard'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Do you want to discard the changes?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Discard'.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      return false;
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return false;
                    },
                  ),
                ],
              );
            } else if (Platform.isIOS) {
              return CupertinoAlertDialog(
                title: Text('Discard'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Do you want to discard the changes?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Discard'.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      return true;
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Cancel'.toUpperCase()),
                    onPressed: () {
                      Navigator.of(context).pop();
                      return false;
                    },
                  ),
                ],
              );
            }
          },
        );
      } else {
        Navigator.of(context).pop();
        return false;
      }
    }

    return Platform.isAndroid
        ? WillPopScope(
            onWillPop: () => _onBackPressed(context),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(widget.model.viewType == FeedbackViewType.Add
                    ? 'Add feedback'
                    : 'Edit Feedback'),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // ],)
                        Padding(
                          padding:
                              EdgeInsets.only(left: 6.0, bottom: 5.0, top: 8.0),
                          child: Text(
                            'Feedback type',
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 16.0, color: accentColor),
                          ),
                        ),
                        StreamBuilder(
                          stream: bloc.feedbackType,
                          initialData: widget.model.feedback == null
                              ? _typeList[widget.model.feedbackType]
                              : widget.model.feedback.isPositive
                                  ? _typeList[0]
                                  : _typeList[1],
                          builder: (context, snapshot) => Card(
                                child: CCMFeedbackTypeExpansionTile(
                                    bloc: bloc,
                                    expansionTile: typeExpansionTile,
                                    value: snapshot.hasData
                                        ? snapshot.data
                                        : _typeList[widget.model.feedbackType],
                                    expansionChildrenList: _typeList),
                              ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 6.0,
                            bottom: 8.0,
                            top: 3.0,
                          ),
                          child: Text(
                            'Feedback',
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 16.0, color: accentColor),
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
                                    // initialValue: widget.model.feedback != null
                                    //     ? widget.model.feedback.text
                                    //     : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .body2
                                        .copyWith(
                                            decorationColor: Colors.white,
                                            fontWeight: FontWeight.normal),
                                    autovalidate: snapshot.hasData
                                        ? snapshot.data
                                        : false,
                                    controller: _testController,
                                    // widget.model.viewType ==
                                    //         FeedbackViewType.Add
                                    //     ? _controller
                                    //     : _testController,
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
                                        val = bloc.commentMessage;
                                      }
                                    },
                                    onSaved: (val) {
                                      bloc.commentMessage = val;
                                    },
                                  ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 6.0, bottom: 5.0, top: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Group coverage',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0, color: accentColor),
                              ),
                              StreamBuilder(
                                stream: bloc.groupCoverageValue,
                                initialData: widget.model.feedback == null
                                    ? 0.0
                                    : widget.model.feedback.groupCoverage
                                        .toDouble(),
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
                                    divisions: 20,
                                    value: snapshot.hasData
                                        // ? [_value = snapshot.data, snapshot.data]
                                        ? _value = snapshot.data
                                        : widget.model.feedback == null
                                            ? 0.0
                                            : widget
                                                .model.feedback.groupCoverage
                                                .toDouble(),
                                    min: 0.0,
                                    max: 100.0,
                                    onChanged: (double value) {
                                      bloc.setGroupCoverageValue.add(value);
                                      bloc.groupCoverage = value;
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
                          initialData: widget.model.feedback == null
                              ? 0.0
                              : widget.model.feedback.groupCoverage.toDouble(),
                          builder: (context, snapshot) => StreamBuilder(
                                stream: bloc.groupCoverageDataValidation,
                                builder: (_, shot) => Opacity(
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
                        widget.model.depOrMod ==
                                CCMFeedbackCategory.ModulesFeedback
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 6.0, bottom: 6.0, top: 3.0),
                                child: Text(
                                  'Teacher',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16.0, color: accentColor),
                                ),
                              )
                            : Container(),
                        widget.model.depOrMod ==
                                CCMFeedbackCategory.ModulesFeedback
                            ? Card(
                                child: StreamBuilder(
                                  initialData: widget.model.feedback == null
                                      ? 'Select a teacher'
                                      : widget.model.feedback.staffFullName,
                                  stream: bloc.teacherNameValue,
                                  builder: (context, snapshot) => FutureBuilder<
                                          List<CCMFeedbackAsSelectedList>>(
                                        future: bloc.getModuleRepresentatives(),
                                        builder: (context, shot) =>
                                            TeacherAttachingExpansionTile(
                                                bloc: bloc,
                                                expansionTile:
                                                    teacherExpansionTile,
                                                value: snapshot.hasData
                                                    ? snapshot.data
                                                    : widget.model.feedback ==
                                                            null
                                                        ? teacherName
                                                        : widget.model.feedback
                                                            .staffFullName,
                                                expansionChildrenList:
                                                    shot.hasData
                                                        ? shot.data
                                                        : []),
                                      ),
                                ),
                              )
                            : Container(),
                        widget.model.depOrMod ==
                                CCMFeedbackCategory.ModulesFeedback
                            ? StreamBuilder(
                                stream: bloc.teacherNameValue,
                                initialData: widget.model.feedback == null
                                    ? 'Select a teacher'
                                    : widget.model.feedback.staffFullName,
                                builder: (context, snapshot) => StreamBuilder(
                                      stream: bloc.teacherNameDataValidation,
                                      builder: (context, shot) => Opacity(
                                            opacity: shot.data == true
                                                ? snapshot.data !=
                                                        'Select a teacher'
                                                    ? 0.0
                                                    : 1.0
                                                : 0.0,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Teacher is not chosen',
                                                style: TextStyle(
                                                    color: redColor,
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ),
                                    ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 5.0, bottom: 8.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            color: accentColor,
                            onPressed: saveComment,
                            child: Text(
                              widget.model.viewType == FeedbackViewType.Add
                                  ? 'Submit'.toUpperCase()
                                  : 'Save'.toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        widget.model.viewType == FeedbackViewType.Edit
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 8.0),
                                child: InkWell(
                                  highlightColor: Colors.red[400].withAlpha(20),
                                  splashColor: Colors.red[400].withAlpha(20),
                                  onTap: () => showDeleteDialog(context),

                                  // if (widget.model.feedback != null)
                                  //   bloc.deleteFeedback(widget.model.feedback);

                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            width: 2.0, color: redColor)),
                                    // onPressed: () {},
                                    child: Text(
                                      'Delete'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: redColor),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
                backgroundColor: backgroundColor,
                navigationBar: CupertinoNavigationBar(
                  middle: Text(widget.model.viewType == FeedbackViewType.Add
                      ? 'Add Feedback'
                      : 'Edit Feedback'),
                ),
                child: SafeArea(
                  child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 6.0, bottom: 5.0, top: 8.0),
                              child: Text(
                                'Feedback type',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0, color: accentColor),
                              ),
                            ),
                            StreamBuilder(
                              stream: bloc.feedbackType,
                              initialData: widget.model.feedback == null
                                  ? _typeList[widget.model.feedbackType]
                                  : widget.model.feedback.isPositive
                                      ? _typeList[0]
                                      : _typeList[1],
                              builder: (context, snapshot) => Card(
                                    child: CCMFeedbackTypeExpansionTile(
                                        bloc: bloc,
                                        expansionTile: typeExpansionTile,
                                        value: snapshot.hasData
                                            ? snapshot.data
                                            : _typeList[
                                                widget.model.feedbackType],
                                        expansionChildrenList: _typeList),
                                  ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.symmetric(horizontal: 5.0),
                            //   height: 138.0,
                            //   color: Colors.white,
                            //   child: Form(
                            //     key: formKey,
                            //     child: StreamBuilder(
                            //       stream: bloc.autoValidation,
                            //       initialData: false,
                            //       builder: (context, snapshot) => TextFormField(
                            //             initialValue:
                            //                 widget.model.feedback != null
                            //                     ? widget.model.feedback.text
                            //                     : '',
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .body2
                            //                 .copyWith(
                            //                     decorationColor: Colors.white,
                            //                     fontWeight: FontWeight.normal),
                            //             autovalidate: snapshot.hasData
                            //                 ? snapshot.data
                            //                 : false,
                            //             autofocus: false,
                            //             maxLines: 7,
                            //             // controller: _controller,
                            //             keyboardType: TextInputType.multiline,
                            //             decoration: InputDecoration(
                            //                 contentPadding: EdgeInsets.all(10.0),
                            //                 border: InputBorder.none,
                            //                 hintText: 'Write here'),
                            //             validator: (val) {
                            //               if (val.length == 0 || val == null) {
                            //                 return 'Comment section cannot be empty';
                            //               } else {
                            //                 val = bloc.commentMessage;
                            //               }
                            //             },
                            //             onSaved: (val) {
                            //               bloc.commentMessage = val;
                            //             },
                            //           ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 6.0,
                                bottom: 8.0,
                                top: 3.0,
                              ),
                              child: Text(
                                'Feedback',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0, color: accentColor),
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
                                        controller: _testController,
                                        // widget.model.feedback != null
                                        //     ? widget.model.feedback.text
                                        //     : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .copyWith(
                                                decorationColor: Colors.white,
                                                fontWeight: FontWeight.normal),
                                        autovalidate: snapshot.hasData
                                            ? snapshot.data
                                            : false,
                                        autofocus: false,
                                        maxLines: 7,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            border: InputBorder.none,
                                            hintText: 'Write here'),
                                        validator: (val) {
                                          if (val.length == 0 || val == null) {
                                            return 'Comment section cannot be empty';
                                          } else {
                                            val = bloc.commentMessage;
                                          }
                                        },
                                        onSaved: (val) {
                                          bloc.commentMessage = val;
                                        },
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 6.0, bottom: 5.0, top: 14.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Group coverage',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16.0, color: accentColor),
                                  ),
                                  StreamBuilder(
                                    stream: bloc.groupCoverageValue,
                                    initialData: widget.model.feedback == null
                                        ? 0.0
                                        : widget.model.feedback.groupCoverage
                                            .toDouble(),
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
                                    child: CupertinoSlider(
                                        activeColor: accentColor,
                                        divisions: 20,
                                        value: snapshot.hasData
                                            // ? [_value = snapshot.data, snapshot.data]
                                            ? _value = snapshot.data
                                            : widget.model.feedback == null
                                                ? 0.0
                                                : widget.model.feedback
                                                    .groupCoverage
                                                    .toDouble(),
                                        min: 0.0,
                                        max: 100.0,
                                        onChanged: (double value) {
                                          bloc.setGroupCoverageValue.add(value);
                                          bloc.groupCoverage = value;
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
                              initialData: widget.model.feedback == null
                                  ? '0.0'
                                  : widget.model.feedback.groupCoverage
                                      .toDouble(),
                              builder: (context, snapshot) => StreamBuilder(
                                    stream: bloc.groupCoverageDataValidation,
                                    builder: (_, shot) => Opacity(
                                          opacity: shot.data == true
                                              ? snapshot.data > 0.0 ? 0.0 : 1.0
                                              : 0.0,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              'Group coverage is not indicated',
                                              style: TextStyle(
                                                  color: redColor,
                                                  fontSize: 12.0),
                                            ),
                                          ),
                                        ),
                                  ),
                              // ),
                            ),
                            widget.model.depOrMod ==
                                    CCMFeedbackCategory.ModulesFeedback
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 6.0, bottom: 6.0, top: 3.0),
                                    child: Text(
                                      'Teacher',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16.0, color: accentColor),
                                    ),
                                  )
                                : Container(),
                            widget.model.depOrMod ==
                                    CCMFeedbackCategory.ModulesFeedback
                                ? Card(
                                    child: StreamBuilder(
                                      initialData: widget.model.feedback == null
                                          ? 'Select a teacher'
                                          : widget.model.feedback.staffFullName,
                                      stream: bloc.teacherNameValue,
                                      builder: (context, snapshot) =>
                                          FutureBuilder<
                                              List<CCMFeedbackAsSelectedList>>(
                                            future:
                                                bloc.getModuleRepresentatives(),
                                            builder: (context, shot) =>
                                                TeacherAttachingExpansionTile(
                                                    bloc: bloc,
                                                    expansionTile:
                                                        teacherExpansionTile,
                                                    value: snapshot.hasData
                                                        ? snapshot.data
                                                        : widget.model
                                                                    .feedback ==
                                                                null
                                                            ? teacherName
                                                            : widget
                                                                .model
                                                                .feedback
                                                                .staffFullName,
                                                    expansionChildrenList:
                                                        shot.hasData
                                                            ? shot.data
                                                            : []),
                                          ),
                                    ),
                                  )
                                : Container(),
                            widget.model.depOrMod ==
                                    CCMFeedbackCategory.ModulesFeedback
                                ? StreamBuilder(
                                    stream: bloc.teacherNameValue,
                                    initialData: widget.model.feedback == null
                                        ? 'Select a teacher'
                                        : widget.model.feedback.staffFullName,
                                    builder: (context, snapshot) =>
                                        StreamBuilder(
                                          stream:
                                              bloc.teacherNameDataValidation,
                                          builder: (context, shot) => Opacity(
                                                opacity: shot.data == true
                                                    ? snapshot.data !=
                                                            'Select a teacher'
                                                        ? 0.0
                                                        : 1.0
                                                    : 0.0,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
                                                  child: Text(
                                                    'Teacher is not chosen',
                                                    style: TextStyle(
                                                        color: redColor,
                                                        fontSize: 12.0),
                                                  ),
                                                ),
                                              ),
                                        ),
                                  )
                                : Container(),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 5.0,
                                    bottom: 8.0),
                                child: Platform.isAndroid
                                    ? RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        color: accentColor,
                                        onPressed: saveComment,
                                        child: Text(
                                          widget.model.viewType ==
                                                  FeedbackViewType.Add
                                              ? 'Submit'.toUpperCase()
                                              : 'Save'.toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : CupertinoButton(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        color: accentColor,
                                        onPressed: saveComment,
                                        child: Text(
                                          widget.model.viewType ==
                                                  FeedbackViewType.Add
                                              ? 'Submit'.toUpperCase()
                                              : 'Save'.toUpperCase(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                            widget.model.viewType == FeedbackViewType.Edit
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0, bottom: 8.0),
                                    child: Platform.isAndroid
                                        ? InkWell(
                                            highlightColor:
                                                Colors.red[400].withAlpha(20),
                                            splashColor:
                                                Colors.red[400].withAlpha(20),
                                            onTap: () =>
                                                showDeleteDialog(context),
                                            // () {
                                            // if (widget.model.feedback != null)
                                            //   bloc.deleteFeedback(
                                            //       widget.model.feedback);
                                            // },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color: redColor)),
                                              // onPressed: () {},
                                              child: Text(
                                                'Delete'.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style:
                                                    TextStyle(color: redColor),
                                              ),
                                            ),
                                          )
                                        : CupertinoButton(
                                            color: redColor,
                                            child: Text(
                                              'Delete'.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(color: whiteColor),
                                            ),
                                            onPressed: () {
                                              if (widget.model.feedback != null)
                                                bloc.deleteFeedback(
                                                    widget.model.feedback);
                                            },
                                          ))
                                : Container(),
                          ],
                        ),
                      ))),
                )),
          );
  }
}
