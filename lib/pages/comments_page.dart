import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/social/social_comment_model.dart';

class CommentsPage extends StatelessWidget {
  final int postId;
  CommentsPage({@required this.postId});
  Future<List<SocialCommentModel>> getComments(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _token = prefs.getString(token);
    // int postId = 1;
    List<SocialCommentModel> _comments;
    try {
      Response response = await http.get('$apiSocialGetComments/$postId',
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        _comments = parsed
            .map<SocialCommentModel>(
                (item) => SocialCommentModel.fromJson(item))
            .toList();
      } else {
        _comments = null;
      }
    } catch (e) {
      print(e);
    }
    return _comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(children: <Widget>[
          Expanded(
            child: FutureBuilder<List<SocialCommentModel>>(
              future: getComments(postId),
              // stream: widget.bloc.commentsList,
              builder: (context, snapshot) => snapshot.hasData &&
                      snapshot.data != null
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          Column(children: <Widget>[
                            ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      fileBaseUrl +
                                          snapshot.data[index].avatarUrl),
                                ),
                                subtitle: CustomCard(Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].postedByName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text.rich(TextSpan(
                                              text: snapshot
                                                  .data[index].commentText,
                                              // text:
                                              //     "ghjkkjhghjkljhjklkjhghjklajskajksjaksjkajskajskajskajksjaksjakjskajskajksjaksjkajskajskajskajskajksjaksjaksjkajskajskajskajskajskajskajskjaksjaksjaksjaksjakjkjkjkjkjskasjkajskajskajskajskajskajskajskajskjaskjaksjaksjakjskajskajskajskajskajksjaksjaksjakjskajskajskajskajskajskajskajskajskajksjaksjaksjaksjakjsakjsakjskajsakjskasjkasj",
                                              style:
                                                  TextStyle(color: textColor))),
                                        ])))),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                      getDateDifference(
                                          snapshot.data[index].postedDate),
                                      style: TextStyle(color: textColor)),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Like',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 15.5),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Reply',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 15.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]))
                  : DrawPlatformCircularIndicator(),
              // CustomCard(
              //     Center(
              //       child: Text(
              //           'You are the first, YAAAAY!\nLeave your comment'),
              //     ),
              //   ),
            ),
          ),
          Container(
            color: whiteColor,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                CustomSizedBox(
                  icon: Platform.isAndroid ? MdiIcons.camera : Icons.camera,
                  type: AttachmentTypes.CAMERA,
                ),
                // getImage: getImage(true)
                CustomSizedBox(
                  icon: FontAwesomeIcons.image,
                  type: AttachmentTypes.GALLERY,
                  // getImage: getImage(false),
                ),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints.loose(Size.fromHeight(100.0)),
                    child: Theme(
                      data: ThemeData(hintColor: greyColor),
                      child: TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0,
                                top: 0.0),
                            // border: OutlineInputBorder(
                            //     borderRadius: BorderRadius.circular(50.0)),
                            hintText: 'Comment',
                          )
                          // filled: true,
                          // fillColor: backgroundColor),
                          ),
                    ),
                  ),
                ),
                CustomSizedBox(
                  icon: Icons.insert_emoticon,
                  type: AttachmentTypes.STICKER,
                )
                //SEND BUTTON
                // FloatingActionButton(
                //   child: Icon(Icons.send),
                //   onPressed: () => debugPrint("Pressed"),
                //   //elevation: 4.0,
                // ),
                // TextField(),

                // TextField(),
                // Icon(Icons.insert_emoticon)
              ],
            ),
          ),
        ]),
      ),
    );
    //  Material(
    //       color: Colors.transparent,
    //       child: CupertinoPageScaffold(
    //         backgroundColor: backgroundColor,
    //         navigationBar: CupertinoNavigationBar(),
    //         child: GestureDetector(
    //           onTap: () {
    //             FocusScope.of(context).requestFocus(new FocusNode());
    //           },
    //           child: Column(children: <Widget>[
    //             Expanded(
    //               child: FutureBuilder<List<SocialCommentModel>>(
    //                 future: getComments(postId),
    //                 builder: (context, shot) => shot.hasData &&
    //                         shot.data != null
    //                     ? ListView.builder(
    //                         shrinkWrap: true,
    //                         itemCount: shot.data.length,
    //                         itemBuilder: (context, index) => ListTile(
    //                               leading: CircleAvatar(
    //                                   backgroundImage:
    //                                       CachedNetworkImageProvider(
    //                                           fileBaseUrl +
    //                                               shot.data[index]
    //                                                   .avatarUrl)),
    //                               title: Text(shot.data[index].postedByName),
    //                               isThreeLine: false,
    //                               subtitle: Text.rich(TextSpan(
    //                                   text: shot.data[index].commentText)),
    //                             ),
    //                       )
    //                     : DrawPlatformCircularIndicator(),
    //               ),
    //             ),
    //             Container(
    //               color: whiteColor,
    //               width: double.infinity,
    //               padding: const EdgeInsets.symmetric(
    //                   vertical: 6.0, horizontal: 4.0),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 children: <Widget>[
    //                   CustomSizedBox(
    //                     icon: Icons.camera,
    //                     type: AttachmentTypes.CAMERA,
    //                   ),
    //                   // getImage: getImage(true)
    //                   CustomSizedBox(
    //                     icon: FontAwesomeIcons.image,
    //                     type: AttachmentTypes.GALLERY,
    //                     // getImage: getImage(false),
    //                   ),
    //                   Expanded(
    //                     child: Container(
    //                       constraints:
    //                           BoxConstraints.loose(Size.fromHeight(100.0)),
    //                       child: Theme(
    //                         data: ThemeData(hintColor: greyColor),
    //                         child: TextField(
    //                             maxLines: null,
    //                             keyboardType: TextInputType.multiline,
    //                             decoration: InputDecoration(
    //                               border: InputBorder.none,
    //                               contentPadding: EdgeInsets.only(
    //                                   left: 10.0,
    //                                   right: 10.0,
    //                                   bottom: 10.0,
    //                                   top: 0.0),
    //                               // border: OutlineInputBorder(
    //                               //     borderRadius: BorderRadius.circular(50.0)),
    //                               hintText: 'Comment',
    //                             )
    //                             // filled: true,
    //                             // fillColor: backgroundColor),
    //                             ),
    //                       ),
    //                     ),
    //                   ),
    //                   CustomSizedBox(
    //                     icon: Icons.insert_emoticon,
    //                     type: AttachmentTypes.STICKER,
    //                   )
    //                   //SEND BUTTON
    //                   // FloatingActionButton(
    //                   //   child: Icon(Icons.send),
    //                   //   onPressed: () => debugPrint("Pressed"),
    //                   //   //elevation: 4.0,
    //                   // ),
    //                   // TextField(),

    //                   // TextField(),
    //                   // Icon(Icons.insert_emoticon)
    //                 ],
    //               ),
    //             ),
    //           ]),
    //         ),
    //       ),
    //     );
  }
}

class CustomSizedBox extends StatelessWidget {
  final IconData icon;
  final AttachmentTypes type;

  CustomSizedBox({Key key, @required this.icon, @required this.type})
      : super(key: key);
  //CustomSizedBox({Key key(iconkey1), @required this.icon}); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        width: 40.0,
        height: 20.0,
        child: IconButton(
            padding: const EdgeInsets.all(0.0),
            icon: Icon(icon),
            color: greyColor,
            onPressed: () {
              switch (type) {
                case AttachmentTypes.CAMERA:
                  getImage(true);
                  break;
                case AttachmentTypes.GALLERY:
                  getImage(false);
                  break;
                case AttachmentTypes.STICKER:
                  print('Get QUESTIONNAIRE');
                  break;
                // case AttachmentTypes.FILE:
                //   print('Get Files');
                //   break;
                default:
                  print('Default');
                  break;
              }
            }),
      ),
    );
  }
}
