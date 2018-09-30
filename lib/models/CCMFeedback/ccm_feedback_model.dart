import 'package:student_system_flutter/helpers/app_constants.dart';

class CCMFeedbackModel {
  int id;
  String type;
  bool isPositive;
  int depOrModID;
  int staffID;
  String staffFullName;
  int groupCoverage;
  String text;
  String groupName;
  String dateCreated;
  String dateCreatedStr;
  bool isRepliable;

  CCMFeedbackModel(
      {this.id,
      this.type,
      this.isPositive,
      this.depOrModID,
      this.staffID,
      this.staffFullName,
      this.groupCoverage,
      this.text,
      this.groupName,
      this.dateCreated,
      this.dateCreatedStr,
      this.isRepliable});

  factory CCMFeedbackModel.fromJson(Map<String, dynamic> json) {
    return CCMFeedbackModel(
      id: json['ID'] ?? 0,
      type: json['Type'] ?? nullFixer,
      isPositive: json['IsPositive'] ?? true,
      depOrModID: json['DepOrModID'] ?? 0,
      staffID: json['StaffID'] ?? 0,
      staffFullName: json['StaffFullName'] ?? nullFixer,
      groupCoverage: json['GroupCoverage'] ?? 0.0,
      text: json['Text'] ?? nullFixer,
      groupName: json['GroupName'] ?? nullFixer,
      dateCreated: json['DateCreated'] ?? nullFixer,
      dateCreatedStr: json['DateCreatedStr'] ?? nullFixer,
      isRepliable: json['IsRepliable'] ?? false,
    );
  }
}
