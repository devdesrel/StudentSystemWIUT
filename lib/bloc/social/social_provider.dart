import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/social/social_bloc.dart';

class SocialProvider extends InheritedWidget {
  final SocialBloc socialBloc;

  SocialProvider({
    Key key,
    SocialBloc socialBloc,
    Widget child,
  })  : socialBloc = socialBloc ?? SocialBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SocialBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SocialProvider) as SocialProvider)
          .socialBloc;
}
