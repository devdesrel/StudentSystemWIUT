import 'package:student_system_flutter/helpers/app_constants.dart';

class TimetableModel {
  final String dayOfWeek;
  String subjectshort;
  final String teachershort;
  final String classshort;
  final String classroomshort;
  String period;

  TimetableModel(
      {this.dayOfWeek,
      this.subjectshort,
      this.teachershort,
      this.classshort,
      this.classroomshort,
      this.period});

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
        dayOfWeek: json['dayOfWeek'] ?? nullFixer,
        subjectshort: json['subjectshort'] ?? nullFixer,
        teachershort: json['teachershort'] ?? nullFixer,
        classshort: json['classshort'] ?? nullFixer,
        classroomshort: json['classroomshort'] ?? nullFixer,
        period: json['period'] ?? nullFixer);
  }
}
