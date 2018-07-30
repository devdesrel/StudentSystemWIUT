import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/security_page/security_page_bloc.dart';

class SecurityProvider extends InheritedWidget {
  final SecurityBloc securityBloc;

  SecurityProvider({
    Key key,
    SecurityBloc securityBloc,
    Widget child,
  })  : securityBloc = securityBloc ?? SecurityBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SecurityBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SecurityProvider)
              as SecurityProvider)
          .securityBloc;
}
