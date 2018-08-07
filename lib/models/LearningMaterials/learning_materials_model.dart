import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/LearningMaterials/single_learning_material_model.dart';

class LearningMaterialsModel {
  int moduleID;
  String moduleCode;
  String moduleName;
  String level;
  String period;
  List<SingleLearningMaterialsModel> moduleMaterial;

  LearningMaterialsModel(
      {this.moduleID,
      this.moduleCode,
      this.moduleName,
      this.level,
      this.period,
      this.moduleMaterial});

  factory LearningMaterialsModel.fromJson(Map<String, dynamic> json) {
    return LearningMaterialsModel(
        moduleID: json['ModuleID'],
        moduleCode: json['ModuleCode'] ?? nullFixer,
        moduleName: json['ModuleName'] ?? nullFixer,
        level: json['Level'] ?? nullFixer,
        period: json['Period'] ?? nullFixer,
        moduleMaterial: json['ModuleMaterial']
                .map<SingleLearningMaterialsModel>(
                    (item) => SingleLearningMaterialsModel.fromJson(item))
                .toList() ??
            []);
  }
}

// List<LearningMaterialsModel> lists = parsed
//         .map<LearningMaterialsModel>(
//             (item) => LearningMaterialsModel.fromJson(item))
//         .toList();
