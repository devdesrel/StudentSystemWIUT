import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/Timetable/groups_model.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

class TimetablePage extends StatelessWidget {
  final listItemLength = 6;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // FutureBuilder<List<GroupsModel>> _getGroupId() {
  //   return FutureBuilder(
  //       future: getGroupsList(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data.length > 0) {
  //           snapshot.data
  //               .where((group) => group.name == ('6BIS1'))
  //               .elementAt(0)
  //               .id;

  //           return Text(snapshot.data[0].id);
  //         }
  //         return Container();
  //       });

  List<GroupsModel> _parseGroups(String responseBody) {
    final parsed = json.decode(responseBody);

    List<GroupsModel> lists =
        parsed.map<GroupsModel>((item) => GroupsModel.fromJson(item)).toList();

    return lists;
  }

  Future<List<TimetableModel>> _getTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    final response = await http.get(apiGetClasses, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    });

    if (response.statusCode == 200) {
      // return compute(parseGroups, response.body);
      List<GroupsModel> groupsList = _parseGroups(response.body);

      String _groupID =
          groupsList.where((group) => group.name == ('6BIS1')).elementAt(0).id;

      // prefs.setString(groupID, _groupID);

      List<TimetableModel> _timetableList = await _getTimetableList(_groupID);

      return _timetableList;
    } else {
      showSnackBar(tryAgain, scaffoldKey);
      return null;
    }
  }

  List<TimetableModel> _parseTimetable(String responseBody) {
    final parsed = json.decode(responseBody);

    List<TimetableModel> lists = parsed
        .map<TimetableModel>((item) => TimetableModel.fromJson(item))
        .toList();

    print(lists);

    return lists;
  }

  _getTimetableList(String _groupID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    final response = await http.get('$apiGetLessons?classids=$_groupID',
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        });

    if (response.statusCode == 200) {
      List<TimetableModel> _timetableList = _parseTimetable(response.body);
      return _timetableList;
    } else {
      showSnackBar(tryAgain, scaffoldKey);
      return null;
    }
    // return compute(parseGroups, response.body);
  }

  @override
  Widget build(BuildContext context) {
    // 0.0, duration: new Duration(seconds: 2), curve: Curves.ease
    // _scrollController.jumpTo(4.0);

    // _scrollController.animateTo(300.0,
    //     duration: new Duration(seconds: 2), curve: Curves.ease);
    List<String> _weekDays = populateWeekDayList();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text('Timetable')),
      body: FutureBuilder<List<TimetableModel>>(
          future: _getTimetable(),
          builder: (context, snapshot) => snapshot.hasData &&
                  snapshot.data.length > 0
              ? ListView.builder(
                  itemCount: listItemLength,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    if (index == 0)
                      return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ItemWeekTimetable(
                              dayName: _weekDays[index],
                              timetableList: snapshot.data
                                  .where((item) =>
                                      item.dayOfWeek == _weekDays[index])
                                  .toList()));
                    else if (index == listItemLength - 1)
                      return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ItemWeekTimetable(
                              dayName: _weekDays[index],
                              timetableList: snapshot.data
                                  .where((item) =>
                                      item.dayOfWeek == _weekDays[index])
                                  .toList()));
                    return ItemWeekTimetable(
                        dayName: _weekDays[index],
                        timetableList: snapshot.data
                            .where((item) => item.dayOfWeek == _weekDays[index])
                            .toList());
                  })
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class ItemWeekTimetable extends StatelessWidget {
  final dayName;
  final listItemLength = 4;
  final List<TimetableModel> timetableList;

  ItemWeekTimetable({@required this.dayName, @required this.timetableList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: ListView.builder(
        itemCount: listItemLength + 1,
        itemBuilder: (_, index) => index == 0
            ? WeekDayHeader(dayName: dayName)
            : ItemDayTimetable(item: timetableList[index]),
      ),
    );
  }
}

List<String> populateWeekDayList() {
  List<String> weekDaysList = List();

  weekDaysList.add('Monday');
  weekDaysList.add('Tuesday');
  weekDaysList.add('Wednesday');
  weekDaysList.add('Thursday');
  weekDaysList.add('Friday');
  weekDaysList.add('Saturday');

  return weekDaysList;
}

class WeekDayHeader extends StatelessWidget {
  WeekDayHeader({Key key, this.dayName}) : super(key: key);

  final dayName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            dayName.toUpperCase(),
            style: Theme
                .of(context)
                .textTheme
                .display1
                .copyWith(color: accentColor, fontSize: 25.0),
          ),
          SizedBox(height: 5.0),
          Container(height: 2.0, color: accentColor)
        ],
      ),
    );
  }
}

class ItemDayTimetable extends StatelessWidget {
  final TimetableModel item;
  ItemDayTimetable({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
      child: CustomCard(
        Container(
          color: whiteColor,
          width: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                    child: Text(item.period,
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: whiteColor))),
                color: accentColor,
              ),
              SizedBox(height: 15.0),
              Text(item.subjectshort,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: textColor, fontWeight: FontWeight.w500)),
              SizedBox(height: 15.0),
              Image.asset('assets/timetable.png', height: 60.0),
              SizedBox(height: 10.0),
              Text(item.teachershort,
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: textColor)),
              SizedBox(height: 15.0),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Room',
                          style: Theme
                              .of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: whiteColor)),
                      Text(item.classroomshort,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: whiteColor)),
                    ],
                  ),
                  color: greyColor),
            ],
          ),
        ),
      ),
    );
  }
}
