import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/new_post_bloc.dart';

import 'new_post_bloc.dart';

class NewPostProvider extends InheritedWidget {
  final NewPostBloc newPostBloc;

  NewPostProvider({
    Key key,
    NewPostBloc newPostBloc,
    Widget child,
  })  : newPostBloc = newPostBloc ?? NewPostBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static NewPostBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(NewPostProvider) as NewPostProvider)
          .newPostBloc;
}
