import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/social_content_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/models/social_notifications_model.dart';
import 'package:student_system_flutter/models/social_profile_model.dart';

class SocialBloc {
  List<SocialContentModel> allContents;
  List<int> likedPostsList;

  Future<SocialProfileModel> getSocialProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    int userid = 845;
    SocialProfileModel profile;
    try {
      Response _response = await http.post("$apiSocialProfile/$userid",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (_response.statusCode == 200) {
        var parsed = json.decode(_response.body);

        profile = SocialProfileModel.fromJson(parsed);
      } else {
        profile = null;
      }
      return profile;
    } catch (e) {
      return null;
    }
  }

  int contentPageNumber = 1;

  Future<List<SocialContentModel>> getContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    // String _userId = prefs.getString(userID);
    String _userId = '00004141';
    // int _pageId = 1;
    List<SocialContentModel> _contenList;
    try {
      Response _response = await http
          .get("$socialGetContentList/845/$contentPageNumber/0", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (_response.statusCode == 200) {
        final parsed = json.decode(_response.body);

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

  Future<bool> likePost(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    bool _isSuccessful;
    try {
      Response _response = await http.post('$apiSocialLike/$_userId/$postId',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (_response.statusCode == 200) {
        print('like');
        _isSuccessful = true;
      } else {
        _isSuccessful = false;
      }
    } catch (e) {
      print(e);
    }

    return _isSuccessful;
  }

  Future<bool> unlikePost(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    bool _isSuccessful;
    try {
      Response _response = await http.post('$apiSocialUnlike/845/$postId',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (_response.statusCode == 200) {
        print('unliked');
        _isSuccessful = true;
      } else {
        _isSuccessful = false;
      }
    } catch (e) {
      print(e);
    }

    return _isSuccessful;
  }

  int notificationPageNumber = 1;
  Future<List<SocialNotificationModel>> getNotificationsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    List<SocialNotificationModel> _notificationsList;

    try {
      Response _response = await http
          .post('$apiSocialNotifications/7/$notificationPageNumber', headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });
      if (_response.statusCode == 200) {
        final parsed = json.decode(_response.body);

        _notificationsList = parsed
            .map<SocialNotificationModel>(
                (item) => SocialNotificationModel.fromJson(item))
            .toList();
        // .sort((SocialNotificationModel a, SocialNotificationModel b) =>
        //     DateTime.parse(a.date.toString())
        //         .compareTo(DateTime.parse(b.date.toString())));
      } else {
        _notificationsList = null;
      }
    } catch (e) {
      print(e);
    }
    return _notificationsList;
  }

  Future<String> _getNotificationsCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    var notificationsCount;
    try {
      Response _response = await http
          .post('$apiSocialNotificationCount/$_userId', headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (_response.statusCode == 200) {
        final parsed = json.decode(_response.body);
        notificationsCount = parsed['NotificationCount'];
        print(notificationsCount.toString());
      }
    } catch (e) {}
    return notificationsCount.toString();
  }

  addNotificationsList() async {
    await getNotificationsList().then((list) {
      _notificationsListSubject.add(list);
    });
  }

  addListToStream() async {
    await getContent().then((list) {
      print(list);
      allContents = list;
      _listOfContentSubject.add(allContents);
    });
  }

  loadMoreContentPage() async {
    await getContent().then((list) {
      list != [] ? allContents += list : allContents = allContents;
      _listOfContentSubject.add(allContents);
    });
  }

  getSocialProfileData() async {
    getSocialProfile().then((data) {
      _socialProfileSubject.add(data);
    });
  }

  contentIncrement() {
    contentPageNumber += 1;
  }

  checkUserTableID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString(userTableID) ?? getUserTableId();
  }

  getNotificationsCount() async {
    _getNotificationsCount().then((count) {
      _notificationsCountSubject.add(count);
    });
  }

  SocialBloc() {
    checkUserTableID();
    addListToStream();
    getNotificationsCount();
    getSocialProfileData();
    addNotificationsList();
    _incrementContentPageNumberController.stream.listen((val) {
      contentPageNumber += val;

      loadMoreContentPage();

      // _postIdForCommentsController.stream.listen((postId) {
      //   getComments(postId).then((comments) {
      //     _commentsListSubject.add(comments);
      //   });
      // });
    });
    _postIdToLikeController.stream.listen((postId) {
      likePost(postId).then((isLiked) {
        if (isLiked) {
          print('tadaam');
          // likedPostsList.add(postId);
          // _isLikedSubject.add(likedPostsList);
        }
      });
    });

    _postIdToUnlikeController.stream.listen((postId) {
      unlikePost(postId).then((isUnliked) {
        if (isUnliked) {
          print('tadaaam');
          // likedPostsList.remove(postId);
          // _isLikedSubject.add(likedPostsList);
        }
      });
    });
  }

  Stream<List<SocialContentModel>> get listOfContent =>
      _listOfContentSubject.stream;

  final _listOfContentSubject = BehaviorSubject<List<SocialContentModel>>();

  Sink<int> get incrementContentPageNumber =>
      _incrementContentPageNumberController.sink;

  final _incrementContentPageNumberController = StreamController<int>();

  Stream<SocialProfileModel> get socialProfile => _socialProfileSubject.stream;

  final _socialProfileSubject = BehaviorSubject<SocialProfileModel>();

  Sink<int> get postIdForComments => _postIdForCommentsController.sink;

  final _postIdForCommentsController = StreamController<int>();

  Sink<int> get postIdToLike => _postIdToLikeController.sink;

  final _postIdToLikeController = StreamController<int>();

  Sink<int> get postIdToUnlike => _postIdToUnlikeController.sink;

  final _postIdToUnlikeController = StreamController<int>();

  Stream<List<SocialNotificationModel>> get notificationsList =>
      _notificationsListSubject.stream;

  final _notificationsListSubject =
      BehaviorSubject<List<SocialNotificationModel>>();

  Stream<String> get notificationsCount => _notificationsCountSubject.stream;

  final _notificationsCountSubject = BehaviorSubject<String>();

  // Stream<List<int>> get isLiked => _isLikedSubject.stream;

  // final _isLikedSubject = BehaviorSubject<List<int>>();

  dispose() {
    _socialProfileSubject.close();
    _incrementContentPageNumberController.close();
    _postIdForCommentsController.close();
    _postIdToLikeController.close();
    _postIdToUnlikeController.close();
    _notificationsListSubject.close();
    _notificationsCountSubject.close();
    // _isLikedSubject.close();
  }
}
