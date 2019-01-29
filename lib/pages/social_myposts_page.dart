import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/social/social_content_model.dart';

class SocialMyPostsPage extends StatefulWidget {
  @override
  _SocialMyPostsPageState createState() => _SocialMyPostsPageState();
}

class _SocialMyPostsPageState extends State<SocialMyPostsPage> {
  Future<List<SocialContentModel>> getMyPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = prefs.getString(userTableID);
    List<SocialContentModel> myPosts;
    try {
      Response response = await http.get('$apiSocialGetMyPosts/$_userId/1',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        myPosts = parsed
            .map<SocialContentModel>(
                (item) => SocialContentModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return myPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: FutureBuilder(
          future: getMyPosts(),
          builder: (context, snapshot) => snapshot.hasData
              ? Container(
                  child: Text('has data'),
                )
              : Container(
                  child: Text('no data'),
                )),
    );
  }
}
