import 'dart:async';
import 'dart:convert';
import 'dart:core';

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
    int _userId = 845;
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

  Future<int> getFollowersCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    int _userId = 7;
    try {
      Response response = await http.get("$socialGetFollowersCount/$_userId",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      var parsed = 0;
      if (response.statusCode == 200) {
        parsed = json.decode(response.body);
      }
      return parsed;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getFollowingCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    int _userId = 7;
    try {
      Response response = await http.get("$socialGetFollowingsCount/$_userId",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      var parsed = 0;
      if (response.statusCode == 200) {
        parsed = json.decode(response.body);
      }
      return parsed;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getPostCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    int _userId = 7;
    try {
      Response response = await http.get("$socialGetPostsCount/$_userId",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      var parsed = 0;
      if (response.statusCode == 200) {
        parsed = json.decode(response.body);
      }
      return parsed;
    } catch (e) {
      return 0;
    }
  }

  addListToStream() async {
    await getContent().then((list) {
      print(list);
      _listOfContentSubject.add(list);
    });
  }

  addFollowersToView() async {
    await getFollowersCount().then((e) {
      // print(e);
      _followersSubject.add(e);
    });
  }

  addFollowingToView() async {
    await getFollowingCount().then((e) {
      // print(e);
      _followingSubject.add(e);
    });
  }

  addPostToView() async {
    await getPostCount().then((e) {
      // print(e);
      _postCountSubject.add(e);
    });
  }

  SocialBloc() {
    addListToStream();
    addFollowersToView();
    addFollowingToView();
    addPostToView();

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

  Stream<int> get followers => _followersSubject.stream;

  final _followersSubject = BehaviorSubject<int>();

  Stream<int> get following => _followingSubject.stream;

  final _followingSubject = BehaviorSubject<int>();

  Stream<int> get postCount => _postCountSubject.stream;

  final _postCountSubject = BehaviorSubject<int>();

  dispose() {
    // _getSocialContentListController.close();
    _listOfContentSubject.close();
    _followersSubject.close();
    _followingSubject.close();
    _postCountSubject.close();
  }
}
