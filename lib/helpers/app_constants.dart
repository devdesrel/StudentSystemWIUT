import 'package:flutter/material.dart';

//Application
final appName = 'Student System';
final playStoreUrl =
    'https://play.google.com/store/apps/details?id=uz.wiut.flutterstudentsystems';
final appStoreUrl =
    'https://itunes.apple.com/us/app/wiut-intranet/id1437888555';

//Application colors
final primaryColor = Color(0xFF0091ea);
final primaryDarkColor = Color(0xFF0064b7);
final accentColor = Color(0xFF0091ea);
final redColor = Colors.red[700];
final greenColor = Colors.green[400];
final yellowColor = Colors.yellow;
final greyColor = Color(0xFF78909c);
// final greyColor = Colors.blueGrey;
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
final ccmAddFeedbackPage = '/ccmAddFeedbackPage';
final testPage2 = '/testPage2';
final videosPage = '/videosPage';
final replyPage = '/replyPage';
final ccmCategoryPage = '/ccmCategoryPage';
final ccmFeedbackForSUPage = '/ccmFeedbackForSUPage';
final timetablePickerIosPage = 'timetablePickerIosPage';
final tipsTricksPage = 'tipsTrickspage';
final tipsTricksListPage = 'tipsTricksListPage';
final ccmRoleSelectPage = 'ccmRoleSelectPage';
final socialProfilePage = 'socialProfilePage';
final socialSearchPage = 'socialSearchPage';
final socialMyPostsPage = 'socialMyPostsPage';
final attendancePage = 'attendancePage';
// final deadlinesListInfoPage = 'deadlinesListInfoPage';

//Shared preferance keys
final lastAppVersion = 'lastAppVersion';
final isLoggedIn = 'isLoggedIn';
final token = 'token';
final tokenExpireDay = 'tokenExpireDay';
final userID = 'userID';
final userTableID = 'userTableID';
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
final isApplicableForCCMFeedback = 'isApplicableForCCMFeedback';
final feedbackIsEditable = 'feedbackIsEditable';
final isSU = 'isSU';
final isSecurityValueOn = 'isSecurityValueOn';
final webMailTypePrefs = 'webMailTypePrefs';
final cleanApplicationUserData = 'cleanApplicationUserData';
final isDeadlinesListInfoVisible = 'isDeadlinesListInfoVisible';

//API List
final baseUrl = 'https://newintranetapi.wiut.uz';
final fileBaseUrl = 'http://intranet.wiut.uz';
final currentYearID = '24';
final apiAuthenticate = '$baseUrl/api/Account/Authenticate';
final apiStudentMarks =
    '$baseUrl/api/StudentProfileAndMarks/StudentProfileAndMarksForStudent';
// final apiGetClasses = '$baseUrl/api/TimeTable/GetClasses';
final apiGetLessons = '$baseUrl/api/TimeTableNew/GetLessons';
final apiGetGroups = '$baseUrl/api/TimeTableNew/GetClassesAsSelectList';
final apiGetRooms = '$baseUrl/api/TimeTableNew/GetClassRoomsAsSelectList';
final apiGetTeachers = '$baseUrl/api/TimeTableNew/GetTeachersAsSelectList';
final apiCpfsGetLessons = '$baseUrl/api/TimeTableCPFS/GetLessons';
final apiCpfsGetGroups = '$baseUrl/api/TimeTableCPFS/GetClassesAsSelectList';
final apiCpfsGetRooms = '$baseUrl/api/TimeTableCPFS/GetClassRoomsAsSelectList';
final apiCpfsGetTeachers = '$baseUrl/api/TimeTableCPFS/GetTeachersAsSelectList';

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
final apiCCMFeedbackGetCategorySelectionList =
    '$baseUrl/api/CCMFeedback/GetCategorySelectionList';
final apiCCMFeedbackGetCategoriesSelectionList =
    '$baseUrl/api/CCMFeedback/GetCategoriesSelectionList';

final apiCCMFeedbackGetModuleRepresentatives =
    '$baseUrl/api/CCMFeedback/GetModuleRepresentatives';
final apiCCMFeedbackGetFeedback = '$baseUrl/api/CCMFeedback/GetFeedback';
final apiCCMFeedbackGetFeedbackAsStaff =
    '$baseUrl/api/CCMFeedback/GetFeedbackAsStaff';

final apiCCMFeedbackGetModuleRepresentativesAsSelectList =
    '$baseUrl/api/CCMFeedback/GetModuleRepresentativesAsSelectList';
final getAllCurrentGroupsAsSelectList =
    '$baseUrl/api/CCMFeedback/GetAllCurrentGroupsAsSelectList';
final socialGetContentList = '$baseUrl/api/social/GetContentList';
final apiSocialGetComments = '$baseUrl/api/social/GetComments';
final apiSocialLike = '$baseUrl/api/social/Like';
final apiSocialUnlike = '$baseUrl/api/social/Unlike';
final apiSocialGetContentIdByNotificationId =
    '$baseUrl/api/social/GetContentIdByNotification';
final apiSocialGetContentByNotification =
    '$baseUrl/api/social/GetContentIdByNotification';

final apiCCMFeedbackAddFeedback = '$baseUrl/api/CCMFeedback/AddFeedback';
final apiCCMFeedbackEditFeedback = '$baseUrl/api/CCMFeedback/EditFeedback';
final apiCCMFeedbackDeleteFeedback = '$baseUrl/api/CCMFeedback/DeleteFeedback';
final apiGetCourseworkDeadlinesByModules =
    '$baseUrl/api/CourseworkUpload/GetCourseworkDeadlinesByModules';
final apiGetCCMRoles = '$baseUrl/api/CCMFeedback/GetCCMRoles';
final apiAcadOffences =
    "$baseUrl/api/StudentProfileAndMarks/GetStudentAcadOffences";
final apiAttendanceOffences =
    "$baseUrl/api/StudentProfileAndMarks/GetStudentAtOffences";
final apiDisciplinaryOffences =
    "$baseUrl/api/StudentProfileAndMarks/GetStudentDOffences";
final apiSocialProfile = '$baseUrl/api/social/SocialProfile';
final apiGetUserIdByUsername = '$baseUrl/api/social/GetUserId';
final apiSocialNotifications = '$baseUrl/api/social/SocialNotification';
final apiSocialMarkNotificationAsViewed =
    '$baseUrl/api/social/MarkNotificationsAsViewed';
final apiSocialSearch = '$baseUrl/api/social/GetUsers';
final apiSocialNotificationCount = '$baseUrl/api/social/NotificationCount';
final apiSocialCreateContent = '$baseUrl/api/social/CreateContent';
final apiSocialFollow = '$baseUrl/api/social/FollowMe';
final apiSocialGetFollowers = '$baseUrl/api/social/GetMyFollowers';
final apiSocialGetFollowings = '$baseUrl/api/social/GetMyFollowings';
final apiSocialGetMyPosts = '$baseUrl/api/social/GetMyContent';
final apiQrAttendance = '$baseUrl/api/Attendance/CheckIn';
//Errors List
final String authProblems = 'Authorization problems';
final String connectionFailure = 'Internet connection failure';
final String checkInternetConnection = 'Please, check your internet connection';
final String error = 'Error';
final String tryAgain = 'Please, try again later!';
final String youDontHaveGroup = 'You aren\'t allocated to any group yet';
final String timetableAvailableSoon = 'Timetable will be available soon';

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
final String noFeedback = 'There is no feedback';

//Screen Size constants
final smallDeviceWidth = 360;
final smallDeviceHeight = 600;

//Academic Words
final toBeAnnounced = 'To Be Announced';
