import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/application_main_bloc/main_provider.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/list_items/item_week_timetable.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';
import 'package:student_system_flutter/pages/timetable_picker_ios.dart';
// import 'package:student_system_flutter/pages/timetable_picker_ios.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final listItemLength = 6;
  TimetableBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MainProvider.of(context).timetableBloc.cleared) {
      _bloc = MainProvider.of(context).createTimetableBloc();
    } else {
      _bloc = MainProvider.of(context).timetableBloc;
    }
    _bloc.context = context;
  }

  @override
  void dispose() {
    // _bloc.clearCache();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _weekDays = populateWeekDayList();

    return Platform.isAndroid
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
                StreamBuilder<bool>(
                    stream: _bloc.isLoaded,
                    initialData: false,
                    builder: (context, snapshot) {
                      return snapshot.data
                          ? IconButton(
                              icon: Icon(FontAwesomeIcons.filter),
                              iconSize: 17.0,
                              onPressed: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DrawBottomSheetWidget(
                                          // bloc: _bloc
                                          );
                                    });
                              })
                          : Container();
                    })

                // IconButton(icon: Icon(Icons.search), onPressed: () {})
              ],
            ),
            body: Column(children: <Widget>[
              Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  color: redColor,
                  child: Center(
                    child: StreamBuilder<String>(
                      stream: _bloc.timetableDate,
                      initialData: '',
                      builder: (context, snapshot) => Text(
                        snapshot.hasData ? snapshot.data : '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              Expanded(
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
                        return DrawPlatformCircularIndicator();
                      }

                      return Container(
                          child: Center(
                        child: Text(noAvailableTimetable),
                      ));
                    }),
              ),
            ]),
          )
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              navigationBar: CupertinoNavigationBar(
                middle: StreamBuilder(
                    stream: _bloc.timetableTitle,
                    builder: (context, snapshot) => snapshot.hasData
                        ? Text(
                            snapshot.data,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text('Timetable')),
                trailing: Material(
                  color: Colors.transparent,
                  child: StreamBuilder<bool>(
                      stream: _bloc.isLoaded,
                      initialData: false,
                      builder: (context, snapshot) {
                        return snapshot.data
                            ? IconButton(
                                icon: Icon(FontAwesomeIcons.filter),
                                iconSize: 17.0,
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .pushNamed(timetablePickerIosPage);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          TimetablePickerIosPage(
                                              // bloc: _bloc,
                                              )));
                                  // showModalBottomSheet<void>(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return DrawBottomSheetWidget(
                                  //           bloc: _bloc);
                                  //     });
                                })
                            : Container(
                                width: 1.0,
                              );
                      }),
                ),

                // IconButton(icon: Icon(Icons.search), onPressed: () {})
              ),
              child: SafeArea(
                child: Column(children: <Widget>[
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      color: redColor,
                      child: Center(
                        child: StreamBuilder<String>(
                          stream: _bloc.timetableDate,
                          initialData: '',
                          builder: (context, snapshot) => Text(
                            snapshot.hasData ? snapshot.data : '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                  Expanded(
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                              item.dayOfWeek ==
                                              _weekDays[index])
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
                ]),
              ),
            ),
          );
  }
}

class DrawBottomSheetWidget extends StatelessWidget {
  // final TimetableBloc bloc;
  // DrawBottomSheetWidget({this.bloc});

  @override
  Widget build(BuildContext context) {
    var bloc = MainProvider.of(context).timetableBloc;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
                            value: model.text.trim(),
                            child: Text(model.text.trim())))
                        .toList(),
                    onChanged: (value) {
                      bloc.setGroup.add(value.trim());
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
                            value: model.text.trim(),
                            child: Text(model.text.trim())))
                        .toList(),
                    onChanged: (value) {
                      bloc.setRoom.add(value.trim());
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
                            value: model.text.trim(),
                            child: Text(
                              model.text.trim(),
                            )))
                        .toList(),
                    onChanged: (value) {
                      bloc.setTeacher.add(value.trim());
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
