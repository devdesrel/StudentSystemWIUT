import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class TimetablePickerIosPage extends StatefulWidget {
  final TimetableBloc bloc;
  TimetablePickerIosPage({this.bloc});

  @override
  _TimetablePickerIosPageState createState() => _TimetablePickerIosPageState();
}

class _TimetablePickerIosPageState extends State<TimetablePickerIosPage> {
  double _kPickerItemHeight = 32.0;
  double _kPickerSheetHeight = 216.0;

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (widget.bloc.timetableFilterType == CupertinoTimetablePickerType.Group) {
      widget.bloc.setGroup.add(
          widget.bloc.groupsListDropdown[widget.bloc.cupertinoGroupIndex].text);
      return true;
    } else if (widget.bloc.timetableFilterType ==
        CupertinoTimetablePickerType.Teacher) {
      widget.bloc.setTeacher.add(widget
          .bloc.teachersListDropdown[widget.bloc.cupertinoTeacherIndex].text);
      return true;
    } else if (widget.bloc.timetableFilterType ==
        CupertinoTimetablePickerType.Room) {
      widget.bloc.setRoom.add(
          widget.bloc.roomsListDropdown[widget.bloc.cupertinoRoomIndex].text);
      return true;
    }

    return true;
    // if (widget.bloc.cupertinoGroupIndex != 0) {
    //   widget.bloc.setGroup.add(
    //       widget.bloc.groupsListDropdown[widget.bloc.cupertinoGroupIndex].text);
    //   return true;
    // } else if (widget.bloc.cupertinoRoomIndex != 0) {
    //   widget.bloc.setRoom.add(
    //       widget.bloc.roomsListDropdown[widget.bloc.cupertinoRoomIndex].text);
    //   return true;
    // } else if (widget.bloc.cupertinoTeacherIndex != 0) {
    //   widget.bloc.setTeacher.add(widget
    //       .bloc.teachersListDropdown[widget.bloc.cupertinoTeacherIndex].text);
    //   print(widget
    //       .bloc.teachersListDropdown[widget.bloc.cupertinoTeacherIndex].text);
    //   return true;
    // } else {
    //   return false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: CupertinoPageScaffold(
          backgroundColor: backgroundColor,
          navigationBar: CupertinoNavigationBar(
            middle: Text('Timetable'),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                height: 30.0,
              ),
              InkWell(
                onTap: () async {
                  await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoPicker(
                            scrollController: widget.bloc.groupScrollController,
                            itemExtent: _kPickerItemHeight,
                            backgroundColor: CupertinoColors.white,
                            onSelectedItemChanged: (int index) {
                              // widget.bloc.setGroup.add(
                              //     widget.bloc.groupsListDropdown[index].text);
                              widget.bloc.setCupertinoPickerGroupIndex
                                  .add(index);
                              widget.bloc.timetableFilterType =
                                  CupertinoTimetablePickerType.Group;
                            },
                            children: List<Widget>.generate(
                                widget.bloc.groupsListDropdown.length,
                                (int index) {
                              return Center(
                                child: Text(
                                    widget.bloc.groupsListDropdown[index].text),
                              );
                            }),
                          ),
                        );
                      });
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 9.0, right: 9.0, top: 20.0,
                      // bottom: 10.0
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Group',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            StreamBuilder(
                              stream: widget.bloc.groupName,
                              initialData: 'Select group',
                              builder: (context, snapshot) => Text(
                                    snapshot.hasData
                                        ? snapshot.data
                                        : 'Select group',
                                    style: TextStyle(color: lightGreyTextColor),
                                  ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoPicker(
                            scrollController:
                                widget.bloc.teacherScrollController,
                            itemExtent: _kPickerItemHeight,
                            backgroundColor: CupertinoColors.white,
                            onSelectedItemChanged: (int index) {
                              // widget.bloc.setTeacher.add(
                              //     widget.bloc.teachersListDropdown[index].text);
                              widget.bloc.setCupertinoPickerTeacherIndex
                                  .add(index);
                              widget.bloc.timetableFilterType =
                                  CupertinoTimetablePickerType.Teacher;
                            },
                            children: List<Widget>.generate(
                                widget.bloc.teachersListDropdown.length,
                                (int index) {
                              return Center(
                                child: Text(widget
                                    .bloc.teachersListDropdown[index].text),
                              );
                            }),
                          ),
                        );
                      });
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Teacher',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            StreamBuilder(
                              stream: widget.bloc.teacherName,
                              initialData: 'Select teacher',
                              builder: (context, snapshot) => Text(
                                    snapshot.hasData
                                        ? snapshot.data
                                        : 'Select teacher',
                                    style: TextStyle(color: lightGreyTextColor),
                                  ),
                            )
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoPicker(
                            scrollController: widget.bloc.roomScrollController,
                            itemExtent: _kPickerItemHeight,
                            backgroundColor: CupertinoColors.white,
                            onSelectedItemChanged: (int index) {
                              // widget.bloc.setRoom.add(
                              //     widget.bloc.roomsListDropdown[index].text);
                              widget.bloc.setCupertinoPickerRoomIndex
                                  .add(index);
                              widget.bloc.timetableFilterType =
                                  CupertinoTimetablePickerType.Room;
                            },
                            children: List<Widget>.generate(
                                widget.bloc.roomsListDropdown.length,
                                (int index) {
                              return Center(
                                child: Text(
                                    widget.bloc.roomsListDropdown[index].text),
                              );
                            }),
                          ),
                        );
                      });
                },
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 9.0, right: 9.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Room',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        StreamBuilder(
                          stream: widget.bloc.roomName,
                          initialData: 'Select room',
                          builder: (context, snapshot) => Text(
                                snapshot.hasData
                                    ? snapshot.data
                                    : 'Select room',
                                style: TextStyle(color: lightGreyTextColor),
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
