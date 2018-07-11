import 'package:flutter/widgets.dart';

import 'coursework_upload_bloc.dart';

class CourseworkUploadProvider extends InheritedWidget {
  final CourseworkUploadBloc courseworkUploadBloc;

  CourseworkUploadProvider({
    Key key,
    CourseworkUploadBloc courseworkUploadBloc,
    Widget child,
  })  : courseworkUploadBloc = courseworkUploadBloc ?? CourseworkUploadBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CourseworkUploadBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(CourseworkUploadProvider)
              as CourseworkUploadProvider)
          .courseworkUploadBloc;
}
