import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

class NewPostBloc {
  List<File> filesList = List();
  NewPostBloc() {
    _addWidgetController.stream.listen((newFileName) {
      filesList.add(newFileName);
      _postItemsSubject.add(filesList);
    });
  }

  Sink<File> get addWidget => _addWidgetController.sink;

  final _addWidgetController = StreamController<File>();

  Stream<List<File>> get postItems => _postItemsSubject.stream;

  final _postItemsSubject = BehaviorSubject<List<File>>(seedValue: []);

  void dispose() {
    // _downloadingFilesList.close();
    _addWidgetController.close();
    _postItemsSubject.close();
  }
}
