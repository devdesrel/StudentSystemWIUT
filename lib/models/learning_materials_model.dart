import 'package:student_system_flutter/models/download_file_model.dart';

class LearningMaterialsModel {
  final String lectureName;
  final List<DownloadFileModel> downloadFilesList;

  LearningMaterialsModel(this.lectureName, this.downloadFilesList);
}
