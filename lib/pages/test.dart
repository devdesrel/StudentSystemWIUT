// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../helpers/app_constants.dart';
// import '../list_items/item_modules.dart';
// import '../models/modules_list_model.dart';

// // void _showSnackBar(String text) {
// //   scaffoldKey.currentState.showSnackBar(SnackBar(
// //     backgroundColor: Colors.blueGrey,
// //     content: Text(text),
// //     duration: Duration(seconds: 2),
// //   ));
// // }

// class ModulesPage extends StatefulWidget {
//   @override
//   _ModulesPageState createState() => _ModulesPageState();
// }

// class _ModulesPageState extends State<ModulesPage>
//     with TickerProviderStateMixin {
//   TabController _tabController;
//   TabPageSelector _tabPageSelector;
//   var _levelsList = List<String>();

//   Future<List<Module>> getModulesWithMarks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final _token = prefs.getString(token);
//     final _studentID = prefs.getString(studentID);

//     final response = await http.post("$apiStudentMarks?UserID=$_studentID",
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $_token"
//         });

//     return compute(parseModules, response.body);
//   }

//   List<Module> parseModules(String responseBody) {
//     final studentViewModuleMarksPropField = 'studentViewModuleMarksPropField';

//     final parsedData =
//         json.decode(responseBody)[studentViewModuleMarksPropField];

//     ModulesList modulesList = ModulesList(
//         studentViewModuleMarksPropField:
//             parsedData.map<Module>((json) => Module.fromJson(json)).toList());

//     setState(() {
//       _levelsList.clear();
//     });
//     //   levelsList.clear();

//     modulesList.studentViewModuleMarksPropField.forEach((module) {
//       !_levelsList.contains(module.levelField) ??
//           _levelsList.add(module.levelField);
//     });

//     setState(() {
//       _tabController =
//           new TabController(vsync: this, length: _levelsList.length);
//       _tabPageSelector = new TabPageSelector(controller: _tabController);
//     });

//     return modulesList.studentViewModuleMarksPropField;
//   }

//   @override
//   void initState() {
//     super.initState();

//     // _levelsList.add('Level 6');
//     // _levelsList.add('Level 5');
//     _levelsList.add('Level 4');
//     _levelsList.add('Level 3');

//     _tabController = new TabController(vsync: this, length: _levelsList.length);
//     _tabPageSelector = new TabPageSelector(controller: _tabController);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<Widget> _buildTabs() {
//     var _tabsList = List<Widget>();

//     _levelsList.isNotEmpty
//         ? _levelsList.forEach((levelName) {
//             _tabsList.add(Tab(
//                 child: Text(
//               levelName,
//               style: TextStyle(color: Colors.white),
//             )));
//           })
//         : Tab(text: 'X');

//     return _tabsList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     getModulesWithMarks();
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Marks Page'),
//           bottom: TabBar(
//               controller: _tabController,
//               labelColor: Theme.of(context).accentColor,
//               indicatorColor: Theme.of(context).accentColor,
//               tabs: _buildTabs()),
//         ),
//         body: TabBarView(
//           controller: _tabController,
//           children: _levelsList.isEmpty
//               ? <Widget>[]
//               : _levelsList.map((levelName) {
//                   return new Card(
//                       child: new Container(
//                     height: 450.0,
//                     width: 300.0,
//                     child: Text(levelName),
//                   ));
//                 }).toList(),
//         )
//         // Container(
//         //   color: Theme.of(context).backgroundColor,
//         //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//         //   child: FutureBuilder<List<Module>>(
//         //       future: getModulesWithMarks(),
//         //       builder: (context, snapshot) {
//         //         if (snapshot.hasData) {
//         //           return ListView.builder(
//         //             reverse: true,
//         //             scrollDirection: Axis.vertical,
//         //             itemCount: snapshot.data.length,
//         //             itemBuilder: (context, i) =>
//         //                 ItemModules(positionIndex: i, module: snapshot.data[i]),
//         //           );
//         //         } else if (snapshot.hasError) {
//         //           return Text("${snapshot.error}");
//         //         }

//         //         // By default, show a loading spinner
//         //         return Center(child: CircularProgressIndicator());
//         //       }),
//         // ),
//         );
//   }
// }
