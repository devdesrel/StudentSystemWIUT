import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/social_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SocialBloc {
  Future<List<SocialContentModel>> getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    int _userId = 7;
    int _pageId = 1;
    List<SocialContentModel> _contenList;
    try {
      Response response = await http.get("$socialGetContent/$_userId/$_pageId",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        _contenList = parsed
            .map<SocialContentModel>(
                (item) => SocialContentModel.fromJson(item))
            .toList();
      } else
        _contenList = null;
      return _contenList;
    } catch (e) {
      return null;
    }
  }

  addListToStream() async {
    await getContent().then((list) {
      print(list);
      _listOfContentSubject.add(list);
    });
  }

  SocialBloc() {
    addListToStream();
    // _getSocialContentListController.stream.listen((list){
    //   _listOfContentSubject.add(event)
    // })
  }

  // Sink<List<SocialContentModel>> get getSocialContentList =>
  //     _getSocialContentListController.sink;

  // final _getSocialContentListController =
  //     StreamController<List<SocialContentModel>>();

  Stream<List<SocialContentModel>> get listOfContent =>
      _listOfContentSubject.stream;

  final _listOfContentSubject = BehaviorSubject<List<SocialContentModel>>();

  dispose() {
    // _getSocialContentListController.close();
    _listOfContentSubject.close();
  }
}
