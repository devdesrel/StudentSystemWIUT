import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    var numberOfLines;

    void _changeNumberOfLines() {
      setState(() {
        numberOfLines = 2;
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Comments page'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Name goes here'),
                isThreeLine: false,
                subtitle: Text.rich(TextSpan(text: 'comment goes here')),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Name goes here2'),
                isThreeLine: false,
                subtitle: Text.rich(TextSpan(text: 'comment goes here')),
              ),
            ],
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
                icon: FontAwesomeIcons.camera,
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
                  constraints: BoxConstraints.loose(Size.fromHeight(51.0)),
                  child: Theme(
                    data: ThemeData(hintColor: greyColor),
                    child: TextField(
                      onChanged: (s) => _changeNumberOfLines,
                      maxLines: numberOfLines,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 18.0, right: 18.0, bottom: 1.0, top: 12.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          hintText: 'Comment',
                          filled: true,
                          fillColor: backgroundColor),
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
    );
  }
}

class CustomSizedBox extends StatelessWidget {
  final IconData icon;
  final AttachmentTypes type;
  // final Future getImage;

  Future getImage(bool isFromCamera) async {
    var image = await ImagePicker.pickImage(
        source: isFromCamera ? ImageSource.camera : ImageSource.gallery);
    File _image;

    setState(() {
      _image = image;
    });
  }

  CustomSizedBox({Key key, @required this.icon, @required this.type})
      : super(key: key);
  //CustomSizedBox({Key key(iconkey1), @required this.icon}); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
            }
            //     if(key == iconkey1){
            //   onPressed: () {getImage},
            // }else{
            //   onPressed: () {},
            // }
            ),
      ),
    );
  }

  void setState(Function param0) {}
}

enum AttachmentTypes {
  CAMERA,
  GALLERY,
  STICKER,
  //FILE,
}
