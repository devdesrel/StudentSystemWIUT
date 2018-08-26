import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_bloc.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/list_items/item_week_timetable.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

class TimetablePage extends StatelessWidget {
  final listItemLength = 6;

  @override
  Widget build(BuildContext context) {
    final _bloc = TimetableBloc(context: context);

    List<String> _weekDays = populateWeekDayList();

    return TimetableProvider(
        timetableBloc: _bloc,
        child: Platform.isAndroid
            ? Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  centerTitle: true,
                  title: StreamBuilder(
                      stream: _bloc.timetableTitle,
                      builder: (context, snapshot) => snapshot.hasData
                          ? Text(snapshot.data)
                          : Text('Timetable')),
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
                                        return DrawBottomSheetWidget(
                                            bloc: _bloc);
                                      });
                                });
                          } else {
                            return Container();
                          }
                        }),
                    // IconButton(icon: Icon(Icons.search), onPressed: () {})
                  ],
                ),
                body: StreamBuilder<List<TimetableModel>>(
                    stream: _bloc.timetableList,
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
                                                item.dayOfWeek ==
                                                _weekDays[index])
                                            .toList()));
                              else if (index == listItemLength - 1)
                                return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ItemWeekTimetable(
                                        dayName: _weekDays[index],
                                        timetableList: snapshot.data
                                            .where((item) =>
                                                item.dayOfWeek ==
                                                _weekDays[index])
                                            .toList()));
                              return ItemWeekTimetable(
                                  dayName: _weekDays[index],
                                  timetableList: snapshot.data
                                      .where((item) =>
                                          item.dayOfWeek == _weekDays[index])
                                      .toList());
                            });
                      } else if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Container(
                          child: Center(
                        child: Text(noAvailableTimetable),
                      ));
                    }),
              )
            : Material(
                child: CupertinoPageScaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  navigationBar: CupertinoNavigationBar(
                    middle: StreamBuilder(
                        stream: _bloc.timetableTitle,
                        builder: (context, snapshot) => snapshot.hasData
                            ? Text(snapshot.data)
                            : Text('Timetable')),
                    trailing: StreamBuilder(
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
                                        return DrawBottomSheetWidget(
                                            bloc: _bloc);
                                      });
                                });
                          } else {
                            return Container(
                              width: 2.0,
                            );
                          }
                        }),
                    // IconButton(icon: Icon(Icons.search), onPressed: () {})
                  ),
                  child: StreamBuilder<List<TimetableModel>>(
                      stream: _bloc.timetableList,
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
                                                  item.dayOfWeek ==
                                                  _weekDays[index])
                                              .toList()));
                                else if (index == listItemLength - 1)
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: ItemWeekTimetable(
                                          dayName: _weekDays[index],
                                          timetableList: snapshot.data
                                              .where((item) =>
                                                  item.dayOfWeek ==
                                                  _weekDays[index])
                                              .toList()));
                                return ItemWeekTimetable(
                                    dayName: _weekDays[index],
                                    timetableList: snapshot.data
                                        .where((item) =>
                                            item.dayOfWeek == _weekDays[index])
                                        .toList());
                              });
                        } else if (snapshot.data == null) {
                          return Center(child: CupertinoActivityIndicator());
                        }

                        return Container(
                            child: Center(
                          child: Text(noAvailableTimetable),
                        ));
                      }),
                ),
              ));
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
