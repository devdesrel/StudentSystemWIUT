import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final listItemLength = 6;
  @override
  Widget build(BuildContext context) {
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
