import 'package:student_system_flutter/helpers/app_constants.dart';

class ModulesList {
  final List<Module> studentViewModuleMarksPropField;

  ModulesList({this.studentViewModuleMarksPropField});

  factory ModulesList.fromJson(Map<String, dynamic> json) {
    return ModulesList(
      studentViewModuleMarksPropField: json['studentViewModuleMarksPropField'],
    );
  }
}

class Module {
  final String moduleID;
  final String moduleName;
  final String moduleCode;
  final String level;
  final String credit;
  final String session;
  final String attempt;
  final String moduleMark;
  final String moduleGrade;

  Module({
    this.moduleID,
    this.moduleName,
    this.moduleCode,
    this.level,
    this.credit,
    this.session,
    this.attempt,
    this.moduleMark,
    this.moduleGrade,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
        moduleID: json['moduleIDField'] ?? nullFixer,
        moduleName: json['moduleNameField'] ?? nullFixer,
        moduleCode: json['moduleCodeField'] ?? nullFixer,
        level: json['levelField'] ?? nullFixer,
        credit: json['creditField'] ?? nullFixer,
        session: json['sessionField'] ?? nullFixer,
        attempt: json['attemptField'] ?? nullFixer,
        moduleMark: json['moduleMarkField'] ?? nullFixer,
        moduleGrade: json['moduleGradeField'] ?? nullFixer);
  }
}
