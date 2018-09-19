import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Comments page'),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Name goes here'),
                        isThreeLine: false,
                        subtitle:
                            Text.rich(TextSpan(text: 'comment goes here')),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text('Name goes here2'),
                        isThreeLine: false,
                        subtitle:
                            Text.rich(TextSpan(text: 'comment goes here')),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: whiteColor,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CustomSizedBox(
                        icon: MdiIcons.camera,
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
                          constraints:
                              BoxConstraints.loose(Size.fromHeight(100.0)),
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
          )
        : Material(
            child: CupertinoPageScaffold(
              backgroundColor: backgroundColor,
              navigationBar: CupertinoNavigationBar(
                middle: Text('Comments page'),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Column(children: <Widget>[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('Name goes here'),
                          isThreeLine: false,
                          subtitle:
                              Text.rich(TextSpan(text: 'comment goes here')),
                        ),
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('Name goes here2'),
                          isThreeLine: false,
                          subtitle:
                              Text.rich(TextSpan(text: 'comment goes here')),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: whiteColor,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomSizedBox(
                          icon: Icons.camera,
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
                            constraints:
                                BoxConstraints.loose(Size.fromHeight(100.0)),
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
            ),
          );
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

  void setState(Function param0) {}
}
