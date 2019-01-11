import 'package:student_system_flutter/helpers/app_constants.dart';

class SocialSearchModel {
  String avatarUrl;
  String firstName;
  String lastName;
  int id;

  SocialSearchModel({this.avatarUrl, this.firstName, this.lastName, this.id});

  factory SocialSearchModel.fromJson(Map<String, dynamic> json) {
    return SocialSearchModel(
      avatarUrl: json['AvatarUrl'] ?? nullFixer,
      firstName: json['FirstName'] ?? nullFixer,
      lastName: json['LastName'] ?? nullFixer,
      id: json['Id'] ?? 0,
    );
  }
}
