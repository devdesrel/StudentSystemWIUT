import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class FileDownloadBloc {
  List<DownloadFile> basicList = List();

  FileDownloadBloc() {
    _addFileToDownloadController.stream.listen((addition) {
      basicList.add(addition);
      _downloadingFilesList.add(basicList);
    });

    _removeItemFromDownloadingListController.stream.listen((url) {
      basicList.removeWhere((downloadFile) => downloadFile.url == url);
      _downloadingFilesList.add(basicList);
    });
  }

  final BehaviorSubject<List<DownloadFile>> _downloadingFilesList =
      BehaviorSubject<List<DownloadFile>>(seedValue: []);

  Sink<DownloadFile> get addFileToDownload => _addFileToDownloadController.sink;

  final _addFileToDownloadController = StreamController<DownloadFile>();

  Sink<String> get removeItemFromDownloadingList =>
      _removeItemFromDownloadingListController.sink;

  final _removeItemFromDownloadingListController = StreamController<String>();

  Stream<List<DownloadFile>> get items => _downloadingFilesList.stream;

  void dispose() {
    // _downloadingFilesList.close();
    _addFileToDownloadController.close();
    _removeItemFromDownloadingListController.close();
  }
}
