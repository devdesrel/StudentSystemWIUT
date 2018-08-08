import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class LearningMaterialsBloc {
  String moduleName = '';
  List<DownloadFileModel> basicList = List();
  final flushBar = Flushbar<bool>()
    ..icon = Icon(
      Icons.info,
      color: Colors.white,
    )
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

    _setLearningMaterialTypeController.stream.listen((type) {
      _learningMaterialTypeSubject.add(type);
    });
  }

  Sink<DownloadFileModel> get addFileToDownload =>
      _addFileToDownloadController.sink;

  final _addFileToDownloadController = StreamController<DownloadFileModel>();

  Sink<String> get removeItemFromDownloadingList =>
      _removeItemFromDownloadingListController.sink;

  final _removeItemFromDownloadingListController = StreamController<String>();

  Sink<String> get setLearningMaterialType =>
      _setLearningMaterialTypeController.sink;

  final _setLearningMaterialTypeController = StreamController<String>();

  Stream<List<DownloadFileModel>> get downloadingFilesList =>
      _downloadingFilesListSubject.stream;

  Stream<String> get learningMaterialType =>
      _learningMaterialTypeSubject.stream;

  final _learningMaterialTypeSubject = BehaviorSubject<String>();

  final _downloadingFilesListSubject =
      BehaviorSubject<List<DownloadFileModel>>();

  void dispose() {
    _addFileToDownloadController.close();
    _removeItemFromDownloadingListController.close();
    _downloadingFilesListSubject.close();
    _setLearningMaterialTypeController.close();
    _learningMaterialTypeSubject.close();
  }

  Future<List<DownloadFileModel>> getFileUrlsToDownload(
      BuildContext context, int materialID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      final response = await http.post(
          "$apiGetAttachmentsByModuleMaterialIDWithFileSize?ModuleMaterialID=$materialID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseJson(response.body);
      } else {
        showFlushBar('Error', tryAgain, 2, redColor, context);
        return null;
      }
    } catch (e) {
      showFlushBar(
          connectionFailure, checkInternetConnection, 5, redColor, context);
      return null;
    }
  }

  List<DownloadFileModel> _parseJson(String responseBody) {
    final parsed = json.decode(responseBody);

    List<DownloadFileModel> lists = parsed
        .map<DownloadFileModel>((item) => DownloadFileModel.fromJson(item))
        .toList();

    return lists;
  }
}
