import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/Timetable/timetable_dropdown_list_model.dart';

class TimetableBloc {
  List<TimetableDropdownListModel> groupsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> roomsListDropdown =
      List<TimetableDropdownListModel>();
  List<TimetableDropdownListModel> teachersListDropdown =
      List<TimetableDropdownListModel>();

  TimetableBloc() {
    _populateDropdownList(apiGetGroups).then((groupsList) {
      groupsListDropdown = groupsList;

      TimetableDropdownListModel model =
          TimetableDropdownListModel(text: '', value: '');

      groupsListDropdown.insert(0, model);
    });

    _populateDropdownList(apiGetRooms).then((roomsList) {
      roomsListDropdown = roomsList;

      TimetableDropdownListModel model =
          TimetableDropdownListModel(text: '', value: '');

      roomsListDropdown.insert(0, model);
    });

    _populateDropdownList(apiGetTeachers).then((teachersList) {
      teachersListDropdown = teachersList;

      TimetableDropdownListModel model =
          TimetableDropdownListModel(text: '', value: '');

      teachersListDropdown.insert(0, model);
      _isLoadedSubject.add(true);
    });

    _setGroupController.stream.listen((group) {
      _groupNameSubject.add(group);
      _roomNameSubject.add('');
      _teacherNameSubject.add('');
    });

    _setRoomController.stream.listen((room) {
      _roomNameSubject.add(room);
      _groupNameSubject.add('');
      _teacherNameSubject.add('');
    });

    _setTeacherController.stream.listen((teacher) {
      _teacherNameSubject.add(teacher);
      _groupNameSubject.add('');
      _roomNameSubject.add('');
    });
  }

  Sink<String> get setGroup => _setGroupController.sink;

  final _setGroupController = StreamController<String>();
  Sink<String> get setRoom => _setRoomController.sink;

  final _setRoomController = StreamController<String>();

  Sink<String> get setTeacher => _setTeacherController.sink;

  final _setTeacherController = StreamController<String>();

  Stream<String> get groupName => _groupNameSubject.stream;

  final _groupNameSubject = BehaviorSubject<String>();

  Stream<String> get roomName => _roomNameSubject.stream;

  final _roomNameSubject = BehaviorSubject<String>();

  Stream<String> get teacherName => _teacherNameSubject.stream;

  final _teacherNameSubject = BehaviorSubject<String>();

  Stream<bool> get isLoaded => _isLoadedSubject.stream;

  final _isLoadedSubject = BehaviorSubject<bool>();

  Future<List<TimetableDropdownListModel>> _populateDropdownList(
      String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);

    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $_token"
    });

    if (response.statusCode == 200) {
      List<TimetableDropdownListModel> _groupsList = _parseJson(response.body);

      return _groupsList;
    } else {
      print('error');

      TimetableDropdownListModel model =
          TimetableDropdownListModel(text: '', value: '');

      return List<TimetableDropdownListModel>().add(model);
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

  void dispose() {
    _setGroupController.close();
    _setRoomController.close();
    _setTeacherController.close();
  }
}
