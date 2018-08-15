import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/pages/offline_page.dart';
import 'package:connectivity/connectivity.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_modules.dart';
import '../models/modules_list_model.dart';

class ModulesPage extends StatefulWidget {
  final requestType;

  ModulesPage({@required this.requestType});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Module>> _getModulesWithMarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _studentID = prefs.getString(studentID);

    try {
      final response = await http.post("$apiStudentMarks?UserID=$_studentID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseModules(response.body);
      } else {
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }

      // return compute(_parseModules, response.body);
    } catch (e) {
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 5);
      return null;
    }
  }

  List<Module> _parseModules(String responseBody) {
    final studentViewModuleMarksPropField = 'studentViewModuleMarksPropField';

    final parsedData =
        json.decode(responseBody)[studentViewModuleMarksPropField];

    ModulesList modulesList = ModulesList(
        studentViewModuleMarksPropField:
            parsedData.map<Module>((json) => Module.fromJson(json)).toList());

    return modulesList.studentViewModuleMarksPropField;
  }

  Future<List<LearningMaterialsModel>> _getLearningMaterials(
      String materialType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _studentID = prefs.getString(studentID);

    try {
      final response = await http.post(
          "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=18&SelectedLTType=All&UserID=$_studentID",
          // "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=18&SelectedLTType=$materialType&UserID=$_studentID",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (response.statusCode == 200) {
        return _parseLearningMaterials(response.body);
      } else {
        showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
        return null;
      }

      // return compute(_parseModules, response.body);
    } catch (e) {
      print(e.toString());
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 5);

      return null;
    }
  }

  List<LearningMaterialsModel> _parseLearningMaterials(String responseBody) {
    final parsed = json.decode(responseBody);

    List<LearningMaterialsModel> lists = parsed
        .map<LearningMaterialsModel>(
            (item) => LearningMaterialsModel.fromJson(item))
        .toList();

    return lists;
  }

  Future<Widget> checkConnectivity() async {
    ConnectivityResult connectionStatus;
    final Connectivity _connectivity = new Connectivity();
    try {
      connectionStatus = await _connectivity.checkConnectivity();
      if (widget.requestType == RequestType.GetTeachingMaterials &&
          connectionStatus == ConnectivityResult.none) {
        showFlushBar(connectionFailure, checkInternetConnection,
            MessageTypes.ERROR, context, 2);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'You are in offline mode. Do you want to view Dowloaded Materials?',
                  textAlign: TextAlign.center,
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                ),
                child: Text(
                  'View',
                  style: TextStyle(color: Colors.white),
                ),
                color: accentColor,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OfflinePage(moduleName: '')));
                },
              ),
            ],
          ),
        );
      } else {
        return Container(
          color: Theme.of(context).backgroundColor,
          child: FutureBuilder(
              future: widget.requestType == RequestType.GetMarks
                  ? _getModulesWithMarks()
                  : _getLearningMaterials('Lecture'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var _modulesList = snapshot.data;

                  List<Entry> _sortedModulesList = <Entry>[
                    Entry('Level 6',
                        _modulesList.where((m) => m.level == '6').toList()),
                    Entry('Level 5',
                        _modulesList.where((m) => m.level == '5').toList()),
                    Entry('Level 4',
                        _modulesList.where((m) => m.level == '4').toList()),
                    Entry('Level 3',
                        _modulesList.where((m) => m.level == '3').toList()),
                  ];

                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _sortedModulesList.length,
                      itemBuilder: (context, i) {
                        // return Text(_sortedModulesList[i].title);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.0),
                          child: ExpansionTile(
                            // key: PageStorageKey<Entry>(_sortedModulesList),

                            title: Text(_sortedModulesList[i].title),
                            children: _sortedModulesList[i]
                                .children
                                .map((m) => ItemModules(
                                      module: m,
                                      requestType: widget.requestType,
                                    ))
                                .toList(),
                          ),
                        );

                        // EntryItem(_sortedModulesList[i]);
                        // ItemModules(positionIndex: i, module: snapshot.data[i]);
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return Center(child: CircularProgressIndicator());
              }),
        );
      }
      // print(connectionStatus);
    } on PlatformException catch (e) {
      // } catch (e) {
      print(e.toString());
      // connectionStatus = 'Failed to get connectivity.';
      // return --------------;
    }
    return Container();
  }

  // List<LearningMaterialsModel> _parseLearningMaterials(String responseBody) {
  //   final studentViewModuleMarksPropField = 'studentViewModuleMarksPropField';

  //   final parsedData = json.decode(responseBody);

  //   ModulesList modulesList = ModulesList(
  //       studentViewModuleMarksPropField:
  //           parsedData.map<Module>((json) => Module.fromJson(json)).toList());

  //   return modulesList.studentViewModuleMarksPropField;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
        centerTitle: true,
        actions: <Widget>[
          widget.requestType == RequestType.GetTeachingMaterials
              ? IconButton(
                  icon: Icon(Icons.cloud_download),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OfflinePage(moduleName: '')));
                  },
                )
              : Container()
        ],
      ),
      body: FutureBuilder<Widget>(
          future: checkConnectivity(),
          initialData: CircularProgressIndicator(),
          builder: (context, snapshot) => snapshot.data),
    );
  }
}

class Entry {
  Entry(this.title, this.children);

  final String title;

  final List<dynamic> children;
}

// class EntryItem extends StatefulWidget {
//   EntryItem(this.entry, @required this.requestType);
//   final RequestType requestType;

//   final Entry entry;

//   @override
//   _EntryItemState createState() => _EntryItemState();
// }

// class _EntryItemState extends State<EntryItem> {
//   @override
//   Widget build(BuildContext context) {
//     // return _buildTiles(widget.entry);
//     return ExpansionTile(
//       key: PageStorageKey<Entry>(widget.entry),
//       title: Text(widget.entry.title),
//       children: widget.entry.children
//           .map((m) => ItemModules(
//                 module: m,
//                 requestType: widget.requestType,
//               ))
//           .toList(),
//     );
//   }
// }
