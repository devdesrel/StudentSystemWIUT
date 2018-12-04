class AttendanceOffencesModel {
  String sessionField;
  String semesterField;
  String moduleCodeField;
  String moduleNameField;
  String outcomeField;
  String reportNumberField;
  String offenceCommentField;
  String outcomeCommentField;
  AttendanceOffencesModel({
    this.sessionField,
    this.semesterField,
    this.moduleCodeField,
    this.moduleNameField,
    this.outcomeField,
    this.reportNumberField,
    this.offenceCommentField,
    this.outcomeCommentField,
  });

  factory AttendanceOffencesModel.fromJson(Map<String, dynamic> json) {
    return AttendanceOffencesModel(
      sessionField: json['sessionField'],
      semesterField: json['semesterField'],
      moduleCodeField: json['moduleCodeField'],
      moduleNameField: json['moduleNameField'],
      outcomeField: json['outcomeField'],
      reportNumberField: json["reportNumberField"],
      offenceCommentField: json['offenceCommentField'],
      outcomeCommentField: json['outcomeCommentField'],
    );
  }
}
