class DisciplinaryOffencesModel {
  String session;
  String semester;
  String offencesNature;
  String outcome;
  String reportNumber;
  String offenceComment;
  String outcomeComment;
  String offenceID;
  String points;
  DisciplinaryOffencesModel(
      {this.session,
      this.semester,
      this.offencesNature,
      this.outcome,
      this.reportNumber,
      this.offenceComment,
      this.outcomeComment,
      this.offenceID,
      this.points});

  factory DisciplinaryOffencesModel.fromJson(Map<String, dynamic> json) {
    return DisciplinaryOffencesModel(
      session: json['sessionField'],
      semester: json['semesterField'],
      offencesNature: json['offenceNatureField'],
      outcome: json['outcomeField'],
      reportNumber: json['reportNumberField'],
      offenceComment: json["offenceCommentField"],
      outcomeComment: json['outcomeCommentField'],
      offenceID: json['dOffenceIDField'],
      points: json['pointsField'],
    );
  }
}
