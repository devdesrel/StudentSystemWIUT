import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_bloc.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_item_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_carousel.dart';

import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_add_feedback_page_model.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';

import 'package:student_system_flutter/pages/ccm_add_feedback_page.dart';

class CCMFeedbackPage extends StatelessWidget {
  final CCMFeedbackCategory requestType;
  Widget _currentPage;

  CCMFeedbackPage({@required this.requestType});

  @override
  Widget build(BuildContext context) {
    if (_currentPage == null) {
      _currentPage = _createCurrentPage(context);
    }

    return _currentPage;
  }

  Widget _createCurrentPage(BuildContext context) {
    final String _modules = 'modules';
    final String _departments = 'departments';
    List<CCMFeedbackItemBloc> _listOfPageBlocs = [];

    String _type = requestType == CCMFeedbackCategory.ModulesFeedback
        ? _modules
        : _departments;

    final _bloc = CCMFeedbackBloc(context, _type);

    var size = MediaQuery.of(context).size;

    // List<Widget> _getStaffNames(CCMFeedbackItemBloc pageBloc) {
    //   List<Widget> _widgets = [];

    //   _widgets.add(StreamBuilder(
    //       stream: pageBloc.memberNames,
    //       builder: (context, snapshot) => snapshot.hasData
    //           ? Text(
    //               snapshot.data,
    //               style: TextStyle(fontSize: 15.0),
    //             )
    //           : Center(
    //               child: CircularProgressIndicator(),
    //             )));
    //   // _widgets.add(SizedBox(height: 5.0));
    //   // _widgets.add(Text(
    //   //   'Seminar-Lecturer: Abduvosid Malikov',
    //   //   style: TextStyle(fontSize: 15.0),
    //   // ));

    //   return _widgets;
    // }

    List<Widget> _getListOfWidget(List<CCMFeedbackAsSelectedList> list) {
      var _carouselPagesList = List<Widget>();
      _listOfPageBlocs = [];

      for (var i = 0; i < list.length; i++) {
        var _pageBloc = CCMFeedbackItemBloc(list[i].value);
        _listOfPageBlocs.add(_pageBloc);
        _listOfPageBlocs[i].depOrModID = int.parse(list[i].value);

        _pageBloc.getFeedback(i, _type);
        _pageBloc.getModuleRepresentatives(list[i].value);

        var _page =
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
          Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
              child: Text(
                list[i].text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, color: accentColor),
              )),
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: _getStaffNames(_pageBloc),
          //   ),
          // ),
          SizedBox(height: 15.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            InkWell(
              onTap: () {
                _pageBloc.setIsPositive.add(true);
                _pageBloc.sortFeedbackList(true);
                _pageBloc.feedbackType = 0;
              },
              child: StreamBuilder(
                stream: _pageBloc.isPositive,
                initialData: true,
                builder: (context, snapshot) => Container(
                      width: size.width / 2 - 5,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 15.0),
                      child: Center(
                        child: Text(
                          'Positive comments',
                          style: TextStyle(
                              fontSize: 13.0,
                              color:
                                  snapshot.data ? Colors.white : accentColor),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: snapshot.data ? accentColor : Colors.white,
                          border: Border.all(
                              width: snapshot.data ? 0.0 : 1.0,
                              color: accentColor)),
                    ),
              ),
            ),
            InkWell(
              onTap: () {
                _pageBloc.setIsPositive.add(false);
                _pageBloc.sortFeedbackList(false);
                _pageBloc.feedbackType = 1;
              },
              child: StreamBuilder(
                stream: _pageBloc.isPositive,
                initialData: false,
                builder: (context, snapshot) => Container(
                      width: size.width / 2 - 5,
                      padding:
                          EdgeInsets.symmetric(vertical: 3.5, horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: snapshot.data ? Colors.white : accentColor,
                          border: Border.all(
                              width: snapshot.data ? 1.0 : 2.0,
                              color: accentColor)),
                      child: Center(
                        child: Text(
                          'Suggestions for improvement',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13.0,
                              color:
                                  snapshot.data ? accentColor : Colors.white),
                        ),
                      ),
                    ),
              ),
            )
          ]),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
                color: backgroundColor,
                child: StreamBuilder<List<CCMFeedbackModel>>(
                    stream: _pageBloc.feedbackList,
                    builder: (context, snapshot) => snapshot.hasData
                        ? snapshot.data.length > 0
                            ? ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (c, i) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: CustomCard(Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(0.0),
                                              padding: EdgeInsets.all(8.0),
                                              color: greyColor,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'To ${snapshot.data[i].staffFullName}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  snapshot.data[i].isRepliable
                                                      ? InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    ccmAddFeedbackPage);
                                                          },
                                                          child: Text(
                                                            'Reply',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => CCMAddFeedBackPage(
                                                          model: CCMAddFeedbackPageModel(
                                                              feedback: snapshot
                                                                  .data[i],
                                                              viewType:
                                                                  FeedbackViewType
                                                                      .Edit,
                                                              depOrMod:
                                                                  requestType,
                                                              depOrModID:
                                                                  _pageBloc
                                                                      .depOrModID,
                                                              feedbackType:
                                                                  _pageBloc
                                                                      .feedbackType))));
                                                },
                                                child: DrawCardBody(
                                                  groupCoverage: snapshot
                                                      .data[i].groupCoverage,
                                                  feedback:
                                                      snapshot.data[i].text,
                                                )),
                                            Container(
                                                margin: EdgeInsets.all(0.0),
                                                padding: EdgeInsets.all(8.0),
                                                color: CupertinoColors
                                                    .lightBackgroundGray,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                        'From ${snapshot.data[i].groupName}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0)),
                                                    Text(
                                                        snapshot.data[i]
                                                            .dateCreatedStr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0)),
                                                  ],
                                                )),
                                          ])),
                                    ),
                              )
                            : Container(child: Center(child: Text(noFeedback)))
                        : Center(child: CircularProgressIndicator()))),
          ),
        ]);

        _carouselPagesList.add(_page);
      }

      return _carouselPagesList;
    }

    Widget _getCarousel() {
      return StreamBuilder<List<CCMFeedbackAsSelectedList>>(
          stream: _bloc.feedbackCategoriesList,
          builder: (context, snapshot) => snapshot.hasData
              ? snapshot.data.length > 0
                  ? Center(
                      child: CCMCarousel(
                          bloc: _bloc,
                          autoplay: false,
                          dotSize: 5.0,
                          dotColor: accentColor,
                          images: _getListOfWidget(snapshot.data)))
                  : Container(
                      child: Text(''),
                    )
              : Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('CCM Feedback'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CCMAddFeedBackPage(
                  model: CCMAddFeedbackPageModel(
                      viewType: FeedbackViewType.Add,
                      depOrMod: requestType,
                      depOrModID:
                          _listOfPageBlocs[_bloc.currentPageIndex].depOrModID,
                      feedbackType: _listOfPageBlocs[_bloc.currentPageIndex]
                          .feedbackType))));
        },
        child: Icon(Icons.add),
      ),
      body: _getCarousel(),
    );
  }
}

class DrawCardBody extends StatelessWidget {
  final int groupCoverage;
  final String feedback;

  DrawCardBody({Key key, @required this.groupCoverage, @required this.feedback})
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
