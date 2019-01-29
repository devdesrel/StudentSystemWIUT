import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/bloc/social/social_profile_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/social/social_profile_model.dart';
import 'package:student_system_flutter/pages/social_followers_page.dart';

class SocialProfilePage extends StatefulWidget {
  final SocialProfileAccessType requestType;
  final String searchedUserId;
  SocialProfilePage(
      {@required this.requestType, @required this.searchedUserId});
  @override
  SocialProfilePageState createState() {
    return new SocialProfilePageState();
  }
}

class SocialProfilePageState extends State<SocialProfilePage> {
  // String userId;
  String userTableId;
  double headerFontSize = 17.0;
  List<String> bottomSheetList = ['About me', 'Social'];
  @override
  initState() {
    getUserTableIdFormPrefs().then((tableId) {
      setState(() {
        userTableId = tableId;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    SocialProfileBloc bloc =
        widget.requestType == SocialProfileAccessType.MyProfile
            ? SocialProfileBloc(userTableId)
            : SocialProfileBloc(widget.searchedUserId);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<SocialProfileModel>(
        stream: bloc.profileData,
        builder: (context, snapshot) => snapshot.hasData
            ? CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                                height: screenHeight / 1.8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/social_profile_bg.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center),
                                )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage:
                                        // snapshot.hasData
                                        //     ?
                                        CachedNetworkImageProvider(fileBaseUrl +
                                            snapshot.data.profileImageURL),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      snapshot.data.firstName +
                                          " " +
                                          snapshot.data.lastName,
                                      // userName + " " + userSurname,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0)),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              height: screenHeight / 7,
                              width: screenWidth,
                              child: ClipPath(
                                child: Container(
                                  color: accentColor,
                                  height: screenHeight / 7,
                                  width: screenWidth,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: widget.requestType ==
                                            SocialProfileAccessType.OtherProfile
                                        ? GestureDetector(
                                            onTap: () {
                                              bloc.followUser(
                                                  widget.searchedUserId);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: StreamBuilder(
                                                stream: bloc.isFollowed,
                                                builder: (context, snapshot) =>
                                                    snapshot.hasData
                                                        ? snapshot.data
                                                            ? Text('Followed',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        headerFontSize))
                                                            : Text(
                                                                'Follow +',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        headerFontSize),
                                                              )
                                                        : Text(
                                                            'Follow +',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    headerFontSize),
                                                          ),
                                              ),
                                            ),
                                          )
                                        : Container(height: 0.0, width: 0.0),
                                  ),
                                ),
                                clipper: new SocialProfileClipper(
                                    isLeftTriangle: false),
                              ),
                            ),
                            Positioned(
                                height: screenHeight / 5,
                                width: screenWidth,
                                bottom: -1.0,
                                right: 0.0,
                                child: ClipPath(
                                  child: Container(
                                    color: Colors.white,
                                    height: screenHeight / 5,
                                    width: screenWidth,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 10.0,
                                            top: 10.0,
                                            bottom: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.people,
                                                  color: lightGreyTextColor,
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  snapshot.data.followersCount
                                                          .toString() ??
                                                      '0',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: headerFontSize),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        (MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                SocialFollowersPage(
                                                                  userId: widget
                                                                              .requestType ==
                                                                          SocialProfileAccessType
                                                                              .MyProfile
                                                                      ? userTableId
                                                                      : widget
                                                                          .searchedUserId,
                                                                  tabNumber: 0,
                                                                ))));
                                                  },
                                                  child: Text(
                                                    'Followers',
                                                    style: TextStyle(
                                                        color:
                                                            lightGreyTextColor,
                                                        fontSize:
                                                            headerFontSize),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.people,
                                                  color: lightGreyTextColor,
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                Text(
                                                  snapshot.data.followingsCount
                                                          .toString() ??
                                                      '0',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: headerFontSize),
                                                ),
                                                SizedBox(
                                                  width: 8.0,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        (MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                SocialFollowersPage(
                                                                  userId: widget
                                                                              .requestType ==
                                                                          SocialProfileAccessType
                                                                              .MyProfile
                                                                      ? userTableId
                                                                      : widget
                                                                          .searchedUserId,
                                                                  tabNumber: 1,
                                                                ))));
                                                  },
                                                  child: Text(
                                                    'Followings',
                                                    style: TextStyle(
                                                        color:
                                                            lightGreyTextColor,
                                                        fontSize:
                                                            headerFontSize),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  clipper: SocialProfileClipper(
                                      isLeftTriangle: true),
                                )),
                          ],
                        ),
                      ),
                      expandedHeight: screenHeight / 2,
                      floating: false,
                      pinned: false,
                      bottom: PreferredSize(
                        child: Card(),
                        preferredSize: Size.square(50),
                      )),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // Container(
                      //   color: Colors.white,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: <Widget>[
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Text("Tweets".toUpperCase()),
                      //             Text(snapshot.data.postCount.toString() ??
                      //                 '0'),
                      //           ],
                      //         ),
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Text("Following".toUpperCase()),
                      //             Text(snapshot.data.followingsCount
                      //                     .toString() ??
                      //                 '0'),
                      //           ],
                      //         ),
                      //         Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: <Widget>[
                      //             Text("Followers".toUpperCase()),
                      //             Text(
                      //                 snapshot.data.followersCount.toString() ??
                      //                     '0'),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //     // ),
                      //   ),
                      // ),
                      // CustomInfoCategory(
                      //   text: "About me",
                      // ),
                      // CustomCard(
                      //   widget.requestType == SocialProfileAccessType.MyProfile
                      //       ? ListTile(
                      //           leading: Icon(Icons.assignment_ind),
                      //           title: Text(snapshot.data.userName))
                      //       : Text(snapshot.data.aboutMe ?? 'Not mentioned'),
                      // ),
                      // CustomInfoCategory(
                      //   text: "Projects",
                      // ),
                      // CustomCard(
                      //   ListTile(
                      //       leading: Icon(Icons.library_books),
                      //       title: Text("No projects")),
                      // ),
                      // CustomInfoCategory(
                      //   text: "Skills and expertise",
                      // ),
                      // CustomCard(
                      //   ListTile(
                      //       leading: Icon(Icons.mode_edit),
                      //       title: Text("No skills mentioned")),
                      // ),
                      // CustomInfoCategory(
                      //   text: "Schools and education",
                      // ),
                      // CustomCard(
                      //   ListTile(
                      //       leading: Icon(FontAwesomeIcons.graduationCap),
                      //       title: Text("No education mentioned")),
                      // ),
                      // CustomInfoCategory(
                      //   text: "Interests and hobbies",
                      // ),
                      // CustomCard(
                      //   ListTile(
                      //       leading: Icon(FontAwesomeIcons.footballBall),
                      //       title: Text("No hobbies mentioned")),
                      // ),
                      RaisedButton(
                        color: accentColor,
                        elevation: 1.0,
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Posts',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          // ItemPosts();
                          // Navigator.of(context).pushNamed(socialMyPostsPage);
                          // Navigator.of(context).pushNamed((MaterialPageRoute(
                          //     builder: (BuildContext context) =>
                          //         SocialMyPostsPage())));
                        },
                      ),
                      CustomInfoCategory(
                        text: 'About me',
                      ),
                      CustomCard(
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Column(
                            children: <Widget>[
                              CustomInfoRow(
                                data: snapshot.data.aboutMe,
                                icon: Icon(Icons.perm_contact_calendar),
                              ),
                              widget.requestType ==
                                      SocialProfileAccessType.OtherProfile
                                  ? Container(
                                      color: Colors.transparent,
                                      height: 0.0,
                                      width: 0.0,
                                    )
                                  : Divider(),
                              widget.requestType ==
                                      SocialProfileAccessType.MyProfile
                                  ? CustomInfoRow(
                                      data: snapshot.data.email,
                                      icon: Icon(Icons.email),
                                    )
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      CustomInfoCategory(
                        text: 'Social',
                      ),
                      CustomCard(
                        // height: screenHeight / 3,
                        // color: Colors.white,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Column(
                            children: <Widget>[
                              CustomInfoRow(
                                data: snapshot.data.facebook,
                                icon: Icon(FontAwesomeIcons.facebook),
                              ),
                              Divider(),
                              CustomInfoRow(
                                data: snapshot.data.twitter,
                                icon: Icon(FontAwesomeIcons.twitter),
                              ),
                              Divider(),
                              CustomInfoRow(
                                data: snapshot.data.linkedIn,
                                icon: Icon(FontAwesomeIcons.linkedin),
                              ),
                              Divider(),
                              CustomInfoRow(
                                data: snapshot.data.skype,
                                icon: Icon(FontAwesomeIcons.skype),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              )
            : DrawPlatformCircularIndicator(),
      ),
    );
  }
}

class CustomInfoRow extends StatelessWidget {
  final String data;
  final Icon icon;
  const CustomInfoRow({Key key, @required this.data, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        icon,
        SizedBox(
          width: 10.0,
        ),
        Text(data != '' ? data : 'No info',
            style: TextStyle(color: lightGreyTextColor)),
      ],
    );
  }
}

class CustomInfoCategory extends StatelessWidget {
  final String text;
  const CustomInfoCategory({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
      ),
    );
  }
}

// class CustomInfoCategory extends StatelessWidget {
//   final String text;
//   const CustomInfoCategory({Key key, @required this.text}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 14.0, top: 12.0),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontWeight: FontWeight.bold, color: accentColor, fontSize: 16.0),
//         textAlign: TextAlign.start,
//       ),
//     );
//   }
// }

class SocialProfileClipper extends CustomClipper<Path> {
  final bool isLeftTriangle;
  SocialProfileClipper({@required this.isLeftTriangle});
  @override
  Path getClip(Size size) {
    var path = new Path();
    if (isLeftTriangle) {
      path.moveTo(size.width, 0.0);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}
