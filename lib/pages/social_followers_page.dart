import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/social/social_search_model.dart';
import 'package:student_system_flutter/pages/social_profile_page.dart';

class SocialFollowersPage extends StatefulWidget {
  final String userId;
  final tabNumber;
  SocialFollowersPage({@required this.userId, @required this.tabNumber});
  @override
  SocialFollowersPageState createState() {
    return new SocialFollowersPageState();
  }
}

class SocialFollowersPageState extends State<SocialFollowersPage> {
  @override
  initState() {
    _tabNumber = widget.tabNumber;
    super.initState();
  }

  int _tabNumber;

  Future<List<SocialSearchModel>> getFollowers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = widget.userId;
    // String _userId = prefs.getString(userTableID);
    List<SocialSearchModel> _followersList;
    try {
      Response response = await http.post('$apiSocialGetFollowers/7', headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        _followersList = parsed
            .map<SocialSearchModel>((item) => SocialSearchModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return _followersList;
  }

  Future<List<SocialSearchModel>> getFollowings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    String _userId = widget.userId;
    // String _userId = prefs.getString(userTableID);
    List<SocialSearchModel> _followingssList;
    try {
      Response response = await http.post('$apiSocialGetFollowings/7',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body);

        _followingssList = parsed
            .map<SocialSearchModel>((item) => SocialSearchModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      print(e);
    }
    return _followingssList;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _tabNumber,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [
            Tab(
              text: 'Followers',
            ),
            Tab(
              text: 'Followings',
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder<List<SocialSearchModel>>(
                future: getFollowers(),
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) =>
                            CustomBody(data: snapshot.data[index]))
                    : DrawPlatformCircularIndicator()),
            FutureBuilder<List<SocialSearchModel>>(
                future: getFollowings(),
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) =>
                            CustomBody(data: snapshot.data[index]))
                    : DrawPlatformCircularIndicator()),
          ],
        ),
      ),
    );
  }
}

class CustomBody extends StatelessWidget {
  final SocialSearchModel data;
  const CustomBody({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push((MaterialPageRoute(
              builder: (BuildContext context) => SocialProfilePage(
                    requestType: SocialProfileAccessType.OtherProfile,
                    searchedUserId: data.id.toString(),
                  ))));
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(fileBaseUrl + data.avatarUrl),
              ),
              title: Text(data.lastName + ' ' + data.firstName),
              trailing: RaisedButton(
                child: Text('Follow'),
                onPressed: () {},
              ),
            )),
      ),
    );
  }
}
