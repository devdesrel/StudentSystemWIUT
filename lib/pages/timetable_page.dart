import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/timetable/timetable_bloc.dart';
import 'package:student_system_flutter/bloc/timetable/timetable_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/Timetable/groups_model.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

class TimetablePage extends StatelessWidget {
  final listItemLength = 6;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  File jsonFile;
  Directory dir;
  bool fileExists = false;
  Map<String, String> fileContent;

  void _saveJsonToFileSystem(String fileName, String content) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();

      jsonFile.writeAsStringSync(content);
      print(jsonFile.readAsStringSync());
      // if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

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

      List<TimetableModel> _sortedList = [];

      for (var item in _timetableList) {
        if (_sortedList.any((t) => t.subjectshort == item.subjectshort)) {
          int _position = _sortedList.indexOf(_sortedList
              .where((t) => t.subjectshort == item.subjectshort)
              .first);

          String _period = _sortedList
                  .where((t) => t.subjectshort == item.subjectshort)
                  .first
                  .period +
              ' ' +
              item.period;

          _sortedList.elementAt(_position).period = _period;
        } else {
          _sortedList.add(item);
        }
      }

      return _sortedList;
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
      _saveJsonToFileSystem('timetable.json', response.body);
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
    final _bloc = TimetableBloc();
    List<String> _weekDays = populateWeekDayList();

    return TimetableProvider(
      timetableBloc: _bloc,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Timetable'),
          actions: <Widget>[
            StreamBuilder(
                stream: _bloc.isLoaded,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return IconButton(
                        icon: Icon(FontAwesomeIcons.filter),
                        iconSize: 17.0,
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return DrawBottomSheetWidget(bloc: _bloc);
                              });
                        });
                  } else {
                    return Container();
                  }
                })
          ],
        ),
        body: FutureBuilder<List<TimetableModel>>(
            future: _getTimetable(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.length > 0) {
                return ListView.builder(
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
                              .where(
                                  (item) => item.dayOfWeek == _weekDays[index])
                              .toList());
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class DrawBottomSheetWidget extends StatelessWidget {
  final TimetableBloc bloc;
  DrawBottomSheetWidget({this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Group'),
                StreamBuilder(
                  stream: bloc.groupName,
                  builder: (context, snapshot) => DropdownButton(
                        value: snapshot.hasData
                            ? snapshot.data
                            : bloc.groupsListDropdown[0].text,
                        items: bloc.groupsListDropdown
                            .map((model) => DropdownMenuItem(
                                value: model.text, child: Text(model.text)))
                            .toList(),
                        onChanged: (value) {
                          bloc.setGroup.add(value);
                          Navigator.pop(context);
                        },
                      ),
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Room'),
                StreamBuilder(
                  stream: bloc.roomName,
                  builder: (context, snapshot) => DropdownButton(
                        value: snapshot.hasData
                            ? snapshot.data
                            : bloc.roomsListDropdown[0].text,
                        items: bloc.roomsListDropdown
                            .map((model) => DropdownMenuItem(
                                value: model.text, child: Text(model.text)))
                            .toList(),
                        onChanged: (value) {
                          bloc.setRoom.add(value);
                          Navigator.pop(context);
                        },
                      ),
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Teacher'),
                StreamBuilder(
                  stream: bloc.teacherName,
                  builder: (context, snapshot) => DropdownButton(
                        value: snapshot.hasData
                            ? snapshot.data
                            : bloc.teachersListDropdown[0].text,
                        items: bloc.teachersListDropdown
                            .map((model) => DropdownMenuItem(
                                value: model.text, child: Text(model.text)))
                            .toList(),
                        onChanged: (value) {
                          bloc.setTeacher.add(value);
                          Navigator.pop(context);
                        },
                      ),
                ),
              ]),
        ],
      ),
    );
  }
}

class ItemWeekTimetable extends StatelessWidget {
  final dayName;
  final List<TimetableModel> timetableList;

  ItemWeekTimetable({@required this.dayName, @required this.timetableList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: timetableList.length > 0 ? 300.0 : 0.0,
      child: ListView.builder(
          itemCount: timetableList.length + 1,
          itemBuilder: (_, index) {
            if (timetableList.length > 0) {
              if (index == 0)
                return WeekDayHeader(dayName: dayName);
              else
                return ItemDayTimetable(item: timetableList[index - 1]);
            }
          }),
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
