import 'package:student_system_flutter/helpers/app_constants.dart';

class CCMAddFeedbackModel {
  String type;
  bool isPositive;
  int depOrModID;
  int staffID;
  int groupCoverage;
  String text;

  CCMAddFeedbackModel(
      {this.type,
      this.isPositive,
      this.depOrModID,
      this.staffID,
      this.groupCoverage,
      this.text});

  factory CCMAddFeedbackModel.fromJson(Map<String, dynamic> json) {
    return CCMAddFeedbackModel(
      type: json['Type'] ?? nullFixer,
      isPositive: json['IsPositive'] ?? false,
      depOrModID: json['DepOrModID'] ?? nullFixer,
      staffID: json['StaffID'] ?? 0,
      groupCoverage: json['GroupCoverage'] ?? 0.0,
      text: json['Text'] ?? nullFixer,
    );
  }

  Map<String, dynamic> toJson() => {
        'Type': type,
        'IsPositive': isPositive,
        'DepOrModID': depOrModID,
        'StaffID': staffID,
        'GroupCoverage': groupCoverage,
        'Text': text,
      };
}
