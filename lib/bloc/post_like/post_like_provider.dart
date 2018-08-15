import 'package:flutter/widgets.dart';
import 'package:student_system_flutter/bloc/post_like/post_like_bloc.dart';

class PostLikeProvider extends InheritedWidget {
  final PostLikeBloc postLikebloc;

  PostLikeProvider({
    Key key,
    PostLikeBloc postLikebloc,
    Widget child,
  })  : postLikebloc = postLikebloc ?? PostLikeBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PostLikeBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(PostLikeProvider)
              as PostLikeProvider)
          .postLikebloc;
}
