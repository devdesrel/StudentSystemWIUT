import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/feature_preview_carousel.dart';

class PreviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FeaturePreviewCarousel(
          isDotIndicatorBottom: true,
          dotSize: 5.0,
          autoplay: false,
          images: [
            //Marks
            CustomPreviewContainer(
              logoPath: 'assets/marks.png',
              text1: 'Marks'.toUpperCase(),
              text2: 'Monitor your performance',
              hasButton: false,
            ),
            //Timetable

            CustomPreviewContainer(
              logoPath: 'assets/timetable.png',
              text1: 'Timetable'.toUpperCase(),
              text2: 'Enjoy with the brand new timetable system',
              hasButton: false,
            ),
            //Learning materials

            CustomPreviewContainer(
              logoPath: 'assets/lectures.png',
              text1: 'Learning Materials'.toUpperCase(),
              text2: 'All academic materials are stored in one place',
              hasButton: false,
            ),

            //Book ordering
            CustomPreviewContainer(
              logoPath: 'assets/ccmfeedback.png',
              text1: 'CCM Feedback'.toUpperCase(),
              text2:
                  // 'Online platform to communicate among users to improve University life',
                  'Online feedback platform to improve University',
              hasButton: false,
            ),
            //Offences

            CustomPreviewContainer(
              logoPath: 'assets/web_mail.png',
              text1: 'web mail'.toUpperCase(),
              text2: 'Don\'t miss urgent messages',
              hasButton: false,
            ),
            //CW upload

            CustomPreviewContainer(
              logoPath: 'assets/tips_tricks.png',
              text1: 'Tips & Tricks'.toUpperCase(),
              text2:
                  'Helpful instructions to use WIUT online services in an efficient way',
              hasButton: true,
            ),

            //Social
            // CustomPreviewContainer(
            //   logoPath: 'assets/social.png',
            //   text1: 'WIUT network'.toUpperCase(),
            //   text2: 'Discuss your academic life with WIUT community ',
            //   hasButton: true,
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomPreviewContainer extends StatelessWidget {
  final logoPath;
  final text1;
  final bool hasButton;
  final text2;
  const CustomPreviewContainer(
      {Key key, this.logoPath, this.text1, this.hasButton, this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(logoPath),
                height: 120.0,
              ),
              SizedBox(height: 14.0),
              Text(
                text1,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 14.0),
                child: Text(
                  text2,
                  style: TextStyle(color: whiteColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 14.0),
                  child: hasButton
                      ? RaisedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            await prefs.setBool(isPreviewSeen, true);
                            Navigator.of(context)
                                .pushReplacementNamed(loginPage);
                          },
                          color: Colors.white,
                          child: Text('Get Started'),
                        )
                      : null)
            ],
          ),
        ],
      ),
    );
  }
}
