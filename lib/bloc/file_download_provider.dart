import 'package:flutter/widgets.dart';

import 'file_download_bloc.dart';

class FileDownloadProvider extends InheritedWidget {
  final FileDownloadBloc fileDownloadBloc;

  FileDownloadProvider({
    Key key,
    FileDownloadBloc fileDownloadBloc,
    Widget child,
  })  : fileDownloadBloc = fileDownloadBloc ?? FileDownloadBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FileDownloadBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(FileDownloadProvider)
              as FileDownloadProvider)
          .fileDownloadBloc;
}
