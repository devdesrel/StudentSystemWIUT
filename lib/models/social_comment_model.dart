class SocialCommentModel {
  int id;
  String postedDate;
  int postedById;
  String commentText;
  String postedByName;
  int postId;
  String avatarUrl;
  bool isLIked;
  int likesCount;
  bool canEditAndDelete;
  SocialCommentModel(
      {this.avatarUrl,
      this.likesCount,
      this.canEditAndDelete,
      this.commentText,
      this.id,
      this.isLIked,
      this.postId,
      this.postedById,
      this.postedByName,
      this.postedDate});
  factory SocialCommentModel.fromJson(Map<String, dynamic> json) {
    return SocialCommentModel(
        id: json['Id'],
        postedDate: json['PostedDate'],
        postedById: json['PostedBy'],
        commentText: json['Text'],
        postedByName: json['UserName'],
        postId: json['ParentId'],
        avatarUrl: json['AvatarFileUrl'],
        isLIked: json['IsLiked'],
        likesCount: json['LikesCount'],
        canEditAndDelete: json['CanEditAndDelete']);
  }
}
