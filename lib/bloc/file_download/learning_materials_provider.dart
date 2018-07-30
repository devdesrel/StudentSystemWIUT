import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';

class LearningMaterialsProvider extends InheritedWidget {
  final LearningMaterialsBloc fileDownloadBloc;

  LearningMaterialsProvider({
    Key key,
    LearningMaterialsBloc fileDownloadBloc,
    Widget child,
  })  : fileDownloadBloc = fileDownloadBloc ?? LearningMaterialsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LearningMaterialsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LearningMaterialsProvider)
              as LearningMaterialsProvider)
          .fileDownloadBloc;
}
