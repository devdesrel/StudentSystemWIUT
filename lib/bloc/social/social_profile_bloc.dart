import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/social/social_profile_model.dart';

class SocialProfileBloc {
  String userId;
  SocialProfileBloc(this.userId) {
    addProfileDataToStream();
  }
//streams
  Stream<SocialProfileModel> get profileData => _profileDataSubject.stream;

  final _profileDataSubject = BehaviorSubject<SocialProfileModel>();

  Stream<bool> get isFollowed => _isFollowedSubject.stream;

  final _isFollowedSubject = BehaviorSubject<bool>();

//functions
  Future<SocialProfileModel> getSocialProfile(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);

    SocialProfileModel profile;
    try {
      Response _response = await http.post("$apiSocialProfile/$userId",
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

  void followUser(String followingUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    try {
      Response response = await http
          .post('$apiSocialFollow/$_userId/$followingUserId', headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        _isFollowedSubject.add(true);
      }
    } catch (e) {
      print(e);
    }
  }

  addProfileDataToStream() async {
    getSocialProfile(userId).then((data) {
      _profileDataSubject.add(data);
    });
  }

  dispose() {
    _profileDataSubject.close();
    _isFollowedSubject.close();
  }
}
