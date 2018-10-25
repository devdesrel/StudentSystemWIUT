import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TipsAndTricksPage extends StatefulWidget {
  final TipsRequestType type;

  @override
  _TipsAndTricksPageState createState() => _TipsAndTricksPageState();

  TipsAndTricksPage({this.type});
}

class _TipsAndTricksPageState extends State<TipsAndTricksPage> {
  int currentStep = 0;
  List<Step> mySteps = [
    Step(
        title: Text("Download the application"),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                  child: Text(
                    'Tap here to download the application',
                    style: TextStyle(color: greyColor),
                  ),
                  onPressed: () {
                    launch(Platform.isAndroid
                        ? 'http://play.google.com/store/apps/details?id=com.microsoft.office.outlook'
                        : 'https://itunes.apple.com/us/app/microsoft-outlook/id951937596?mt=8');
                  }),
            ]),
        isActive: true),
    Step(
        title: Text("Add account"),
        content: ListView(
          children: <Widget>[
            Text(
                'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),
            Text(
                'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),

            // Text(""),
            Image.asset(
              'assets/step2.png',
              height: 200.0,
            ),
          ],
        ),
        // state: StepState.editing,
        isActive: true),
    Step(title: Text("Step 3"), content: Text("Hello World!"), isActive: true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.type == TipsRequestType.Outlook
              ? 'Web Mail (Outlook)'
              : 'Turnitin'),
          centerTitle: true,
        ),
        backgroundColor: backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Card(
                    margin: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15.0, bottom: 8.0),
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                          'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),
                    ),
                  ),
                ]),
              )
            ];
          },
          body: Stepper(
            currentStep: currentStep,
            steps: mySteps,
            type: StepperType.vertical,
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
            },
            onStepContinue: () {
              setState(() {
                if (currentStep < mySteps.length - 1) {
                  currentStep = currentStep + 1;
                } else {
                  currentStep = 0;
                }
              });
            },
          ),
        ));
  }
}
