class AcademicOffencesModel {
  String offenceID;
  String session;
  String semester;
  String moduleCode;
  String moduleName;
  String assessTitle;
  String weighting;
  String offenceNature;
  String outcome;
  String pointsGiven;
  String pointsAccu;
  String reportNumber;
  String offenceComment;
  String outcomeComment;

  AcademicOffencesModel({
    this.offenceID,
    this.session,
    this.semester,
    this.moduleCode,
    this.moduleName,
    this.assessTitle,
    this.weighting,
    this.offenceNature,
    this.outcome,
    this.pointsGiven,
    this.pointsAccu,
    this.reportNumber,
    this.offenceComment,
    this.outcomeComment,
  });

  factory AcademicOffencesModel.fromJson(Map<String, dynamic> json) {
    return AcademicOffencesModel(
      offenceID: json["aOffenceIDField"],
      session: json["sessionField"],
      semester: json["semesterField"],
      moduleCode: json["moduleCodeField"],
      moduleName: json["moduleNameField"],
      assessTitle: json["assessTitleField"],
      weighting: json["weightingField"],
      offenceNature: json["offenceNatureField"],
      outcome: json["outcomeField"],
      pointsGiven: json["pointsGivenField"],
      pointsAccu: json["pointsAccuField"],
      reportNumber: json["reportNumberField"],
      offenceComment: json["offenceCommentField"],
      outcomeComment: json["outcomeCommentField"],
    );
  }
}
