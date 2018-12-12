import 'package:student_system_flutter/helpers/app_constants.dart';

class SocialContentModel {
  int id;
  String postedDate;
  int postedById;
  String text;
  String userName;
  bool isLiked;
  int likesCount;
  bool canEditandDelete;

  SocialContentModel(
      {this.id,
      this.postedDate,
      this.canEditandDelete,
      this.isLiked,
      this.likesCount,
      this.postedById,
      this.text,
      this.userName});
  factory SocialContentModel.fromJson(Map<String, dynamic> json) {
    return SocialContentModel(
        id: json['Id'] ?? nullFixer,
        postedDate: json['PostedDate'] ?? nullFixer,
        postedById: json['PostedBy'] ?? 0,
        text: json['Text'] ?? nullFixer,
        userName: json['UserName'] ?? nullFixer,
        isLiked: json['IsLiked'] ?? false,
        likesCount: json['LikesCount'] ?? 0,
        canEditandDelete: json['CanEditAndDelete'] ?? false);
  }
}
