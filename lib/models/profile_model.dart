import 'package:student_system_flutter/helpers/app_constants.dart';

class ProfileModel {
  String groupName;
  int acadYearIDField;

  ProfileModel({this.groupName, this.acadYearIDField});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      groupName: json['titleField'] ?? nullFixer,
      acadYearIDField: json['acadYearIDField'],
    );
  }
}
