import 'package:student_system_flutter/helpers/app_constants.dart';

class AttendanceModel {
  final String student;
  final String module;
  final String lesson;
  final String message;
  bool isSuccess = false;

  AttendanceModel(
      {this.student,
      this.module,
      this.lesson,
      this.message,
      this.isSuccess = false});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      student: json['student'] ?? nullFixer,
      module: json['module'] ?? nullFixer,
      lesson: json['lesson'] ?? nullFixer,
      message: json['message'] ?? nullFixer,
    );
  }
}
