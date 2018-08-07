import 'package:student_system_flutter/helpers/app_constants.dart';

class ModuleComponentModel {
  String assessComponentID;
  String thresholdPassMark;
  String assessCode;
  String assessTitle;
  String weighting;
  String mark;
  String grade;
  String attempt;
  String isVisible;
  String isVisible9;
  String parentAssessCompID;
  String n;

  ModuleComponentModel(
      {this.assessComponentID,
      this.thresholdPassMark,
      this.assessCode,
      this.assessTitle,
      this.weighting,
      this.mark,
      this.grade,
      this.attempt,
      this.isVisible,
      this.isVisible9,
      this.parentAssessCompID,
      this.n});

  factory ModuleComponentModel.fromJson(Map<String, dynamic> json) {
    return ModuleComponentModel(
      assessComponentID: json['assessComponentIDField'] ?? nullFixer,
      thresholdPassMark: json['thresholdPassMarkField'] ?? nullFixer,
      assessCode: json['assessCodeField'] ?? nullFixer,
      assessTitle: json['assessTitleField'] ?? nullFixer,
      weighting: json['weightingField'] ?? nullFixer,
      mark: json['markField'] ?? nullFixer,
      grade: json['gradeField'] ?? nullFixer,
      attempt: json['attemptField'] ?? nullFixer,
      isVisible: json['isVisibleField'] ?? nullFixer,
      isVisible9: json['isVisible9Field'] ?? nullFixer,
      parentAssessCompID: json['parentAssessCompIDField'] ?? nullFixer,
      n: json['nField'] ?? nullFixer,
    );
  }
}
