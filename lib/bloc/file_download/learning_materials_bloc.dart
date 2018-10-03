import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/models/LearningMaterials/single_learning_material_model.dart';
import 'package:student_system_flutter/models/download_file_model.dart';
import 'package:screen/screen.dart';

class LearningMaterialsBloc {
  final flushBar = Flushbar<bool>()
    ..icon = Icon(
      Icons.info,
      color: Colors.white,
    )
    ..title = downloadingMessageTitle
    ..message = downloadingMessageBody
    ..backgroundColor = greyColor;

  String moduleName = '';
  String yearName = '2018/2019';
  String materialType = 'Lectures';
  int _moduleID = 0;
  int materialTypeID = 1;
  List<DownloadFileModel> basicList = List();
  List<SingleLearningMaterialsModel> allMaterialsList = [];

  LearningMaterialsBloc(BuildContext context, int moduleID,
      List<SingleLearningMaterialsModel> materialsList) {
    allMaterialsList = materialsList;

    _moduleID = moduleID;

    _setAcademicYearController.stream.listen((year) async {
      _materialsListSubject.add(null);
      _academicYearStreamSubject.add(yearName);

      allMaterialsList = await _getLearningMaterials(context, year);

      _materialsListSubject.add(allMaterialsList
          .where((item) => item.materialTypeID == materialTypeID)
          .toList());
    });

    //GET all lectures
    _materialsListSubject.add(
        allMaterialsList.where((item) => item.materialTypeID == 1).toList());

    _addFileToDownloadController.stream.listen((addition) {
      //Start downloading
      // _downloadFile(addition.url, addition.fileName);

      basicList.add(addition);
      _downloadingFilesListSubject.add(basicList);
      //To keep the screen on until dowloading is done
      Screen.keepOn(true);
    });

    _removeItemFromDownloadingListController.stream.listen((url) {
      basicList.removeWhere((downloadFile) => downloadFile.url == url);
      if (basicList.length == 0) {
        _downloadingFilesListSubject.add([]);
        flushBar.dismiss();
        //to let the screen turn of after downloading completion
        Screen.keepOn(false);
      }
    });

    _setLearningMaterialTypeController.stream.listen((typeID) {
      if (typeID == 1) {
        _learningMaterialTypeSubject.add('Lectures');
        materialType = 'Lectures';
      } else if (typeID == 2) {
        _learningMaterialTypeSubject.add('Tutorials');
        materialType = 'Tutorials';
      }

      materialTypeID = typeID;

      _materialsListSubject.add(null);
      var list = allMaterialsList
          .where((item) => item.materialTypeID == typeID)
          .toList();

      _materialsListSubject.add(list);
    });

    _setCurrentIndexController.stream.listen((index) {
      _currentIndexSubject.add(index);
    });
  }

  Sink<int> get setAcademicYear => _setAcademicYearController.sink;

  final _setAcademicYearController = StreamController<int>();

  Sink<DownloadFileModel> get addFileToDownload =>
      _addFileToDownloadController.sink;

  final _addFileToDownloadController = StreamController<DownloadFileModel>();

  Sink<String> get removeItemFromDownloadingList =>
      _removeItemFromDownloadingListController.sink;

  final _removeItemFromDownloadingListController = StreamController<String>();

  Sink<int> get setLearningMaterialType =>
      _setLearningMaterialTypeController.sink;

  final _setLearningMaterialTypeController = StreamController<int>();

  Sink<int> get setCurrentIndex => _setCurrentIndexController.sink;

  final _setCurrentIndexController = StreamController<int>();

  Stream<int> get currentIndex => _currentIndexSubject.stream;

  final _currentIndexSubject = BehaviorSubject<int>();

  Stream<List<SingleLearningMaterialsModel>> get materialsList =>
      _materialsListSubject.stream;

  final _materialsListSubject =
      BehaviorSubject<List<SingleLearningMaterialsModel>>(seedValue: []);

  Stream<List<DownloadFileModel>> get downloadingFilesList =>
      _downloadingFilesListSubject.stream;

  Stream<String> get learningMaterialType =>
      _learningMaterialTypeSubject.stream;

  final _learningMaterialTypeSubject = BehaviorSubject<String>();

  Stream<String> get academicYearStream => _academicYearStreamSubject.stream;

  final _academicYearStreamSubject = BehaviorSubject<String>();

  final _downloadingFilesListSubject =
      BehaviorSubject<List<DownloadFileModel>>();

  void dispose() {
    _setAcademicYearController.close();
    _materialsListSubject.close();
    _addFileToDownloadController.close();
    _removeItemFromDownloadingListController.close();
    _downloadingFilesListSubject.close();
    _setLearningMaterialTypeController.close();
    _learningMaterialTypeSubject.close();
    _academicYearStreamSubject.close();
    _setCurrentIndexController.close();
    _currentIndexSubject.close();
  }

  Future<List<SingleLearningMaterialsModel>> _getLearningMaterials(
      BuildContext context, int academicYear) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _studentID = prefs.getString(studentID);

    try {
      final response = await http.post(
          "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=$academicYear&SelectedLTType=All&UserID=$_studentID",
          // "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=$currentYearID&SelectedLTType=$materialType&UserID=$_studentID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseLearningMaterials(response.body);
      } else {
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  List<SingleLearningMaterialsModel> _parseLearningMaterials(
      String responseBody) {
    final parsed = json.decode(responseBody);

    List<LearningMaterialsModel> lists = parsed
        .map<LearningMaterialsModel>(
            (item) => LearningMaterialsModel.fromJson(item))
        .toList();

    return lists.firstWhere((m) => m.moduleID == _moduleID).moduleMaterial;
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
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
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
