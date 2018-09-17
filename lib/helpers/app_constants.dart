import 'package:flutter/material.dart';

//Application
final appName = 'Student System';
final playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.wiut.studentsystemflutter';

//Application colors
final primaryColor = Color(0xFF0091ea);
final primaryDarkColor = Color(0xFF0064b7);
final accentColor = Color(0xFF0091ea);
final redColor = Colors.red[700];
final greenColor = Colors.green[400];
final yellowColor = Colors.yellow;
final greyColor = Colors.blueGrey;
final lightOverlayColor = Color(0xBF333333);
final backgroundColor = Color(0xFFF1F1F5);
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
final offlinePage = '/offlinePage';
final courseworkUploadPage = '/courseworkUploadPage';
final timetablePage = '/timetablePage';
final filePickerPage = '/filePickerPage';
final commentsPage = '/commentsPage';
final settingsPage = '/settingsPage';
final contactsPage = '/contactsPage';
final mapPage = '/mapPage';
final appUpdatesPage = '/appUpdatesPage';
final testPage = '/testPage';
final booksPage = '/booksPage';
final supportPage = '/supportPage';
final iosContactsPage = '/iosContactsPage';
final previewPage = '/previewPage';
final iosPinSetPage = '/iosPinSetPage';
final ccmFeedbackPage = '/ccmFeedbackPage';

//Shared preferance keys
final lastAppVersion = 'lastAppVersion';
final isLoggedIn = 'isLoggedIn';
final token = 'token';
final tokenExpireDay = 'tokenExpireDay';
final studentID = 'studentID';
final userPasssword = 'userPasssword';
final firstName = 'firstName';
final lastName = 'lastName';
final pinCode = 'pinCode';
final groupID = 'groupID';
final groupNameSharedPref = 'groupNameSharedPref';
final academicYearIDSharedPref = 'academicYearIDSharedPref';
final useFingerprint = 'useFingerprint';
final minAppVersion = 'minAppVersion';
final isPinFilled = 'isPinFilled';
final isPreviewSeen = 'isPreviewSeen';
final isUnderDevelopmentFeaturesInvisible =
    'isUnderDevelopmentFeaturesInvisible';
final userRole = 'userRole';
final teacherID = 'teacherID';
final teacherNameSharedPref = 'teacherNameSharedPref';
final lastAppVersion = 'lastAppVersion';

//API List
final baseUrl = 'https://newintranetapi.wiut.uz';
final currentYearID = '19';
final apiAuthenticate = '$baseUrl/api/Account/Authenticate';
final apiStudentMarks =
    '$baseUrl/api/StudentProfileAndMarks/StudentProfileAndMarksForStudent';
final apiGetClasses = '$baseUrl/api/TimeTable/GetClasses';
final apiGetLessons = '$baseUrl/api/TimeTable/GetLessons';
final apiGetGroups = '$baseUrl/api/TimeTable/GetClassesAsSelectList';
final apiGetRooms = '$baseUrl/api/TimeTable/GetClassRoomsAsSelectList';
final apiGetTeachers = '$baseUrl/api/TimeTable/GetTeachersAsSelectList';
final apiUserModuleMaterialsModulesListByUserID =
    '$baseUrl/api/UserModuleMaterials/ModulesListByUserID';
final apiGetAttachmentsByModuleMaterialIDWithFileSize =
    '$baseUrl/api/UserModuleMaterials/GetAttachmentsByModuleMaterialIDWithFileSize';
final apiComponentMark =
    '$baseUrl/api/StudentProfileAndMarks/StudentModuleComponentMark';
final apiGetMinAppVersion = '$baseUrl/api/GetMinApp/GetMinApp';
final apiMinAppVersionByPlatform =
    '$baseUrl/api/GetMinApp/MinAppVersionByPlatform';
final apiStudentProfile =
    '$baseUrl/api/StudentProfileAndMarks/GetStudentGroupByUserID';
final apiStudentProfileForSelectedAcademicYear =
    '$baseUrl/api/StudentProfileAndMarks/GetStudentGroupByUserIDAndAcadYearID';
final apiProfileGetProfileByUserName =
    '$baseUrl/api/Profile/GetProfileByUserName';

//Errors List
final String authProblems = 'Authorization problems';
final String connectionFailure = 'Internet connection failure';
final String checkInternetConnection = 'Please, check your internet connection';
final String error = 'Error';
final String tryAgain = 'Please, try again later!';
final String youDontHaveGroup = 'You aren\'t allocated to any group yet';
final String usernamePasswordIncorrect =
    'Username or Password is incorrect. Try again!';

//String Helpers List
final String nullFixer = '';
final String info = 'Info';
final String featureNotImplemented = 'Feature has not fully implemented yet';
final String downloadingMessageTitle = 'Downloading files';
final String downloadingMessageBody =
    'Please, don\'t leave this page until the process is done';
final String noDownloadedFiles = 'You haven\'t downloaded any files yet';
final String noFilesToDownload = 'There is no files to download';
final String noAvailableTimetable = 'Nothing to show for the current week';

//Screen Size constants
final smallDeviceWidth = 360;
final smallDeviceHeight = 600;

//Academic Words
final toBeAnnounced = 'To Be Announced';
