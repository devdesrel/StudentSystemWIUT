import 'package:student_system_flutter/helpers/app_constants.dart';

class SocialContentModel {
  int id;
  String fileUrl;
  String postedDate;
  int postedById;
  String text;
  String userName;
  int commentsCount;
  String avatarUrl;
  bool isLiked;
  int likesCount;
  String fileContentType;
  bool canEditandDelete;

  SocialContentModel(
      {this.id,
      this.postedDate,
      this.canEditandDelete,
      this.isLiked,
      this.likesCount,
      this.postedById,
      this.text,
      this.userName,
      this.fileUrl,
      this.avatarUrl,
      this.commentsCount,
      this.fileContentType});
  factory SocialContentModel.fromJson(Map<String, dynamic> json) {
    return SocialContentModel(
        id: json['Id'] ?? nullFixer,
        fileUrl: json['FileUrl'],
        postedDate: json['PostedDate'] ?? nullFixer,
        postedById: json['PostedBy'] ?? 0,
        text: json['Text'] ?? nullFixer,
        userName: json['UserName'] ?? nullFixer,
        commentsCount: json['CommentsCount'] ?? 0,
        avatarUrl: json['AvatarFileUrl'],
        isLiked: json['IsLiked'] ?? false,
        likesCount: json['LikesCount'] ?? 0,
        fileContentType: json['FileContentType'],
        canEditandDelete: json['CanEditAndDelete'] ?? false);
  }
}
