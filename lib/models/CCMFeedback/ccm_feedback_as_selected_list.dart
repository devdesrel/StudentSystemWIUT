import 'package:student_system_flutter/helpers/app_constants.dart';

class CCMFeedbackAsSelectedList {
  bool disabled;
  bool selected;
  String text;
  String value;

  CCMFeedbackAsSelectedList(
      {this.disabled, this.selected, this.text, this.value});

  factory CCMFeedbackAsSelectedList.fromJson(Map<String, dynamic> json) {
    return CCMFeedbackAsSelectedList(
      disabled: json['Disabled'] ?? false,
      selected: json['Selected'] ?? false,
      text: json['Text'] ?? nullFixer,
      value: json['Value'] ?? nullFixer,
    );
  }
}
