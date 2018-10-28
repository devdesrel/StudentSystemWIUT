import 'package:student_system_flutter/helpers/app_constants.dart';

class DeadlinesModel {
  int assessmentID;
  int moduleID;
  String moduleFullName;
  String moduleShortName;
  int day;
  int month;
  int year;
  int hour;
  int minute;
  bool isTurnitinEnabled;
  String createdUser;
  String type;

  DeadlinesModel(
      {this.assessmentID,
      this.moduleID,
      this.moduleFullName,
      this.moduleShortName,
      this.day,
      this.month,
      this.year,
      this.hour,
      this.minute,
      this.isTurnitinEnabled,
      this.createdUser,
      this.type});

  factory DeadlinesModel.fromJson(Map<String, dynamic> json) {
    return DeadlinesModel(
      assessmentID: json['AssessmentID'] ?? 0,
      moduleID: json['ModuleID'] ?? 0,
      moduleFullName: json['ModuleFullName'] ?? nullFixer,
      moduleShortName: json['ModuleShortName'] ?? nullFixer,
      day: json['Day'] ?? 0,
      month: json['Month'] ?? 0,
      year: json['Year'] ?? 0,
      hour: json['Hour'] ?? 0,
      minute: json['Minute'] ?? 0,
      isTurnitinEnabled: json['IsTurnitinEnabled'] ?? false,
      createdUser: json['CreatedUser'] ?? nullFixer,
      type: json['CourseworkTitle'] ?? nullFixer,
    );
  }
}
