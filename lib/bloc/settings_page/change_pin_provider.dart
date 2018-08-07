import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/settings_page/change_pin_bloc.dart';

class ChangePinProvider extends InheritedWidget {
  final ChangePinBloc changePinBloc;

  ChangePinProvider({
    Key key,
    ChangePinBloc changePinBloc,
    Widget child,
  })  : changePinBloc = changePinBloc ?? ChangePinBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ChangePinBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ChangePinProvider)
              as ChangePinProvider)
          .changePinBloc;
}
