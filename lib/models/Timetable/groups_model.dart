import 'package:student_system_flutter/helpers/app_constants.dart';

class GroupsModel {
  String id;
  String name;
  String short;
  String teacherID;
  String classRoomIDs;
  String grade;

  GroupsModel(
      {this.id,
      this.name,
      this.short,
      this.teacherID,
      this.classRoomIDs,
      this.grade});

  factory GroupsModel.fromJson(Map<String, dynamic> json) {
    return GroupsModel(
        id: json['ID'] ?? nullFixer,
        name: json['Name'] ?? nullFixer,
        short: json['Short'] ?? nullFixer,
        teacherID: json['TeacherID'] ?? nullFixer,
        classRoomIDs: json['ClassRoomIDs'] ?? nullFixer,
        grade: json['Grade'] ?? nullFixer);
  }
}
