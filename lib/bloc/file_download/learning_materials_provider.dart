import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';

class LearningMaterialsProvider extends InheritedWidget {
  final LearningMaterialsBloc learningMaterialsBloc;

  LearningMaterialsProvider({
    Key key,
    LearningMaterialsBloc learningMaterialsBloc,
    Widget child,
  })  : learningMaterialsBloc =
            learningMaterialsBloc ?? LearningMaterialsBloc([]),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LearningMaterialsBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LearningMaterialsProvider)
              as LearningMaterialsProvider)
          .learningMaterialsBloc;
}
