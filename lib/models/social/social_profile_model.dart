import 'package:student_system_flutter/helpers/app_constants.dart';

class SocialProfileModel {
  int followersCount;
  int followingsCount;
  int postCount;
  String profileImageURL;
  String firstName;
  String lastName;
  String email;
  String userName;
  String skype;
  String middleName;
  String gmail;
  String facebook;
  String twitter;
  String linkedIn;
  String gitHub;
  String stackOverFlow;
  String homePhone;
  String mobilePhone;
  String aboutMe;
  String officeHour;
  bool isAwailableForCCMFeedback;
  String aSSOfficerContent;
  String aSSOfficerSubject;
  String aSSOfficerColor;

  SocialProfileModel(
      {this.followersCount,
      this.followingsCount,
      this.postCount,
      this.profileImageURL,
      this.firstName,
      this.lastName,
      this.aSSOfficerColor,
      this.middleName,
      this.skype,
      this.aSSOfficerContent,
      this.aSSOfficerSubject,
      this.aboutMe,
      this.email,
      this.facebook,
      this.gitHub,
      this.gmail,
      this.homePhone,
      this.isAwailableForCCMFeedback,
      this.linkedIn,
      this.mobilePhone,
      this.officeHour,
      this.stackOverFlow,
      this.twitter,
      this.userName});
  factory SocialProfileModel.fromJson(Map<String, dynamic> json) {
    return SocialProfileModel(
        followersCount: json['FollowersCount'] ?? 0,
        followingsCount: json['FollowingsCount'] ?? 0,
        postCount: json['PostCount'] ?? 0,
        profileImageURL: json['ProfileImageUrl'],
        firstName: json['FirstName'] ?? nullFixer,
        lastName: json['LastName'] ?? nullFixer,
        email: json['Email'] ?? nullFixer,
        userName: json['UserName'] ?? nullFixer,
        skype: json['Skype'] ?? nullFixer,
        middleName: json['MiddleName'] ?? nullFixer,
        gmail: json['Gmail'] ?? nullFixer,
        facebook: json['Facebook'] ?? nullFixer,
        twitter: json['Twitter'] ?? nullFixer,
        linkedIn: json['Linkedin'] ?? nullFixer,
        gitHub: json['Github'] ?? nullFixer,
        stackOverFlow: json['StackOverflow'] ?? nullFixer,
        homePhone: json['HomePhone'] ?? nullFixer,
        mobilePhone: json['MobilePhone'] ?? nullFixer,
        aboutMe: json['AboutMe'] ?? nullFixer,
        officeHour: json['OfficeHours'] ?? nullFixer,
        isAwailableForCCMFeedback:
            json['IsAvailableForCCMFeedback'] ?? nullFixer,
        aSSOfficerContent: json['ASSOfficerContent'] ?? nullFixer,
        aSSOfficerSubject: json['ASSOfficerSubject'] ?? nullFixer,
        aSSOfficerColor: json['ASSOfficerColor'] ?? nullFixer);
  }
}
