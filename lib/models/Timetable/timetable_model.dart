import 'package:student_system_flutter/helpers/app_constants.dart';

class TimetableModel {
  final String dayOfWeek;
  String subjectshort;
  final String teachershort;
  final String classshort;
  final String classroomshort;
  final String timetableDate;
  String period;

  TimetableModel(
      {this.dayOfWeek,
      this.subjectshort,
      this.teachershort,
      this.classshort,
      this.classroomshort,
      this.timetableDate,
      this.period});

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
        dayOfWeek: json['dayOfWeek'] ?? nullFixer,
        subjectshort: json['subjectshort'] ?? nullFixer,
        teachershort: json['teachershort'] ?? nullFixer,
        classshort: json['classshort'] ?? nullFixer,
        classroomshort: json['classroomshort'] ?? nullFixer,
        timetableDate: json['timetableDate'] ?? '07/09/2018',
        period: json['period'] ?? nullFixer);
  }
}
