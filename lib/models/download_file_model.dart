import 'package:student_system_flutter/helpers/app_constants.dart';

class DownloadFileModel {
  int id;
  String url;
  String fileName;
  String fileSize;
  String folderName = '';

  DownloadFileModel({this.id, this.url, this.fileName, this.fileSize});

  factory DownloadFileModel.fromJson(Map<String, dynamic> json) {
    return DownloadFileModel(
      id: json['ID'],
      url: json['Url'] ?? nullFixer,
      fileName: json['Name'] ?? nullFixer,
      fileSize: json['FileSize'] ?? '0',
    );
  }
}
