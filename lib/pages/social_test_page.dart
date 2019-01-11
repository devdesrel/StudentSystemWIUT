import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/social_profile_model.dart';

class SocialProfileTestPage extends StatefulWidget {
  final String userId;
  SocialProfileTestPage({@required this.userId});
  @override
  SocialProfileTestPageState createState() {
    return new SocialProfileTestPageState();
  }
}

class SocialProfileTestPageState extends State<SocialProfileTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(seconds: 6),
                      child: Container(
                        height: 220.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ExactAssetImage("assets/wiut_cover.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center),
                        ),
                      ),
                    ),
                    // AnimatedContainer(duration: Duration(seconds: 5),),
                    FutureBuilder<SocialProfileModel>(
                      future: getSocialProfile(widget.userId),
                      builder: (context, snapshot) => snapshot.hasData
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 30.0, left: 30.0),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: snapshot.hasData
                                    ? CachedNetworkImageProvider(fileBaseUrl +
                                        snapshot.data.profileImageURL)
                                    : ExactAssetImage(
                                        'assets/png_transparent.png'),
                                // ExactAssetImage(
                                //     "assets/profile_picture.png"),
                              ),
                            )
                          : Container(),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: Text("Name goes here",
                          // userName + " " + userSurname,
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.0)),
                    ),
                  ],
                ),
              ),
              expandedHeight: 190.0,
              floating: false,
              pinned: false,
              bottom: PreferredSize(
                child: Card(),
                preferredSize: Size.square(50),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: FutureBuilder<SocialProfileModel>(
                    future: getSocialProfile(widget.userId),
                    builder: (context, snapshot) => snapshot.hasData
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Tweets".toUpperCase()),
                                  Text(snapshot.hasData
                                      ? snapshot.data.postCount.toString()
                                      : '0'),
                                  // StreamBuilder(
                                  //     stream: bloc.postCount,
                                  //     builder: (context, snapshot) => snapshot.hasData
                                  //         ? Text(snapshot.data.toString())
                                  //         : Text("0")),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Following".toUpperCase()),
                                  Text(snapshot.hasData
                                      ? snapshot.data.followingsCount.toString()
                                      : '0'),
                                  // StreamBuilder(
                                  //     stream: bloc.following,
                                  //     builder: (context, snapshot) => snapshot.hasData
                                  //         ? Text(snapshot.data.toString())
                                  //         : Text("0")),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Followers".toUpperCase()),
                                  Text(snapshot.hasData
                                      ? snapshot.data.followersCount.toString()
                                      : '0'),
                                  // StreamBuilder(
                                  //     stream: bloc.followers,
                                  //     builder: (context, snapshot) => snapshot.hasData
                                  //         ? Text(snapshot.data.toString())
                                  //         : Text("0")),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ),
              ),
              CustomInfoCategory(
                text: "About me",
              ),
              CustomCard(
                Column(
                  children: <Widget>[
                    ListTile(
                        leading: Icon(Icons.assignment_ind),
                        title: Text('0000')),
                    // title: Text("00004141")),
                    ListTile(
                        leading: Icon(Icons.mail),
                        // title: Text(userId + "@wiut.uz")),
                        title: Text("@wiut.uz")),
                  ],
                ),
              ),
              CustomInfoCategory(
                text: "Projects",
              ),
              CustomCard(
                ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text("No projects")),
              ),
              CustomInfoCategory(
                text: "Skills and expertise",
              ),
              CustomCard(
                ListTile(
                    leading: Icon(Icons.mode_edit),
                    title: Text("No skills mentioned")),
              ),
              CustomInfoCategory(
                text: "Schools and education",
              ),
              CustomCard(
                ListTile(
                    leading: Icon(FontAwesomeIcons.graduationCap),
                    title: Text("No education mentioned")),
              ),
              CustomInfoCategory(
                text: "Interests and hobbies",
              ),
              CustomCard(
                ListTile(
                    leading: Icon(FontAwesomeIcons.footballBall),
                    title: Text("No hobbies mentioned")),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class CustomInfoCategory extends StatelessWidget {
  final String text;
  const CustomInfoCategory({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, top: 12.0),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: accentColor, fontSize: 16.0),
        textAlign: TextAlign.start,
      ),
    );
  }
}
