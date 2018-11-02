import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/pages/image_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TipsAndTricksPage extends StatelessWidget {
  final TipsRequestType type;
  TipsAndTricksPage({this.type});
  List<Image> step2 = [
    Image.asset(
      'assets/instructions/step1.png',
    ),
    Image.asset(
      'assets/instructions/step2.png',
    ),
    Image.asset(
      'assets/instructions/step3.png',
    ),
  ];
  List<Image> step3 = [
    Image.asset(
      'assets/instructions/addstep1.png',
    ),
    Image.asset(
      'assets/instructions/addstep2.png',
    ),
    Image.asset(
      'assets/instructions/step6.png',
    ),
  ];
  List<Image> step4 = [
    Image.asset(
      'assets/instructions/step7.png',
    ),
    Image.asset(
      'assets/instructions/final.png',
    ),
  ];
  List<Image> iosStep1 = [
    Image.asset(
      'assets/instructions/step1.png',
    ),
    Image.asset(
      'assets/instructions/ios_step1.PNG',
    ),
  ];
  List<Image> iosStep2 = [
    Image.asset(
      'assets/instructions/ios_step2.PNG',
    ),
    Image.asset(
      'assets/instructions/ios_step3.PNG',
    ),
    Image.asset(
      'assets/instructions/ios_step4.PNG',
    ),
  ];
  List<Image> iosStep3 = [
    Image.asset(
      'assets/instructions/ios_step5.PNG',
    ),
    Image.asset(
      'assets/instructions/ios_step6.PNG',
    ),
  ];

  List<Image> gmailAndroidStep1 = [
    Image.asset('assets/instructions/gmail_step0.png'),
    Image.asset('assets/instructions/gmail_step1.png'),
  ];
  List<Image> gmailAndroidStep2 = [
    Image.asset('assets/instructions/gmail_step2.png'),
    Image.asset('assets/instructions/gmail_step3.png'),
    Image.asset('assets/instructions/gmail_step4.png'),
    Image.asset('assets/instructions/gmail_step5.png'),
  ];
  List<Image> gmailAndroidStep3 = [
    Image.asset('assets/instructions/gmail_step6.png'),
    Image.asset('assets/instructions/gmail_step7.png'),
    Image.asset('assets/instructions/gmail_step8.png'),
    Image.asset('assets/instructions/gmail_step9.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text(type == TipsRequestType.Outlook
                  ? 'Web Mail (Outlook)'
                  : 'Gmail'),
              centerTitle: true,
            ),
            backgroundColor: backgroundColor,
            body: type == TipsRequestType.Outlook
                ? AndroidOutlookBody(step2: step2, step3: step3, step4: step4)
                : AndroidGmailBody(
                    gmailAndroidStep1: gmailAndroidStep1,
                    gmailAndroidStep2: gmailAndroidStep2,
                    gmailAndroidStep3: gmailAndroidStep3),
          )
        : Material(
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(type == TipsRequestType.Outlook
                    ? 'Web Mail (Outlook)'
                    : 'Gmail'),
              ),
              backgroundColor: backgroundColor,
              child: type == TipsRequestType.Outlook
                  ? IosOutlookBody(
                      iosStep1: iosStep1,
                      iosStep2: iosStep2,
                      iosStep3: iosStep3)
                  // TODO: Ios version of gmail instructions
                  : AndroidGmailBody(
                      gmailAndroidStep1: gmailAndroidStep1,
                      gmailAndroidStep2: gmailAndroidStep2,
                      gmailAndroidStep3: gmailAndroidStep3),
            ),
          );
  }
}

class AndroidGmailBody extends StatelessWidget {
  const AndroidGmailBody({
    Key key,
    @required this.gmailAndroidStep1,
    @required this.gmailAndroidStep2,
    @required this.gmailAndroidStep3,
  }) : super(key: key);

  final List<Image> gmailAndroidStep1;
  final List<Image> gmailAndroidStep2;
  final List<Image> gmailAndroidStep3;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          margin:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 8.0),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
                'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nGmail application supports web mail account, thus It can provide handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to add and configure web mail account to your gmail.'),
          ),
        ),
        SizedBox(height: 10.0),
        StepWidget(
          text: 'STEP 1',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Download Application'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        GestureDetector(
          onTap: () {
            launch(
                'https://play.google.com/store/apps/details?id=com.google.android.gm');
          },
          child: Image.asset(
            'assets/google_play.png',
            height: 100.0,
          ),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 2',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Add account'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gmailAndroidStep1.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right:
                            index == gmailAndroidStep1.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroG1$index',
                        child: Container(
                          child: gmailAndroidStep1[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroG1$index',
                                    widget: gmailAndroidStep1[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 3',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Set up your account'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gmailAndroidStep2.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right:
                            index == gmailAndroidStep2.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroG2$index',
                        child: Container(
                          child: gmailAndroidStep2[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroG2$index',
                                    widget: gmailAndroidStep2[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 4',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Activate email functions'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gmailAndroidStep3.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right:
                            index == gmailAndroidStep3.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroG3$index',
                        child: Container(
                          child: gmailAndroidStep3[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroG3$index',
                                    widget: gmailAndroidStep3[index])));
                      },
                    ),
                  )),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

class IosOutlookBody extends StatelessWidget {
  const IosOutlookBody({
    Key key,
    @required this.iosStep1,
    @required this.iosStep2,
    @required this.iosStep3,
  }) : super(key: key);

  final List<Image> iosStep1;
  final List<Image> iosStep2;
  final List<Image> iosStep3;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          margin:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 8.0),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
                'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        StepWidget(
          text: 'STEP 1',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Download Application'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        GestureDetector(
          onTap: () {
            launch(
                'https://itunes.apple.com/us/app/microsoft-outlook/id951937596?mt=8');
          },
          child: Image.asset(
            'assets/instructions/getios.png',
            height: 100.0,
          ),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 2',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Add account'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iosStep1.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == iosStep1.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroIO1$index',
                        child: Container(
                          child: iosStep1[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroIO1$index',
                                    widget: iosStep1[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 3',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Change the connection type'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iosStep2.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == iosStep2.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroIO2$index',
                        child: Container(
                          child: iosStep2[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroIO2$index',
                                    widget: iosStep2[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 4',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Fill the form'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iosStep3.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == iosStep3.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroIO3$index',
                        child: Container(
                          child: iosStep3[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroIO3$index',
                                    widget: iosStep3[index])));
                      },
                    ),
                  )),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

class AndroidOutlookBody extends StatelessWidget {
  const AndroidOutlookBody({
    Key key,
    @required this.step2,
    @required this.step3,
    @required this.step4,
  }) : super(key: key);

  final List<Image> step2;
  final List<Image> step3;
  final List<Image> step4;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          margin:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 8.0),
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: Text(
                'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        StepWidget(
          text: 'STEP 1',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Download Application'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        GestureDetector(
          onTap: () {
            launch(Platform.isAndroid
                ? 'http://play.google.com/store/apps/details?id=com.microsoft.office.outlook'
                : 'https://itunes.apple.com/us/app/microsoft-outlook/id951937596?mt=8');
          },
          child: Platform.isAndroid
              ? Image.asset(
                  'assets/google_play.png',
                  height: 100.0,
                )
              : Image.asset(
                  'assets/instructions/getios.png',
                  height: 100.0,
                ),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 2',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Add account'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: step2.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == step2.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroO1$index',
                        child: Container(
                          child: step2[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroO1$index',
                                    widget: step2[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 3',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Change the connection type'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: step3.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == step3.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroO2$index',
                        child: Container(
                          child: step3[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroO2$index',
                                    widget: step3[index])));
                      },
                    ),
                  )),
        ),
        Image.asset(
          'assets/tips_tricks_arrow.png',
          height: 50.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        StepWidget(
          text: 'STEP 4',
        ),
        SizedBox(height: 7.0),
        Center(
            child: Text('Fill the form'.toUpperCase(),
                style:
                    TextStyle(color: greyColor, fontWeight: FontWeight.bold))),
        SizedBox(
          height: 310.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: step4.length,
              itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 8.0,
                        right: index == step4.length - 1 ? 16.0 : 8.0,
                        top: 8.0,
                        bottom: 8.0),
                    child: GestureDetector(
                      child: Hero(
                        tag: 'imageHeroO3$index',
                        child: Container(
                          child: step4[index],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageDetailPage(
                                    tag: 'imageHeroO3$index',
                                    widget: step4[index])));
                      },
                    ),
                  )),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

class StepWidget extends StatelessWidget {
  final text;

  const StepWidget({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0), color: greyColor),
            // color: greyColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            )));
  }
}
