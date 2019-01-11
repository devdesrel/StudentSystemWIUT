import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/Timetable/timetable_dropdown_list_model.dart';
import 'package:student_system_flutter/models/Timetable/timetable_model.dart';

class TimetableBloc {
  TimetableBloc({
    this.context,
  }) {
    _getTimetable().then((list) {
      _timetableListSubject.add(list);
    });

    _populateDropdownList(apiGetGroups).then((list) {
      if (list != null) {
        groupsListDropdown = list;

        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        groupsListDropdown.insert(0, model);
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

      _timetableTitleSubject.add(group);
      _groupNameSubject.add(group);

      _roomNameSubject.add('');
      _teacherNameSubject.add('');

      // if (Platform.isAndroid) {
      //   _roomNameSubject.add('');
      //   _teacherNameSubject.add('');
      // } else {
      //   _roomNameSubject.add('Select room');
      //   _teacherNameSubject.add('Select teacher');
      // }
    });

    _setRoomController.stream.listen((room) {
      String _id = _getIdFromList(TimetableDropdownlinListType.Room, room);

      _timetableListSubject.add(null);

      _getTimetableList(TimetableDropdownlinListType.Room, _id).then((list) {
        _timetableListSubject.add(list);
      });

      _timetableTitleSubject.add(room);
      _roomNameSubject.add(room);

      _groupNameSubject.add('');
      _teacherNameSubject.add('');
      // if (Platform.isAndroid) {
      //   _groupNameSubject.add('');
      //   _teacherNameSubject.add('');
      // } else {
      //   _groupNameSubject.add('Select group');
      //   _teacherNameSubject.add('Select teacher');
      // }
    });

    _setTeacherController.stream.listen((teacher) {
      String _id =
          _getIdFromList(TimetableDropdownlinListType.Teacher, teacher);

      _timetableListSubject.add(null);

      _getTimetableList(TimetableDropdownlinListType.Teacher, _id).then((list) {
        _timetableListSubject.add(list);
      });

      _timetableTitleSubject.add(teacher);
      _teacherNameSubject.add(teacher);

      _groupNameSubject.add('');
      _roomNameSubject.add('');
      // if (Platform.isAndroid) {
      //   _groupNameSubject.add('');
      //   _roomNameSubject.add('');
      // } else {
      //   _groupNameSubject.add('Select group');
      //   _roomNameSubject.add('Select room');
      // }
    });

    _setCupertinoPickerGroupIndexController.stream.listen((groupIndex) {
      _cupertinoPickerGroupIndexSubject.add(groupIndex);
      cupertinoGroupIndex = groupIndex;
      groupScrollController =
          FixedExtentScrollController(initialItem: groupIndex);
      teacherScrollController = FixedExtentScrollController(initialItem: 0);
      roomScrollController = FixedExtentScrollController(initialItem: 0);
      cupertinoRoomIndex = 0;
      cupertinoTeacherIndex = 0;

      _groupNameSubject.add(groupsListDropdown[groupIndex].text);
      if (Platform.isAndroid) {
        _roomNameSubject.add('');
        _teacherNameSubject.add('');
      } else {
        _roomNameSubject.add('Select room');
        _teacherNameSubject.add('Select teacher');
      }
    });
    _setCupertinoPickerTeacherIndexController.stream.listen((teacherIndex) {
      _cupertinoPickerTeacherIndexSubject.add(teacherIndex);
      cupertinoTeacherIndex = teacherIndex;
      teacherScrollController =
          FixedExtentScrollController(initialItem: teacherIndex);
      groupScrollController = FixedExtentScrollController(initialItem: 0);
      roomScrollController = FixedExtentScrollController(initialItem: 0);
      cupertinoRoomIndex = 0;
      cupertinoGroupIndex = 0;

      _teacherNameSubject.add(teachersListDropdown[teacherIndex].text);
      if (Platform.isAndroid) {
        _roomNameSubject.add('');
        _groupNameSubject.add('');
      } else {
        _roomNameSubject.add('Select room');
        _groupNameSubject.add('Select group');
      }
    });
    _setCupertinoPickerRoomIndexController.stream.listen((roomIndex) {
      _cupertinoPickerRoomIndexSubject.add(roomIndex);
      cupertinoRoomIndex = roomIndex;
      roomScrollController =
          FixedExtentScrollController(initialItem: roomIndex);
      groupScrollController = FixedExtentScrollController(initialItem: 0);
      teacherScrollController = FixedExtentScrollController(initialItem: 0);
      cupertinoGroupIndex = 0;
      cupertinoTeacherIndex = 0;

      _roomNameSubject.add(roomsListDropdown[roomIndex].text);
      if (Platform.isAndroid) {
        _teacherNameSubject.add('');
        _groupNameSubject.add('');
      } else {
        _teacherNameSubject.add('Select teacher');
        _groupNameSubject.add('Select group');
      }
    });
  }

  void dispose() {
    _setGroupController.close();
    _setRoomController.close();
    _setTeacherController.close();
    _timetableTitleSubject.close();
    _cupertinoPickerGroupIndexSubject.close();
    _cupertinoPickerTeacherIndexSubject.close();
    _cupertinoPickerRoomIndexSubject.close();
    _setCupertinoPickerGroupIndexController.close();
    _setCupertinoPickerTeacherIndexController.close();
    _setCupertinoPickerRoomIndexController.close();
  }

  Sink<String> get setGroup => _setGroupController.sink;

  final _setGroupController = StreamController<String>();
  Sink<String> get setRoom => _setRoomController.sink;

  final _setRoomController = StreamController<String>();

  Sink<String> get setTeacher => _setTeacherController.sink;

  final _setTeacherController = StreamController<String>();
  //IOS picker
  Sink<int> get setCupertinoPickerGroupIndex =>
      _setCupertinoPickerGroupIndexController.sink;

  final _setCupertinoPickerGroupIndexController = StreamController<int>();
  Sink<int> get setCupertinoPickerTeacherIndex =>
      _setCupertinoPickerTeacherIndexController.sink;

  final _setCupertinoPickerTeacherIndexController = StreamController<int>();

  Sink<int> get setCupertinoPickerRoomIndex =>
      _setCupertinoPickerRoomIndexController.sink;

  final _setCupertinoPickerRoomIndexController = StreamController<int>();

  //

  Stream<List<TimetableModel>> get timetableList =>
      _timetableListSubject.stream;

  final _timetableListSubject =
      BehaviorSubject<List<TimetableModel>>(/*seedValue: [] */);

  Stream<String> get timetableTitle => _timetableTitleSubject.stream;

  final _timetableTitleSubject = BehaviorSubject<String>();

  Stream<String> get groupName => _groupNameSubject.stream;

  final _groupNameSubject = BehaviorSubject<String>();

  Stream<String> get roomName => _roomNameSubject.stream;

  final _roomNameSubject = BehaviorSubject<String>();

  Stream<String> get teacherName => _teacherNameSubject.stream;

  final _teacherNameSubject = BehaviorSubject<String>();

  Stream<bool> get isLoaded => _isLoadedSubject.stream;

  final _isLoadedSubject = BehaviorSubject<bool>();

  Stream<String> get timetableDate => _timetableDateSubject.stream;

  final _timetableDateSubject = BehaviorSubject<String>(seedValue: '');

  //IOS Picker

  Stream<int> get cupertinoPickerGroupIndex =>
      _cupertinoPickerGroupIndexSubject.stream;

  final _cupertinoPickerGroupIndexSubject = BehaviorSubject<int>();

  Stream<int> get cupertinoPickerTeacherIndex =>
      _cupertinoPickerTeacherIndexSubject.stream;

  final _cupertinoPickerTeacherIndexSubject = BehaviorSubject<int>();

  Stream<int> get cupertinoPickerRoomIndex =>
      _cupertinoPickerRoomIndexSubject.stream;

  final _cupertinoPickerRoomIndexSubject = BehaviorSubject<int>();

//

  BuildContext context;
  File jsonFile;
  Directory dir;
  bool fileExists = false;
  bool offlineMode = false;
  // Map<String, String> fileContent;

  List<TimetableDropdownListModel> groupsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> roomsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> teachersListDropdown =
      List<TimetableDropdownListModel>();

  int cupertinoGroupIndex;
  int cupertinoTeacherIndex;
  int cupertinoRoomIndex;

  CupertinoTimetablePickerType timetableFilterType =
      CupertinoTimetablePickerType.Group;

  FixedExtentScrollController groupScrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController teacherScrollController =
      FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController roomScrollController =
      FixedExtentScrollController(initialItem: 0);

  Future<List<TimetableModel>> _getTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userRole;
    _userRole = prefs.getString(userRole);

    if (_userRole == 'student') {
      String groupName = '';
      String _groupID = '';

      if (groupName == null || groupName == '') {
        groupName = prefs.getString(groupNameSharedPref) ?? '';
        _groupID = prefs.getString(groupID) ?? '';

        _timetableTitleSubject.add(groupName);
        _groupNameSubject.add(groupName);
      }

      if (groupName != '' && _groupID == '') {
        var list = await _populateDropdownList(apiGetGroups);

        if (list != null) {
          _groupID = list.firstWhere((group) => group.text == groupName).value;
          prefs.setString(groupID, _groupID);
        }
      }

      if (groupName == '') {
        showFlushBar(error, youDontHaveGroup, MessageTypes.ERROR, context, 2);

        return [];
      } else if (_groupID != '') {
        List<TimetableModel> _timetableList = await _getTimetableList(
            TimetableDropdownlinListType.Group, _groupID);

        return _timetableList;
      } else {
        showFlushBar(error, tryAgain, MessageTypes.ERROR, context, 2);
        return [];
      }
    } else {
      String _teacherID = '';
      String teacherName = '';

      if (teacherName == null || teacherName == '') {
        teacherName = prefs.getString(teacherNameSharedPref) ?? '';
        _teacherID = prefs.getString(teacherID) ?? '';

        _timetableTitleSubject.add(teacherName);
        _teacherNameSubject.add(teacherName);
      }

      if (teacherName != '' && _teacherID == '') {
        var list = await _populateDropdownList(apiGetTeachers);

        if (list != null) {
          _teacherID =
              list.firstWhere((teacher) => teacher.text == teacherName).value;
          prefs.setString(teacherID, _teacherID);
        }
      }

      if (teacherName == '') {
        showFlushBar(error, youDontHaveGroup, MessageTypes.ERROR, context, 2);

        return [];
      } else if (_teacherID != '') {
        List<TimetableModel> _timetableList = await _getTimetableList(
            TimetableDropdownlinListType.Teacher, _teacherID);

        return _timetableList;
      } else {
        showFlushBar(error, tryAgain, MessageTypes.ERROR, context, 2);
        return [];
      }
    }
  }

  List<TimetableModel> _parseTimetable(String responseBody) {
    final parsed = json.decode(responseBody);

    List<TimetableModel> lists = parsed
        .map<TimetableModel>((item) => TimetableModel.fromJson(item))
        .toList();

    _timetableDateSubject.add(offlineMode
        ? '[OFFLINE MODE] Published on ${lists[0].timetableDate}'
        : 'Published on ${lists[0].timetableDate}');

    return lists;
  }

  Future<List<TimetableModel>> _getTimetableList(
      TimetableDropdownlinListType type, String _id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    var _url;

    switch (type) {
      case TimetableDropdownlinListType.Group:
        _url = '$apiGetLessons?classid=$_id';
        break;
      case TimetableDropdownlinListType.Room:
        _url = '$apiGetLessons?classroomid=$_id';
        break;
      case TimetableDropdownlinListType.Teacher:
        _url = '$apiGetLessons?teacherid=$_id';
        break;
      default:
        _url = '$apiGetLessons?classid=$_id';
    }

    ConnectivityResult connectionStatus;
    final Connectivity _connectivity = new Connectivity();

    try {
      connectionStatus = await _connectivity.checkConnectivity();
      if (connectionStatus == ConnectivityResult.none) {
        showFlushBar(connectionFailure, checkInternetConnection,
            MessageTypes.ERROR, context, 1);
        offlineMode = true;
        return _getTimetableJsonFromPhoneStorage();
      } else {
        final response = await http.get(_url, headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        });

        if (response.statusCode == 200) {
          _saveJsonToFileSystem('timetable.json', response.body);
          List<TimetableModel> _timetableList = _parseTimetable(response.body);
          List<TimetableModel> _sortedList = [];

          for (var i = 0; i < _timetableList.length; i++) {
            var item = _timetableList[i];

            if (_sortedList.any((t) =>
                t.subjectshort == item.subjectshort &&
                t.dayOfWeek == item.dayOfWeek &&
                t.classshort == item.classshort &&
                t.teachershort == item.teachershort)) {
              int _position = _sortedList.indexOf(_sortedList.firstWhere((t) =>
                  t.subjectshort == item.subjectshort &&
                  t.dayOfWeek == item.dayOfWeek &&
                  t.classshort == item.classshort &&
                  t.teachershort == item.teachershort));

              String _period = _sortedList
                      .firstWhere((t) =>
                          t.subjectshort == item.subjectshort &&
                          t.dayOfWeek == item.dayOfWeek &&
                          t.classshort == item.classshort &&
                          t.teachershort == item.teachershort)
                      .period +
                  ' ' +
                  item.period;

              String _fromTime = _period.substring(0, _period.indexOf('-'));
              String _endTime = _period
                  .substring(_period.lastIndexOf('-'), _period.length)
                  .trim();

              _sortedList.elementAt(_position).period = _fromTime + _endTime;
            } else {
              _sortedList.add(item);
            }
          }

          return _sortedList;
        } else {
          showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        }
      }
    } catch (e) {
      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);

    }
    return [];

    // return compute(parseGroups, response.body);
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
        List<TimetableDropdownListModel> _list = _parseJson(response.body);

        return _list;
      } else {
        TimetableDropdownListModel model =
            TimetableDropdownListModel(text: '', value: '');

        return <TimetableDropdownListModel>[model];
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

  Future<List<TimetableModel>> _getTimetableJsonFromPhoneStorage() async {
    String _timetableJson;

    Directory directory = await getApplicationDocumentsDirectory();

    dir = directory;
    jsonFile = new File(dir.path + '/timetable.json');
    fileExists = jsonFile.existsSync();

    if (fileExists) {
      _timetableJson = jsonFile.readAsStringSync();

      List<TimetableModel> _timetableList = _parseTimetable(_timetableJson);
      List<TimetableModel> _sortedList = [];

      for (var i = 0; i < _timetableList.length; i++) {
        var item = _timetableList[i];

        if (_sortedList.any((t) =>
            t.subjectshort == item.subjectshort &&
            t.dayOfWeek == item.dayOfWeek &&
            t.classshort == item.classshort &&
            t.teachershort == item.teachershort)) {
          int _position = _sortedList.indexOf(_sortedList.firstWhere((t) =>
              t.subjectshort == item.subjectshort &&
              t.dayOfWeek == item.dayOfWeek &&
              t.classshort == item.classshort &&
              t.teachershort == item.teachershort));

          String _period = _sortedList
                  .firstWhere((t) =>
                      t.subjectshort == item.subjectshort &&
                      t.dayOfWeek == item.dayOfWeek &&
                      t.classshort == item.classshort &&
                      t.teachershort == item.teachershort)
                  .period +
              ' ' +
              item.period;

          String _fromTime = _period.substring(0, _period.indexOf('-'));
          String _endTime = _period
              .substring(_period.lastIndexOf('-'), _period.length)
              .trim();

          _sortedList.elementAt(_position).period = _fromTime + _endTime;
        } else {
          _sortedList.add(item);
        }
      }

      return _sortedList;
    } else
      return null;
  }
}
