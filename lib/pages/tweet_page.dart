import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
          ),
        ),
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
              CustomSizedBox(
                icon: FontAwesomeIcons.image,
                type: AttachmentTypes.GALLERY,
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
        onPressed: () => print("Pressed"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class CustomSizedBox extends StatelessWidget {
  final IconData icon;
  final AttachmentTypes type;
  // final Future getImage;

  CustomSizedBox({Key key, @required this.icon, @required this.type})
      : super(key: key);

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
          }),
    );
  }

  void setState(Function param0) {}
}
