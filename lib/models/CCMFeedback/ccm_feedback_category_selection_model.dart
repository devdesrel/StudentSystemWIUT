import 'package:student_system_flutter/helpers/app_constants.dart';

class CCMFeedbackCategorySelectedModel {
  bool disabled;
  bool selected;
  String name;
  String value;

  CCMFeedbackCategorySelectedModel(
      {this.disabled, this.selected, this.name, this.value});

  factory CCMFeedbackCategorySelectedModel.fromJson(Map<String, dynamic> json) {
    return CCMFeedbackCategorySelectedModel(
      disabled: json['Disabled'] ?? nullFixer,
      selected: json['Selected'] ?? nullFixer,
      name: json['Text'] ?? nullFixer,
      value: json['Value'] ?? nullFixer,
    );
  }
}
