import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/pages/image_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TipsAndTricksPage extends StatefulWidget {
  @override
  _TipsAndTricksPageState createState() => _TipsAndTricksPageState();
}

class _TipsAndTricksPageState extends State<TipsAndTricksPage> {
  int current_step = 0;

  static List<int> listOfSmt = List();
  List<Image> step1 = [
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
  List<Step> mySteps = [
    Step(
        title: Text("Download the application"),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                  child: Text(
                    'Tap here to download the application',
                    style: TextStyle(color: accentColor),
                  ),
                  onPressed: () {
                    launch(Platform.isAndroid
                        ? 'http://play.google.com/store/apps/details?id=com.microsoft.office.outlook'
                        : 'https://itunes.apple.com/us/app/microsoft-outlook/id951937596?mt=8');
                  }),
              // Row(
              //   children: <Widget>[
              //     Flexible(
              //       child: Image.asset(
              //         'assets/instructions/1.png',
              //         // height: 100.0,
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: <Widget>[
              //     Flexible(
              //         child: Image.asset('assets/tinstructions/2.png',
              //             height: 100.0))
              //   ],
              // ),
            ]),
        isActive: true),
    Step(
        title: Text("Add account"),
        content: Column(
          children: <Widget>[
            Text(
              "Open the dowloaded application",
              style: TextStyle(color: accentColor),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'assets/instructions/step1.png',
                    // height: 200.0,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('Skip the next screen'),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'assets/instructions/step2.png',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "To the email field write first letter of your name and surname and \"@students.wiut.uz\". If your name is John and surname is Smith, type in jsmith@students.wiut.uz",
              style: TextStyle(color: accentColor),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'assets/instructions/step3.png',
                    // height: 200.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        // state: StepState.editing,
        isActive: true),
    Step(
        title: Text("Step 3"),
        content:
            // content: Column(
            //   children: <Widget>[
            //     Text('fghjkg'),
            //     SizedBox(
            //       height: 10.0,
            //     ),
            //     // Row(
            //     //   children: <Widget>[
            //     //     Flexible(
            //     //       child: Image.asset(
            //     //         'assets/instructions/step4.png',
            //     //         // height: 200.0,
            //     //       ),
            //     //     ),
            //     //   ],
            //     // ),
            //     SizedBox(
            //       height: 10.0,
            //     ),
            //     Text('jhdskkghfjdksljhfdsk'),
            //     SizedBox(
            //       height: 10.0,
            //     ),
            //     Row(
            //       children: <Widget>[
            //         Flexible(
            //           child: Image.asset(
            //             'assets/instructions/addstep1.png',
            //             // height: 200.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Divider(
            //       height: 15.0,
            //       color: Colors.black,
            //     ),

            //     // SizedBox(
            //     //   height: 10.0,
            //     // ),
            //     Row(
            //       children: <Widget>[
            //         Flexible(
            //           child: Image.asset(
            //             'assets/instructions/addstep2.png',
            //             // height: 200.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //     SizedBox(
            //       height: 10.0,
            //     ),
            //     Row(
            //       children: <Widget>[
            //         Flexible(
            //           child: Image.asset(
            //             'assets/instructions/step6.png',
            //             // height: 200.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //     SizedBox(
            //       height: 10.0,
            //     ),
            //     Row(
            //       children: <Widget>[
            //         Flexible(
            //           child: Image.asset(
            //             'assets/instructions/step5.png',
            //             // height: 200.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            Text(''),
        isActive: true),
  ];
  @override
  Widget build(BuildContext context) {
    listOfSmt.add(3);
    listOfSmt.add(3);
    listOfSmt.add(3);
    listOfSmt.add(3);
    listOfSmt.add(3);
    listOfSmt.add(3);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tips & Tricks'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,

      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 8.0),
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                  'Webmail is a widespread way of communication between Academic staff and students, where they share important messages about modules, timetable, VIVA Voce etc. \n\nMicrosoft company developed the Outlook mobile application, which provides handy access to webmail through your mobile device. \n\nPlease, follow the instructions below to install and configure the application.'),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: greyColor),
                  // color: greyColor,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Text(
                      'STEP 1',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),
          SizedBox(height: 7.0),
          Center(
              child: Text('Download Application'.toUpperCase(),
                  style: TextStyle(
                      color: greyColor, fontWeight: FontWeight.bold))),
          GestureDetector(
            onTap: () {
              launch(Platform.isAndroid
                  ? 'http://play.google.com/store/apps/details?id=com.microsoft.office.outlook'
                  : 'https://itunes.apple.com/us/app/microsoft-outlook/id951937596?mt=8');
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
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: greyColor),
                  // color: greyColor,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Text(
                      'STEP 2',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),
          SizedBox(height: 7.0),
          Center(
              child: Text('Add account'.toUpperCase(),
                  style: TextStyle(
                      color: greyColor, fontWeight: FontWeight.bold))),
          SizedBox(
            height: 310.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: step1.length,
                itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                          left: index == 0 ? 16.0 : 8.0,
                          right: index == step1.length - 1 ? 16.0 : 8.0,
                          top: 8.0,
                          bottom: 8.0),
                      child: GestureDetector(
                        child: Hero(
                          tag: 'imageHero$index',
                          child: Container(
                            child: step1[index],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ImageDetailPage(
                                      position: index, widget: step1[index])));
                        },
                      ),
                    )),
          ),
          Text('Step 2'),
          SizedBox(
            height: 310.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listOfSmt.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200.0,
                        height: 75.0,
                        color: Colors.yellow,
                      ),
                    )),
          ),
        ],
      ),
      //Stepper(
      //   currentStep: current_step,
      //   steps: mySteps,
      //   type: StepperType.vertical,
      //   onStepTapped: (step) {
      //     setState(() {
      //       current_step = step;
      //     });
      //   },
      //   onStepContinue: () {
      //     setState(() {
      //       if (current_step < mySteps.length - 1) {
      //         current_step = current_step + 1;
      //       } else {
      //         current_step = 0;
      //       }
      //     });
      //   },
      // ),
    );
  }
}
