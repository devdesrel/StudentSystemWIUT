import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/settings/settings_bloc.dart';

class SettingsProvider extends InheritedWidget {
  final SettingsBloc settingsBloc;

  SettingsProvider({
    Key key,
    SettingsBloc settingsBloc,
    Widget child,
  })  : settingsBloc = settingsBloc ?? SettingsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SettingsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SettingsProvider)
              as SettingsProvider)
          .settingsBloc;
}
