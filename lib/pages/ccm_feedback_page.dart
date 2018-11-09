import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_bloc.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_item_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_carousel.dart';

import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/list_items/item_ccm_feedback.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_add_feedback_page_model.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_as_selected_list.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';

import 'package:student_system_flutter/pages/ccm_add_feedback_page.dart';

class CCMFeedbackPage extends StatelessWidget {
  final CCMFeedbackCategory requestType;
  final bool addressedToMe;
  final String groupID;

  CCMFeedbackPage({this.requestType, this.addressedToMe = false, this.groupID});

  @override
  Widget build(BuildContext context) {
    Widget _currentPage;
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

    final _bloc = CCMFeedbackBloc(context, _type, groupID);

    Widget _buildCCMFeedbackNote() {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        color: redColor,
        child: Center(
          child: Text(
            'Only CRs have right to add feedback',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    List<Widget> _getListOfWidget(List<CCMFeedbackAsSelectedList> list) {
      var _carouselPagesList = List<Widget>();
      _listOfPageBlocs = [];

      for (var i = 0; i < list.length; i++) {
        var _pageBloc = CCMFeedbackItemBloc(list[i].value, groupID);
        _listOfPageBlocs.add(_pageBloc);
        _listOfPageBlocs[i].depOrModID = int.parse(list[i].value);

        _pageBloc.getFeedback(_type);
        // _pageBloc.getModuleRepresentatives(list[i].value);

        var _page = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BuildCCMFeedbackCategoryTitle(title: list[i].text),
              SizedBox(height: 15.0),
              BuildCCMFeedbackTypeTab(pageBloc: _pageBloc),
              BuildCCMFeedbackList(
                  pageBloc: _pageBloc, requestType: requestType),
            ]);
        _carouselPagesList.add(_page);
      }

      return _carouselPagesList;
    }

    _getCarousel() {
      return StreamBuilder<List<CCMFeedbackAsSelectedList>>(
          stream: _bloc.feedbackCategoriesList,
          builder: (context, snapshot) => snapshot.hasData
              ? snapshot.data.length > 0
                  ? Center(
                      child: Column(
                      children: <Widget>[
                        _buildCCMFeedbackNote(),
                        Expanded(
                          child: CCMCarousel(
                              bloc: _bloc,
                              autoplay: false,
                              dotSize: 5.0,
                              dotColor: accentColor,
                              images: _getListOfWidget(snapshot.data)),
                        ),
                      ],
                    ))
                  : Container(
                      child: Text(''),
                    )
              : DrawPlatformCircularIndicator());
    }

    void _openAddFeedbackPage() async {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CCMAddFeedBackPage(
              model: CCMAddFeedbackPageModel(
                  viewType: FeedbackViewType.Add,
                  depOrMod: requestType,
                  depOrModID:
                      _listOfPageBlocs[_bloc.currentPageIndex].depOrModID,
                  feedbackType:
                      _listOfPageBlocs[_bloc.currentPageIndex].feedbackType))));
    }

    Widget _buildAddressedToMeView() {
      var _pageBloc = CCMFeedbackItemBloc('0', '0');
      _pageBloc.getFeedback('modules');

      return Column(
        children: <Widget>[
          SizedBox(height: 15.0),
          BuildCCMFeedbackTypeTab(pageBloc: _pageBloc),
          BuildCCMFeedbackList(pageBloc: _pageBloc, requestType: requestType),
        ],
      );
    }

    Widget _buildCCMFeedbage() {
      if (addressedToMe) {
        return _buildAddressedToMeView();
      } else {
        return _getCarousel();
      }
    }

    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('CCM Feedback'),
              centerTitle: true,
            ),
            backgroundColor: backgroundColor,
            floatingActionButton: StreamBuilder<bool>(
              stream: _bloc.isFeedbackEditable,
              initialData: false,
              builder: (context, snapshot) => snapshot.hasData
                  ? snapshot.data
                      ? FloatingActionButton(
                          onPressed: _openAddFeedbackPage,
                          child: Icon(Icons.add),
                        )
                      : Container()
                  : Container(),
            ),
            body: SafeArea(child: _buildCCMFeedbage()),
          )
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
                backgroundColor: backgroundColor,
                navigationBar: CupertinoNavigationBar(
                  automaticallyImplyLeading: true,
                  middle: Text("CCM Feedback"),
                  trailing: StreamBuilder<bool>(
                      stream: _bloc.isFeedbackEditable,
                      initialData: false,
                      builder: (context, snapshot) => snapshot.hasData
                          ? snapshot.data
                              ? Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: _openAddFeedbackPage,
                                    // child: Icon(Icons.add),
                                  ))
                              : Container(
                                  width: 1.0,
                                )
                          : Container(
                              width: 1.0,
                            )),
                ),
                child: SafeArea(child: _buildCCMFeedbage())),
          );
  }
}

class BuildCCMFeedbackCategoryTitle extends StatelessWidget {
  const BuildCCMFeedbackCategoryTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0, color: accentColor),
        ));
  }
}

class BuildCCMFeedbackList extends StatelessWidget {
  const BuildCCMFeedbackList({
    Key key,
    @required CCMFeedbackItemBloc pageBloc,
    @required this.requestType,
  })  : _pageBloc = pageBloc,
        super(key: key);

  final CCMFeedbackItemBloc _pageBloc;
  final CCMFeedbackCategory requestType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
          color: backgroundColor,
          child: StreamBuilder<List<CCMFeedbackModel>>(
              stream: _pageBloc.feedbackList,
              builder: (context, snapshot) => snapshot.hasData
                  ? snapshot.data.length > 0
                      ? CustomScrollView(slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (c, i) => ItemCCMFeedback(
                                      feedbackModel: snapshot.data[i],
                                      bloc: _pageBloc,
                                      requestType: requestType,
                                    ),
                                childCount: snapshot.data.length),
                          )
                        ])
                      : Container(child: Center(child: Text(noFeedback)))
                  : DrawPlatformCircularIndicator())),
    );
  }
}

class BuildCCMFeedbackTypeTab extends StatelessWidget {
  const BuildCCMFeedbackTypeTab({
    Key key,
    @required CCMFeedbackItemBloc pageBloc,
  })  : _pageBloc = pageBloc,
        super(key: key);

  final CCMFeedbackItemBloc _pageBloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                child: Center(
                  child: Text(
                    'Positive comments',
                    style: TextStyle(
                        fontSize: 13.0,
                        color: snapshot.data ? Colors.white : accentColor),
                  ),
                ),
                decoration: BoxDecoration(
                    color: snapshot.data ? accentColor : Colors.white,
                    border: Border.all(
                        width: snapshot.data ? 0.0 : 1.0, color: accentColor)),
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
                padding: EdgeInsets.symmetric(vertical: 3.5, horizontal: 15.0),
                decoration: BoxDecoration(
                    color: snapshot.data ? Colors.white : accentColor,
                    border: Border.all(
                        width: snapshot.data ? 1.0 : 2.0, color: accentColor)),
                child: Center(
                  child: Text(
                    'Suggestions for improvement',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: snapshot.data ? accentColor : Colors.white),
                  ),
                ),
              ),
        ),
      )
    ]);
  }
}
