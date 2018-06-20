import 'package:flutter/material.dart';

import 'package:student_system_flutter/pages/home_page.dart';
import 'package:student_system_flutter/pages/login_page.dart';
import 'package:student_system_flutter/pages/security_page.dart';
import 'package:student_system_flutter/pages/social_page.dart';
import 'package:student_system_flutter/pages/tweet_page.dart';

import '../pages/marks_page.dart';
import '../pages/modules_page.dart';
import '../pages/offences_page.dart';
import 'app_constants.dart';

final routes = {
  '/': (BuildContext context) => LoginPage(),
  loginPage: (BuildContext context) => LoginPage(),
  securityPage: (BuildContext context) => SecurityPage(),
  homePage: (BuildContext context) => HomePage(),
  modulesPage: (BuildContext context) => ModulesPage(),
  marksPage: (BuildContext context) => MarksPage(),
  offencesPage: (BuildContext context) => OffencesPage(),
  socialPage: (BuildContext context) => SocialPage(),
  tweetPage: (BuildContext context) => TweetPage(),
};
