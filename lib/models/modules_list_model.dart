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
  final String moduleIDField;
  final String moduleNameField;
  final String moduleCodeField;
  final String levelField;
  final String creditField;
  final String sessionField;
  final String attemptField;
  final String moduleMarkField;
  final String moduleGradeField;

  Module({
    this.moduleIDField,
    this.moduleNameField,
    this.moduleCodeField,
    this.levelField,
    this.creditField,
    this.sessionField,
    this.attemptField,
    this.moduleMarkField,
    this.moduleGradeField,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
        moduleIDField: json['moduleIDField'] ?? nullFixer,
        moduleNameField: json['moduleNameField'] ?? nullFixer,
        moduleCodeField: json['moduleCodeField'] ?? nullFixer,
        levelField: json['levelField'] ?? nullFixer,
        creditField: json['creditField'] ?? nullFixer,
        sessionField: json['sessionField'] ?? nullFixer,
        attemptField: json['attemptField'] ?? nullFixer,
        moduleMarkField: json['moduleMarkField'] ?? nullFixer,
        moduleGradeField: json['moduleGradeField'] ?? nullFixer);
  }
}
