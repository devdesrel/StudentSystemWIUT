import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/social/social_bloc.dart';
import 'package:student_system_flutter/bloc/social/social_provider.dart';

import 'package:student_system_flutter/models/social_content_model.dart';
import 'package:student_system_flutter/pages/social_profile_page.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_posts.dart';

class SocialPage extends StatelessWidget {
  final String _title = 'WIUT Feed';

  @override
  Widget build(BuildContext context) {
    var bloc = SocialBloc();
    return SocialProvider(
      socialBloc: bloc,
      child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                _title,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.account_circle),
                    onPressed: () {
                      // Navigator.of(context).pushNamed(socialProfilePage);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                SocialProfilePage(bloc: bloc)),
                      );
                    }),
              ],
              bottom: TabBar(
                labelColor: Theme.of(context).accentColor,
                indicatorColor: Theme.of(context).accentColor,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.mail)),
                  Tab(icon: Icon(Icons.star)),
                  Tab(icon: Icon(Icons.search))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Container(
                  color: Theme.of(context).backgroundColor,
                  child: StreamBuilder<List<SocialContentModel>>(
                    stream: bloc.listOfContent,
                    builder: (context, snapshot) => snapshot.hasData
                        ? snapshot.data != null
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) => ItemPosts(
                                      model: snapshot.data[i],
                                    ),
                              )
                            : Container(
                                child: Text("Nothing to show"),
                              )
                        : Container(
                            child: Text("Nothing to show"),
                          ),
                  ),
                ),
                Icon(Icons.mail),
                Icon(Icons.star),
                Icon(Icons.search),
              ],
            ),
            // bottomNavigationBar: BottomAppBar(
            //     color: Colors.blue,
            //     hasNotch: true,
            //     elevation: 5.0,
            //     child: ButtonBar(
            //       alignment: MainAxisAlignment.start,
            //       children: <Widget>[
            //         Icon(
            //           Icons.settings,
            //           color: Colors.white,
            //         ),
            //       ],
            //     )),
            floatingActionButton: FloatingActionButton(
              child: Platform.isAndroid
                  ? Icon(Icons.edit)
                  : Icon(IconData(0xF418, fontFamily: 'CuperIcon')),
              onPressed: () {
                Navigator.of(context).pushNamed(tweetPage);
              },
            ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          )),
    );
  }
}
