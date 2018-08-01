import 'package:flutter/material.dart';
import 'package:student_system_flutter/pages/comments_page.dart';
import 'package:student_system_flutter/pages/contacts_page.dart';
import 'package:student_system_flutter/pages/coursework_upload_page.dart';
import 'package:student_system_flutter/pages/file_downloader_page.dart';
import 'package:student_system_flutter/pages/file_picker_page.dart';
import 'package:student_system_flutter/pages/files_downloaded_page.dart';

import 'package:student_system_flutter/pages/home_page.dart';
import 'package:student_system_flutter/pages/lectures_page.dart';
import 'package:student_system_flutter/pages/login_page.dart';
import 'package:student_system_flutter/pages/map_page.dart';
import 'package:student_system_flutter/pages/marks_page.dart';
import 'package:student_system_flutter/pages/modules_page.dart';
import 'package:student_system_flutter/pages/new_post_page.dart';
import 'package:student_system_flutter/pages/offences_page.dart';
import 'package:student_system_flutter/pages/offline_page.dart';
import 'package:student_system_flutter/pages/security_page.dart';
import 'package:student_system_flutter/pages/settings_page.dart';
import 'package:student_system_flutter/pages/social_page.dart';
import 'package:student_system_flutter/pages/timetable_page.dart';

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
  fileDownloaderPage: (BuildContext context) => FileDownloaderPage(),
  filesDownloadedPage: (BuildContext context) => FilesDownloadedPage(),
  tweetPage: (BuildContext context) => NewPostPage(),
  lecturesPage: (BuildContext context) => LecturesPage(),
  offlinePage: (BuildContext context) => OfflinePage(),
  courseworkUploadPage: (BuildContext context) => CourseworkUploadPage(),
  timetablePage: (BuildContext context) => TimetablePage(),
  filePickerPage: (BuildContext context) => FilePickerPage(),
  commentsPage: (BuildContext context) => CommentsPage(),
  settingsPage: (BuildContext context) => SettingsPage(),
  contactsPage: (BuildContext context) => ContactsPage(),
  mapPage: (BuildContext context) => MapPage(),
  // testPage: (BuildContext context) => TestUploadPage(),
};
