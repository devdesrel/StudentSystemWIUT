import 'package:student_system_flutter/helpers/app_constants.dart';

class DeadlinesModel {
  String moduleFullName;
  String moduleShortName;
  int day;
  int month;
  int year;
  int hour;
  int minute;
  bool isTurnitinEnabled;
  String createdUser;

  DeadlinesModel(
      {this.moduleFullName,
      this.moduleShortName,
      this.day,
      this.month,
      this.year,
      this.hour,
      this.minute,
      this.isTurnitinEnabled,
      this.createdUser});

  factory DeadlinesModel.fromJson(Map<String, dynamic> json) {
    return DeadlinesModel(
      moduleFullName: json['ModuleFullName'] ?? nullFixer,
      moduleShortName: json['ModuleShortName'] ?? nullFixer,
      day: json['Day'] ?? 0,
      month: json['Month'] ?? 0,
      year: json['Year'] ?? 0,
      hour: json['Hour'] ?? 0,
      minute: json['Minute'] ?? 0,
      isTurnitinEnabled: json['IsTurnitinEnabled'] ?? false,
      createdUser: json['CreatedUser'] ?? nullFixer,
    );
  }
}
