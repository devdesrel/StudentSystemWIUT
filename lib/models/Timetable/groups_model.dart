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
        id: json['ID'],
        name: json['Name'],
        short: json['Short'],
        teacherID: json['TeacherID'],
        classRoomIDs: json['ClassRoomIDs'],
        grade: json['Grade']);
  }
}
