class SocialProfileModel {
  int followersCount;
  int followingsCount;
  int postCount;
  String profileImageURL;
  SocialProfileModel(
      {this.followersCount,
      this.followingsCount,
      this.postCount,
      this.profileImageURL});
  factory SocialProfileModel.fromJson(Map<String, dynamic> json) {
    return SocialProfileModel(
        followersCount: json['FollowersCount'] ?? 0,
        followingsCount: json['FollowingsCount'] ?? 0,
        postCount: json['PostCount'] ?? 0,
        profileImageURL: json['ProfileImageUrl']);
  }
}
