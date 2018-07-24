import 'package:flutter/material.dart';

//Application Name
final appName = 'Student System';

//Application colors
final primaryColor = Color(0xFF0091ea);
final primaryDarkColor = Color(0xFF0064b7);
final accentColor = Color(0xFF0091ea);
final redColor = Colors.redAccent;
final greyColor = Colors.blueGrey;
final lightOverlayColor = Color(0xBF333333);
final backgroundColor = Colors.grey[100];
final blackColor = Color(0xCC333333);
final whiteColor = Color(0xCCffffff);
final textColor = Color(0xFF616161);
final lightGreyTextColor = Color(0xBF616161);

//Application route names
final loginPage = '/login';
final securityPage = '/security';
final homePage = '/home';
//final shrineApp = '/shrineApp';
final modulesPage = '/modules';
final marksPage = '/marks';
final offencesPage = '/offences';
final socialPage = '/social';
final fileDownloaderPage = '/fileDownloaderPage';
final filesDownloadedPage = '/filesDownloadedPage';
final tweetPage = '/tweetPage';
final lecturesPage = '/lecturesPage';
final courseworkUploadPage = '/courseworkUploadPage';
final timetablePage = '/timetablePage';
final filePickerPage = '/filePickerPage';
final commentsPage = '/commentsPage';

//User details
final isLoggedIn = 'isLoggedIn';
final token = 'token';
final studentID = 'studentID';
final firstName = 'firstName';
final lastName = 'lastName';
final pinCode = '1234';
final groupID = 'groupID';

//API List
final baseUrl = 'https://newintranetapi.wiut.uz';
final apiAuthenticate = '$baseUrl/api/Account/Authenticate';
final apiStudentMarks =
    '$baseUrl/api/StudentProfileAndMarks/StudentProfileAndMarksForStudent';
final apiGetClasses = '$baseUrl/api/TimeTable/GetClasses';
final apiGetLessons = '$baseUrl/api/TimeTable/GetLessons';
final apiGetGroups = '$baseUrl/api/TimeTable/GetClassesAsSelectList';
final apiGetRooms = '$baseUrl/api/TimeTable/GetClassRoomsAsSelectList';
final apiGetTeachers = '$baseUrl/api/TimeTable/GetTeachersAsSelectList';

//Errors List
final String tryAgain = 'Please, try again!';

//String Helpers List
final String nullFixer = '';
