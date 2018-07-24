import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class FileDownloadBloc {
  List<DownloadFileModel> basicList = List();

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

  final BehaviorSubject<List<DownloadFileModel>> _downloadingFilesList =
      BehaviorSubject<List<DownloadFileModel>>(seedValue: []);

  Sink<DownloadFileModel> get addFileToDownload =>
      _addFileToDownloadController.sink;

  final _addFileToDownloadController = StreamController<DownloadFileModel>();

  Sink<String> get removeItemFromDownloadingList =>
      _removeItemFromDownloadingListController.sink;

  final _removeItemFromDownloadingListController = StreamController<String>();

  Stream<List<DownloadFileModel>> get items => _downloadingFilesList.stream;

  void dispose() {
    // _downloadingFilesList.close();
    _addFileToDownloadController.close();
    _removeItemFromDownloadingListController.close();
  }
}
