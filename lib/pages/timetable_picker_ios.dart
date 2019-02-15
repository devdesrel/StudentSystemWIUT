import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class TimetablePickerIosPage extends StatefulWidget {
  @override
  _TimetablePickerIosPageState createState() => _TimetablePickerIosPageState();
}

class _TimetablePickerIosPageState extends State<TimetablePickerIosPage> {
  double _kPickerItemHeight = 32.0;
  double _kPickerSheetHeight = 216.0;
  var _bloc;

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
    if (_bloc.timetableFilterType == CupertinoTimetablePickerType.Group) {
      _bloc.setGroup
          .add(_bloc.groupsListDropdown[_bloc.cupertinoGroupIndex].text.trim());
      return true;
    } else if (_bloc.timetableFilterType ==
        CupertinoTimetablePickerType.Teacher) {
      _bloc.setTeacher.add(
          _bloc.teachersListDropdown[_bloc.cupertinoTeacherIndex].text.trim());
      return true;
    } else if (_bloc.timetableFilterType == CupertinoTimetablePickerType.Room) {
      _bloc.setRoom
          .add(_bloc.roomsListDropdown[_bloc.cupertinoRoomIndex].text.trim());
      return true;
    }

    return true;
    // if (_bloc.cupertinoGroupIndex != 0) {
    //   _bloc.setGroup.add(
    //       _bloc.groupsListDropdown[_bloc.cupertinoGroupIndex].text);
    //   return true;
    // } else if (_bloc.cupertinoRoomIndex != 0) {
    //   _bloc.setRoom.add(
    //       _bloc.roomsListDropdown[_bloc.cupertinoRoomIndex].text);
    //   return true;
    // } else if (_bloc.cupertinoTeacherIndex != 0) {
    //   _bloc.setTeacher.add(widget
    //       .bloc.teachersListDropdown[_bloc.cupertinoTeacherIndex].text);
    //   print(widget
    //       .bloc.teachersListDropdown[_bloc.cupertinoTeacherIndex].text);
    //   return true;
    // } else {
    //   return false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    _bloc = TimetableProvider.of(context);

    return Material(
      // child: WillPopScope(
      // onWillPop: _onBackPressed,
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
                          scrollController: _bloc.groupScrollController,
                          itemExtent: _kPickerItemHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            // _bloc.setGroup.add(
                            //     _bloc.groupsListDropdown[index].text);
                            _bloc.setCupertinoPickerGroupIndex.add(index);
                            _bloc.timetableFilterType =
                                CupertinoTimetablePickerType.Group;
                          },
                          children: List<Widget>.generate(
                              _bloc.groupsListDropdown.length, (int index) {
                            return Center(
                              child: Text(_bloc.groupsListDropdown[index].text),
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
                            stream: _bloc.groupName,
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
                          scrollController: _bloc.teacherScrollController,
                          itemExtent: _kPickerItemHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            // _bloc.setTeacher.add(
                            //     _bloc.teachersListDropdown[index].text);
                            _bloc.setCupertinoPickerTeacherIndex.add(index);
                            _bloc.timetableFilterType =
                                CupertinoTimetablePickerType.Teacher;
                          },
                          children: List<Widget>.generate(
                              _bloc.teachersListDropdown.length, (int index) {
                            return Center(
                              child:
                                  Text(_bloc.teachersListDropdown[index].text),
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
                            stream: _bloc.teacherName,
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
                          scrollController: _bloc.roomScrollController,
                          itemExtent: _kPickerItemHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            // _bloc.setRoom.add(
                            //     _bloc.roomsListDropdown[index].text);
                            _bloc.setCupertinoPickerRoomIndex.add(index);
                            _bloc.timetableFilterType =
                                CupertinoTimetablePickerType.Room;
                          },
                          children: List<Widget>.generate(
                              _bloc.roomsListDropdown.length, (int index) {
                            return Center(
                              child: Text(_bloc.roomsListDropdown[index].text),
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
                        stream: _bloc.roomName,
                        initialData: 'Select room',
                        builder: (context, snapshot) => Text(
                              snapshot.hasData ? snapshot.data : 'Select room',
                              style: TextStyle(color: lightGreyTextColor),
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton(
                onPressed: () {
                  _bloc.setTeacher.add(_bloc
                      .teachersListDropdown[_bloc.cupertinoTeacherIndex].text);
                  Navigator.of(context).pop();
                },
                color: accentColor,
                child: Text('Load timetable'),
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}
