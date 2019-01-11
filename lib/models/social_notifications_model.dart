import 'package:student_system_flutter/helpers/app_constants.dart';

class SocialNotificationModel {
  String avatarUrl;
  int id;
  String notfiyText;
  String notifierName;
  String subscriberName;
  bool isRead;
  bool isViewed;
  String date;
  SocialNotificationModel(
      {this.avatarUrl,
      this.id,
      this.date,
      this.isRead,
      this.isViewed,
      this.notfiyText,
      this.notifierName,
      this.subscriberName});

  factory SocialNotificationModel.fromJson(Map<String, dynamic> json) {
    return SocialNotificationModel(
        avatarUrl: json['AvatarUrl'],
        id: json['Id'] ?? 0,
        notfiyText: json['NotifyText'] ?? nullFixer,
        notifierName: json['NotifierName'] ?? nullFixer,
        subscriberName: json['SubscriberName'] ?? nullFixer,
        isRead: json['IsRead'] ?? false,
        isViewed: json['IsViewed'] ?? false,
        date: json['CreateDate'] ?? nullFixer);
  }
}
