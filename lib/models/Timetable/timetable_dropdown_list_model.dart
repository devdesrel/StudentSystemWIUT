import 'package:student_system_flutter/helpers/app_constants.dart';

class TimetableDropdownListModel {
  String text;
  String value;

  TimetableDropdownListModel({this.text, this.value});

  factory TimetableDropdownListModel.fromJson(Map<String, dynamic> json) {
    return TimetableDropdownListModel(
      text: json['Text'] ?? nullFixer,
      value: json['Value'] ?? nullFixer,
    );
  }
}
