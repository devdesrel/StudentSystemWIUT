import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class LearningMaterialsBloc {
  List<DownloadFileModel> basicList = List();
  final flushBar = Flushbar<bool>()
    ..title = downloadingMessageTitle
    ..message = downloadingMessageBody
    ..backgroundColor = greyColor;

  LearningMaterialsBloc() {
    _addFileToDownloadController.stream.listen((addition) {
      //Start downloading
      // _downloadFile(addition.url, addition.fileName);

      basicList.add(addition);
      _downloadingFilesListSubject.add(basicList);
    });

    _removeItemFromDownloadingListController.stream.listen((url) {
      basicList.removeWhere((downloadFile) => downloadFile.url == url);
      if (basicList.length == 0) {
        _downloadingFilesListSubject.add([]);
        flushBar.dismiss();
      }
    });
  }

  Sink<DownloadFileModel> get addFileToDownload =>
      _addFileToDownloadController.sink;

  final _addFileToDownloadController = StreamController<DownloadFileModel>();

  Sink<String> get removeItemFromDownloadingList =>
      _removeItemFromDownloadingListController.sink;

  final _removeItemFromDownloadingListController = StreamController<String>();

  Stream<List<DownloadFileModel>> get downloadingFilesList =>
      _downloadingFilesListSubject.stream;

  final _downloadingFilesListSubject =
      BehaviorSubject<List<DownloadFileModel>>();

  void dispose() {
    // _downloadingFilesList.close();
    _addFileToDownloadController.close();
    _removeItemFromDownloadingListController.close();
    _downloadingFilesListSubject.close();
  }
}
