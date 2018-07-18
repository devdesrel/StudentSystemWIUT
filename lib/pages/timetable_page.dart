import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/Timetable/groups_model.dart';

class TimetablePage extends StatelessWidget {
  final listItemLength = 6;

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

  List<GroupsModel> parseGroups(String responseBody) {
    final parsed = json.decode(responseBody);

    List<GroupsModel> lists =
        parsed.map<GroupsModel>((json) => GroupsModel.fromJson(json)).toList();

    return lists;
  }

  getGroupsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    final response = await http.get(apiGetClasses, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    });
    // return compute(parseGroups, response.body);
    List<GroupsModel> groupsList = parseGroups(response.body);

    String _groupID =
        groupsList.where((group) => group.name == ('6BIS1')).elementAt(0).id;

    // prefs.setString(groupID, _groupID);

    getTimetableList(_groupID);

    print(_groupID);

    return _groupID;
  }

  getTimetableList(String _groupID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    // final _groupID = prefs.getString(groupID);

    final response = await http.get('$apiGetLessons?classids=$_groupID',
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        });
    // return compute(parseGroups, response.body);
    print(response.body);
    // List<GroupsModel> groupsList = parseGroups(response.body);

    // String _groupID =
    //     groupsList.where((group) => group.name == ('6BIS1')).elementAt(0).id;

    // await prefs.setString(groupID, _groupID);

    // print(_groupID);

    // return _groupID;
  }

  @override
  Widget build(BuildContext context) {
    // 0.0, duration: new Duration(seconds: 2), curve: Curves.ease
    // _scrollController.jumpTo(4.0);

    // _scrollController.animateTo(300.0,
    //     duration: new Duration(seconds: 2), curve: Curves.ease);
    getGroupsList();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text('Timetable')),
      body: ListView.builder(
          itemCount: listItemLength,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            if (index == 0)
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ItemWeekTimetable(parentIndex: index),
              );
            else if (index == listItemLength - 1)
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ItemWeekTimetable(parentIndex: index),
              );
            return ItemWeekTimetable(parentIndex: index);
          }),
    );
  }
}

class ItemWeekTimetable extends StatelessWidget {
  final parentIndex;
  final List<String> weekDays = populateWeekDayList();
  final listItemLength = 4;

  ItemWeekTimetable({@required this.parentIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: ListView.builder(
        itemCount: listItemLength + 1,
        itemBuilder: (_, index) => index == 0
            ? WeekDayHeader(weekDays: weekDays, parentIndex: parentIndex)
            : ItemDayTimetable(),
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
  const WeekDayHeader({
    Key key,
    @required this.weekDays,
    @required this.parentIndex,
  }) : super(key: key);

  final List<String> weekDays;
  final parentIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            weekDays[parentIndex].toUpperCase(),
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
  const ItemDayTimetable({
    Key key,
  }) : super(key: key);

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
                    child: Text('09:00 - 11:00',
                        textAlign: TextAlign.center,
                        style: Theme
                            .of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: whiteColor))),
                color: accentColor,
              ),
              SizedBox(height: 15.0),
              Text('Web Application Development',
                  textAlign: TextAlign.center,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: textColor, fontWeight: FontWeight.w500)),
              SizedBox(height: 15.0),
              Image.asset('assets/timetable.png', height: 60.0),
              SizedBox(height: 10.0),
              Text('Mikhail Shpriko',
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
                      Text('ATB304',
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
