import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/social/social_bloc.dart';
import 'package:student_system_flutter/bloc/social/social_provider.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

import 'package:student_system_flutter/models/social_content_model.dart';
import 'package:student_system_flutter/models/social_notifications_model.dart';
import 'package:student_system_flutter/pages/social_profile_page.dart';
import 'package:student_system_flutter/pages/social_search_page.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_posts.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final String _title = 'WIUT Feed';
  final int _notificationTabIndex = 4;

  @override
  initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
    //TODO: mark as viewed when 4th tab is loaded
    // if (_tabController.index == _notificationTabIndex) {
    //   markNotificationAsMarked();
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).pushNamed(socialSearchPage);
                  },
                ),
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
                  StreamBuilder<String>(
                      stream: bloc.notificationsCount,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != '0') {
                          return Tab(
                            child: Stack(
                              children: <Widget>[
                                Icon(
                                  Icons.notifications_active,
                                ),
                                Positioned(
                                    right: 0.0,
                                    top: 0.0,
                                    child: CircleAvatar(
                                        backgroundColor: redColor,
                                        radius: 8.0,
                                        child: Text(snapshot.data,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0))))
                              ],
                            ),
                          );
                        } else {
                          return Tab(
                            icon: Icon(Icons.notifications_active),
                          );
                        }
                      })
                ],
                controller: _tabController,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
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
                                itemBuilder: (context, i) => i ==
                                        snapshot.data.length - 1
                                    ? ItemPosts(
                                        model: snapshot.data[i],
                                        isLast: true,
                                        bloc: bloc,
                                        avatarUrl: snapshot.data[i].avatarUrl,
                                      )
                                    : ItemPosts(
                                        model: snapshot.data[i],
                                        isLast: false,
                                        bloc: bloc,
                                        avatarUrl: snapshot.data[i].avatarUrl,
                                      ),
                              )
                            : CustomCard(
                                Text(
                                  "No posts to display",
                                  textAlign: TextAlign.center,
                                ),
                              )
                        : CustomCard(
                            Text(
                              "No posts to display",
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                Icon(Icons.mail),
                Icon(Icons.star),
                NotificationsTab(bloc: bloc),
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

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final SocialBloc bloc;

  @override
  NotificationsTabState createState() {
    return new NotificationsTabState();
  }
}

class NotificationsTabState extends State<NotificationsTab> {
  @override
  initState() {
    super.initState();
    markNotificationAsMarked();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: StreamBuilder<List<SocialNotificationModel>>(
          stream: widget.bloc.notificationsList,
          builder: (context, snapshot) => snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        // bloc.markNotificationAsMarked();
                      },
                      child: NotificationItem(data: snapshot.data[index])))
              : Container(
                  child: Text('No Notifications yet'),
                )),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final SocialNotificationModel data;
  const NotificationItem({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: data.isRead ? whiteColor : Colors.blue[50],
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(fileBaseUrl + data.avatarUrl),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(data.notifierName),
              Text(
                getDateDifference(data.date.toString()),
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 12.0),
              )
            ],
          ),
          subtitle: Text(data.notfiyText),
        ));
  }
}
