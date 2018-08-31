import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_bloc.dart';

class BackdropProvider extends InheritedWidget {
  final BackdropBloc bloc;

  BackdropProvider({
    Key key,
    BackdropBloc bloc,
    Widget child,
  })  : bloc = bloc ?? BackdropBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BackdropBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(BackdropProvider)
              as BackdropProvider)
          .bloc;
}
