import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class NewPostBloc {
  List<File> filesList = List();
  String text;
  NewPostBloc() {
    _addWidgetController.stream.listen((newFileName) {
      filesList.add(newFileName);
      _postItemsSubject.add(filesList);
    });
    _postTextController.stream.listen((data) {
      text = data ?? '';
    });
  }

  Future<bool> createPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    bool result;
    try {
      Response response = await http.post('$apiSocialCreateContent', headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      }, body: {
        "ContentText": "$text",
        "UserId": '$_userId'
      });

      if (response.statusCode == 200) {
        result = true;
        print('post uploaded');
      } else {
        result = false;
        print("Probleeem" + response.statusCode.toString());
      }
    } catch (e) {
      result = false;
      print(e);
    }
    return result;
  }

  Sink<File> get addWidget => _addWidgetController.sink;

  final _addWidgetController = StreamController<File>();
  Sink<String> get postText => _postTextController.sink;

  final _postTextController = StreamController<String>();

  Stream<List<File>> get postItems => _postItemsSubject.stream;

  final _postItemsSubject = BehaviorSubject<List<File>>.seeded([]);

  void dispose() {
    _addWidgetController.close();
    _postItemsSubject.close();
    _postTextController.close();
  }
}
