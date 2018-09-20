import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_bloc.dart';

class CCMFeedbackProvider extends InheritedWidget {
  final CCMFeedbackBloc ccmFeedbackBloc;

  CCMFeedbackProvider({
    Key key,
    CCMFeedbackBloc ccmFeedbackBloc,
    Widget child,
  })  : ccmFeedbackBloc = ccmFeedbackBloc ?? CCMFeedbackBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CCMFeedbackBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CCMFeedbackProvider)
              as CCMFeedbackProvider)
          .ccmFeedbackBloc;
}
