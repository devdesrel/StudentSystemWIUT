import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/home_page/home_page_bloc.dart';

class HomePageProvider extends InheritedWidget {
  final HomePageBloc bloc;

  HomePageProvider({
    Key key,
    HomePageBloc bloc,
    Widget child,
  })  : bloc = bloc ?? HomePageBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HomePageBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(HomePageProvider)
              as HomePageProvider)
          .bloc;
}
