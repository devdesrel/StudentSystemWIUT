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
  int _selectedColorIndex = 0;
  // final FixedExtentScrollController scrollController =
  //     FixedExtentScrollController(initialItem: _selectedColorIndex);

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
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                          // scrollController: scrollController,
                          itemExtent: _kPickerItemHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            setState(() => _selectedColorIndex = index);
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
                          Text(
                            'Select group',
                            style: TextStyle(color: lightGreyTextColor),
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
              onTap: () {},
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
                          Text(
                            'Select teacher',
                            style: TextStyle(color: lightGreyTextColor),
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
              onTap: () {},
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
                      Text(
                        'Select room',
                        style: TextStyle(color: lightGreyTextColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
