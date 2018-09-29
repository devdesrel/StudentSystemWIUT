import 'package:student_system_flutter/enums/ApplicationEnums.dart';

class CCMAddFeedbackPageModel {
  FeedbackViewType viewType;
  CCMFeedbackCategory depOrMod;
  int depOrModID;
  int feedbackType;

  CCMAddFeedbackPageModel(
      {this.viewType, this.depOrMod, this.depOrModID, this.feedbackType});
}
