import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_bloc.dart';

class TimetableProvider extends InheritedWidget {
  final TimetableBloc timetableBloc;

  TimetableProvider({
    Key key,
    TimetableBloc timetableBloc,
    Widget child,
  })  : timetableBloc = timetableBloc ?? TimetableBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TimetableBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TimetableProvider)
              as TimetableProvider)
          .timetableBloc;
}
