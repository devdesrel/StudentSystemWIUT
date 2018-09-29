import 'package:student_system_flutter/helpers/app_constants.dart';

class CCMFeedbackModuleModel {
  String moduleId;
  String moduleName;
  String academYear;
  String lacturer;
  String seminarLecturer;

  CCMFeedbackModuleModel({
    this.moduleId,
    this.moduleName,
    this.academYear,
    this.lacturer,
    this.seminarLecturer,
  });

  factory CCMFeedbackModuleModel.fromJson(Map<String, dynamic> json) {
    return CCMFeedbackModuleModel(
      moduleId: json['ID'] ?? nullFixer,
      moduleName: json['ModuleName'] ?? nullFixer,
      academYear: json['AcademYear'] ?? nullFixer,
      lacturer: json['Lecturer'] ?? nullFixer,
      seminarLecturer: json['SeminarLecturer'] ?? nullFixer,
    );
  }
}
