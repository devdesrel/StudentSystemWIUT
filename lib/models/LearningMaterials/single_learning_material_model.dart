import 'package:student_system_flutter/helpers/app_constants.dart';

class SingleLearningMaterialsModel {
  int id;
  String academicYear;
  String creator;
  String dateCreated;
  int academicYearID;
  String dateLastModified;
  String lastModifier;
  int materialTypeID;
  String title;

  SingleLearningMaterialsModel(
      {this.id,
      this.academicYear,
      this.creator,
      this.dateCreated,
      this.academicYearID,
      this.dateLastModified,
      this.lastModifier,
      this.materialTypeID,
      this.title});

  factory SingleLearningMaterialsModel.fromJson(Map<String, dynamic> json) {
    return SingleLearningMaterialsModel(
      id: json['ID'],
      academicYear: json['AcademicYear'] ?? nullFixer,
      creator: json['Creator'] ?? nullFixer,
      dateCreated: json['DateCreated'] ?? nullFixer,
      academicYearID: json['AcademicYearID'],
      dateLastModified: json['DateLastModified'] ?? nullFixer,
      lastModifier: json['LastModifier'] ?? nullFixer,
      materialTypeID: json['MaterialTypeID'],
      title: json['Title'] ?? nullFixer,
    );
  }
}
