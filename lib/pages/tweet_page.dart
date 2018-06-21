import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:image_picker/image_picker.dart';

class TweetPage extends StatefulWidget {
  @override
  _TweetPageState createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 0.0,
        backgroundColor: accentColor,
        // title: Text(
        //   'Tweet',
        //   style: TextStyle(color: Theme.of(context).accentColor),
        // ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
          ),
        ),
        // actions: <Widget>[
        //     Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: Text(
        //       'send'.toUpperCase(),
        //       //style: TextStyle(color: Theme.of(context).accentColor),
        //       style: TextStyle(fontSize: 24.0, color: accentColor),
        //     ),
        //   )
        //   // FloatingActionButton(
        //   //     child: Text('Tweet'),
        //   //     backgroundColor: accentColor,
        //   //     //shape:BoxShape.rectangle(Border),
        //   //     onPressed: () {}),
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: TextFormField(
          controller: TextEditingController(),
          autofocus: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Share your ideas',
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   //crossAxisAlignment: CrossAxisAlignment.end,
        //   children: <Widget>[
        //     Icon(Icons.perm_media),
        //     Icon(Icons.gif),
        //     Icon(Icons.pie_chart),
        //     Icon(Icons.perm_media),
        //     SizedBox(
        //       width: 10.0,
        //     ),
        //     Icon(Icons.check_circle_outline),
        //     Icon(Icons.add)
        //   ],
        // )
      ),
      bottomNavigationBar: BottomAppBar(
        color: accentColor,
        hasNotch: true,
        elevation: 5.0,
        child: Theme(
          data: ThemeData(
              iconTheme: IconThemeData(color: whiteColor, size: 20.0)),
          child: ButtonBar(
            alignment: MainAxisAlignment.start,
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
              CustomSizedBox(
                  icon: FontAwesomeIcons.tasks,
                  type: AttachmentTypes.QUESTIONNAIRE),
              // CustomSizedBox(
              //   icon: Icons.add_location,
              // ),
              CustomSizedBox(
                  icon: Icons.attach_file, type: AttachmentTypes.FILE),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () => debugPrint("Pressed"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class CustomSizedBox extends StatelessWidget {
  final IconData icon;
  final AttachmentTypes type;
  // final Future getImage;

  File _image;
  Future getImage(bool isFromCamera) async {
    var image = await ImagePicker.pickImage(
        source: isFromCamera ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  CustomSizedBox({Key key, @required this.icon, @required this.type})
      : super(key: key);
  //CustomSizedBox({Key key(iconkey1), @required this.icon}); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      child: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: Icon(icon),
          onPressed: () {
            switch (type) {
              case AttachmentTypes.CAMERA:
                getImage(true);
                break;
              case AttachmentTypes.GALLERY:
                getImage(false);
                break;
              case AttachmentTypes.QUESTIONNAIRE:
                print('Get QUESTIONNAIRE');
                break;
              case AttachmentTypes.FILE:
                print('Get Files');
                break;
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
    );
  }

  void setState(Function param0) {}
}

enum AttachmentTypes {
  CAMERA,
  GALLERY,
  QUESTIONNAIRE,
  FILE,
}
