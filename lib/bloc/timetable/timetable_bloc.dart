import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/Timetable/groups_model.dart';
import 'package:student_system_flutter/models/Timetable/timetable_dropdown_list_model.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

class TimetableBloc {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  File jsonFile;
  Directory dir;
  bool fileExists = false;
  Map<String, String> fileContent;
  String _groupName = '6BIS1';

  List<TimetableDropdownListModel> groupsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> roomsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> teachersListDropdown =
      List<TimetableDropdownListModel>();

  TimetableBloc() {
    _getTimetable(_groupName).then((list) {
      _timetableListSubject.add(list);
    });

    _populateDropdownList(apiGetGroups).then((list) {
      if (list != null) {
        groupsListDropdown = list;

        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        groupsListDropdown.insert(0, model);

        _groupNameSubject.add(_groupName);
      }
    });

    _populateDropdownList(apiGetRooms).then((list) {
      if (list != null) {
        roomsListDropdown = list;

        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        roomsListDropdown.insert(0, model);
      }
    });

    _populateDropdownList(apiGetTeachers).then((list) {
      if (list != null) {
        teachersListDropdown = list;

        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        teachersListDropdown.insert(0, model);
        _isLoadedSubject.add(true);
      }
    });

    _setGroupController.stream.listen((group) {
      String _id = _getIdFromList(TimetableDropdownlinListType.Group, group);

      _timetableListSubject.add(null);

      _getTimetableList(TimetableDropdownlinListType.Group, _id).then((list) {
        _timetableListSubject.add(list);
      });

      _groupNameSubject.add(group);
      _roomNameSubject.add('');
      _teacherNameSubject.add('');
    });

    _setRoomController.stream.listen((room) {
      String _id = _getIdFromList(TimetableDropdownlinListType.Room, room);

      _timetableListSubject.add(null);

      _getTimetableList(TimetableDropdownlinListType.Room, _id).then((list) {
        _timetableListSubject.add(list);
      });
      _roomNameSubject.add(room);
      _groupNameSubject.add('');
      _teacherNameSubject.add('');
    });

    _setTeacherController.stream.listen((teacher) {
      String _id =
          _getIdFromList(TimetableDropdownlinListType.Teacher, teacher);

      _timetableListSubject.add(null);

      _getTimetableList(TimetableDropdownlinListType.Teacher, _id).then((list) {
        _timetableListSubject.add(list);
      });
      _teacherNameSubject.add(teacher);
      _groupNameSubject.add('');
      _roomNameSubject.add('');
    });
  }

  void dispose() {
    _setGroupController.close();
    _setRoomController.close();
    _setTeacherController.close();
  }

  Sink<String> get setGroup => _setGroupController.sink;

  final _setGroupController = StreamController<String>();
  Sink<String> get setRoom => _setRoomController.sink;

  final _setRoomController = StreamController<String>();

  Sink<String> get setTeacher => _setTeacherController.sink;

  final _setTeacherController = StreamController<String>();

  Stream<List<TimetableModel>> get timetableList =>
      _timetableListSubject.stream;

  final _timetableListSubject =
      BehaviorSubject<List<TimetableModel>>(seedValue: []);

  Stream<String> get groupName => _groupNameSubject.stream;

  final _groupNameSubject = BehaviorSubject<String>();

  Stream<String> get roomName => _roomNameSubject.stream;

  final _roomNameSubject = BehaviorSubject<String>();

  Stream<String> get teacherName => _teacherNameSubject.stream;

  final _teacherNameSubject = BehaviorSubject<String>();

  Stream<bool> get isLoaded => _isLoadedSubject.stream;

  final _isLoadedSubject = BehaviorSubject<bool>();

  List<GroupsModel> _parseGroups(String responseBody) {
    final parsed = json.decode(responseBody);

    var lists =
        parsed.map<GroupsModel>((item) => GroupsModel.fromJson(item)).toList();

    return lists;
  }

  Future<List<TimetableModel>> _getTimetable(String groupName) async {
    String _groupID;

    var list = await _populateDropdownList(apiGetGroups);

    if (list != null) {
      _groupID = list.firstWhere((group) => group.text == groupName).value;

      List<TimetableModel> _timetableList =
          await _getTimetableList(TimetableDropdownlinListType.Group, _groupID);

      return _timetableList;
    } else {
      showSnackBar(checkInternetConnection, scaffoldKey, 5);
      return null;
    }
  }

  List<TimetableModel> _parseTimetable(String responseBody) {
    final parsed = json.decode(responseBody);

    List<TimetableModel> lists = parsed
        .map<TimetableModel>((item) => TimetableModel.fromJson(item))
        .toList();

    return lists;
  }

  Future<List<TimetableModel>> _getTimetableList(
      TimetableDropdownlinListType type, String _id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    var _url;

    switch (type) {
      case TimetableDropdownlinListType.Group:
        _url = '$apiGetLessons?classids=$_id';
        break;
      case TimetableDropdownlinListType.Room:
        _url = '$apiGetLessons?classroomids=$_id';
        break;
      case TimetableDropdownlinListType.Teacher:
        _url = '$apiGetLessons?teacherids=$_id';
        break;
      default:
        _url = '$apiGetLessons?classids=$_id';
    }

    try {
      final response = await http.get(_url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        _saveJsonToFileSystem('timetable.json', response.body);
        List<TimetableModel> _timetableList = _parseTimetable(response.body);
        List<TimetableModel> _sortedList = [];

        for (var item in _timetableList) {
          if (_sortedList.any((t) =>
              t.subjectshort == item.subjectshort &&
              t.dayOfWeek == item.dayOfWeek &&
              t.classshort == item.classshort)) {
            int _position = _sortedList.indexOf(_sortedList
                .where((t) => t.subjectshort == item.subjectshort)
                .first);

            String _period = _sortedList
                    .where((t) => t.subjectshort == item.subjectshort)
                    .first
                    .period +
                ' ' +
                item.period;

            _sortedList.elementAt(_position).period = _period;
          } else {
            _sortedList.add(item);
          }
        }

        return _sortedList;
      } else {
        showSnackBar(tryAgain, scaffoldKey);
        return null;
      }
    } catch (e) {
      showSnackBar(checkInternetConnection, scaffoldKey, 5);
      return null;
    }

    // return compute(parseGroups, response.body);
  }

  Future<List<TimetableDropdownListModel>> _populateDropdownList(
      String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    try {
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        List<TimetableDropdownListModel> _groupsList =
            _parseJson(response.body);

        return _groupsList;
      } else {
        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        return List<TimetableDropdownListModel>().add(model);
      }
    } catch (e) {
      return null;
    }
  }

  List<TimetableDropdownListModel> _parseJson(String responseBody) {
    final parsed = json.decode(responseBody);

    List<TimetableDropdownListModel> lists = parsed
        .map<TimetableDropdownListModel>(
            (item) => TimetableDropdownListModel.fromJson(item))
        .toList();

    return lists;
  }

  void _saveJsonToFileSystem(String fileName, String content) {
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();

      jsonFile.writeAsStringSync(content);
      // if (fileExists) this.setState(() => fileContent = JSON.decode(jsonFile.readAsStringSync()));
    });
  }

  String _getIdFromList(TimetableDropdownlinListType type, String name) {
    switch (type) {
      case TimetableDropdownlinListType.Group:
        return groupsListDropdown
            .firstWhere((group) => group.text == name)
            .value;
        break;
      case TimetableDropdownlinListType.Room:
        return roomsListDropdown.firstWhere((room) => room.text == name).value;
        break;
      case TimetableDropdownlinListType.Teacher:
        return teachersListDropdown
            .firstWhere((teacher) => teacher.text == name)
            .value;
        break;
      default:
        return nullFixer;
    }
  }
}
