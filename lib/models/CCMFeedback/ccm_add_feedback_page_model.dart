import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/models/CCMFeedback/ccm_feedback_model.dart';

class CCMAddFeedbackPageModel {
  CCMFeedbackModel feedback;
  FeedbackViewType viewType;
  CCMFeedbackCategory depOrMod;
  int depOrModID;
  int feedbackType;

  CCMAddFeedbackPageModel(
      {this.feedback,
      this.viewType,
      this.depOrMod,
      this.depOrModID,
      this.feedbackType});
}
