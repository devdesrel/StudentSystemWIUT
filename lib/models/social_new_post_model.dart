// {
//   "ParentId": 0,
//   "ContentText": "string",
//   "UploadImage": {
//     "ContentLength": 0,
//     "ContentType": "string",
//     "FileName": "string",
//     "InputStream": {
//       "__identity": {}
//     }
//   },
//   "ModuleId": 0,
//   "UserId": 0
// }
//TODO: modify and implement
import 'package:student_system_flutter/helpers/app_constants.dart';

class NewPostModel {
  int parentId;
  String text;
  String uploadFile;
  int moduleId;
  int userID;

  NewPostModel(
      {this.moduleId, this.parentId, this.text, this.uploadFile, this.userID});
  factory NewPostModel.toJson(Map<String, dynamic> json) {
    return NewPostModel(
        parentId: json['ParentId'] ?? nullFixer,
        text: json['ContentText'] ?? nullFixer,
        uploadFile: json['UploadImage'] ?? nullFixer,
        moduleId: json['ModuleId'] ?? nullFixer,
        userID: json['UserId'] ?? nullFixer);
  }
}
