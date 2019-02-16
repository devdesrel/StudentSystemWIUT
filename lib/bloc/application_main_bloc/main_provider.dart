import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/application_main_bloc/main_bloc.dart';

class MainProvider extends InheritedWidget {
  final MainBloc bloc;

  MainProvider({
    Key key,
    MainBloc bloc,
    Widget child,
  })  : bloc = bloc ?? MainBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MainBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(MainProvider) as MainProvider).bloc;
}
