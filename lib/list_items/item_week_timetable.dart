import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

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

            return Container();
          }),
    );
  }
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
            style: Theme.of(context)
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
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: whiteColor))),
                color: accentColor,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                child: Text(item.subjectshort,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                        color: textColor, fontWeight: FontWeight.w500)),
              ),
              Image.asset('assets/timetable.png', height: 60.0),
              SizedBox(height: 10.0),
              Text(item.teachershort,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
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
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(color: whiteColor)),
                      Text(item.classroomshort,
                          style: Theme.of(context)
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
