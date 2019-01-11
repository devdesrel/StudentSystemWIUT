// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:student_system_flutter/helpers/app_constants.dart';
// import 'package:http/http.dart' as http;

// class NewPostBloc {
//   String userId;
//   String postText;
//   //TODO: modify & implement

//   void createPost() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final _token = prefs.getString(token);

//     String postJson;
//     String quotesFixedFeedbackText =
//         postText.replaceAll('\'', '\\\'').replaceAll('\"', '\\\"');

//     try {
//       postJson =
//           '{"Type": "feedbackCategory", "IsPositive": isPositive, "DepOrModID": {model.depOrModID}, "StaffID": {int.tryParse(staffID)}, "GroupCoverage": {groupCoverage.toInt()}, "Text": "$quotesFixedFeedbackText"}';

//       http.Response res = await http.post(apiCCMFeedbackAddFeedback,
//           body: postJson,
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $_token"
//           }); // post api call

//       if (res.statusCode == 200) {
//         // Navigator.of(context).pop();
//       }
//       // _isSaveButtonEnabledSubject.add(true);
//     } catch (e) {
//       // showFlushBar(connectionFailure, checkInternetConnection,
//       //     MessageTypes.ERROR, context, 2);
//     }
//   }

//   NewPostBloc();
// }

// // {
// //   "ParentId": 0,
// //   "ContentText": "string",
// //   "UploadImage": {
// //     "ContentLength": 0,
// //     "ContentType": "string",
// //     "FileName": "string",
// //     "InputStream": {
// //       "__identity": {}
// //     }
// //   },
// //   "ModuleId": 0,
// //   "UserId": 0
// // }
