import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_add_feedback_bloc.dart';

class CCMAddFeedbackProvider extends InheritedWidget {
  final CCMAddFeedbackBloc ccmAddFeedbackBloc;

  CCMAddFeedbackProvider({
    Key key,
    CCMAddFeedbackBloc ccmAddFeedbackBloc,
    Widget child,
  })  : ccmAddFeedbackBloc = ccmAddFeedbackBloc ?? CCMAddFeedbackBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CCMAddFeedbackBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CCMAddFeedbackProvider)
              as CCMAddFeedbackProvider)
          .ccmAddFeedbackBloc;
}
