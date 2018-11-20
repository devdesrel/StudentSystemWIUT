import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/pages/offline_page.dart';
import 'package:connectivity/connectivity.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_modules.dart';
import '../models/modules_list_model.dart';

class ModulesPage extends StatelessWidget {
  final requestType;

  ModulesPage({@required this.requestType});

  Future<List<Module>> _getModulesWithMarks(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _studentID = prefs.getString(userID);

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
          MessageTypes.ERROR, context, 2);
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
      String materialType, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    final _studentID = prefs.getString(userID);

    try {
      final response = await http.post(
          "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=$currentYearID&SelectedLTType=All&UserID=$_studentID",
          // "$apiUserModuleMaterialsModulesListByUserID?AcademicYearID=$currentYearID&SelectedLTType=$materialType&UserID=$_studentID",
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
      // showFlushBar(connectionFailure, checkInternetConnection,
      //     MessageTypes.ERROR, context, 2);

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
  // Future<List<Module>> _getMethods(BuildContext context, RequestType requestType){
  //   if(requestType==RequestType.GetMarks){
  //     return
  //     _getModulesWithMarks(context);
  //   } else{

  //   }
  // }

  Future<Widget> _checkInternetConnection(BuildContext context) async {
    ConnectivityResult connectionStatus;
    final Connectivity _connectivity = new Connectivity();
    try {
      connectionStatus = await _connectivity.checkConnectivity();
      if (requestType == RequestType.GetTeachingMaterials &&
          connectionStatus == ConnectivityResult.none) {
        showFlushBar(connectionFailure, checkInternetConnection,
            MessageTypes.ERROR, context, 2);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'You are in offline mode. Do you want to view Dowloaded Materials?',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.3),
                ),
              ),
              SizedBox(height: 10.0),
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
              future: requestType == RequestType.GetMarks
                  ? _getModulesWithMarks(context)
                  : _getLearningMaterials('Lecture', context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var _modulesList = snapshot.data;

                  List<Entry> _sortedModulesList = [];

                  int _initialLevel = 7;

                  for (var i = 0; i < 5; i++) {
                    List<dynamic> _modules = _modulesList
                        .where((m) => m.level == _initialLevel.toString())
                        .toList();
                    if (_modules.length > 0) {
                      _sortedModulesList
                          .add(Entry('Level $_initialLevel', _modules));
                    }

                    _initialLevel--;
                  }

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
                              initiallyExpanded: i == 0 ? true : false,
                              title: Text(_sortedModulesList[i].title),
                              children: _sortedModulesList[i]
                                  .children
                                  .map((m) => ItemModules(
                                        module: m,
                                        requestType: requestType,
                                      ))
                                  .toList(),
                            ));

                        // EntryItem(_sortedModulesList[i]);
                        // ItemModules(positionIndex: i, module: snapshot.data[i]);
                      });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return DrawPlatformCircularIndicator();
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
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text('Modules'),
              centerTitle: true,
              actions: <Widget>[
                requestType == RequestType.GetTeachingMaterials
                    ? IconButton(
                        icon: Icon(MdiIcons.folderDownload),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OfflinePage(moduleName: '')));
                        },
                      )
                    : Container()
              ],
            ),
            body: FutureBuilder<Widget>(
                future: _checkInternetConnection(context),
                initialData: DrawPlatformCircularIndicator(),
                builder: (context, snapshot) => snapshot.data),
          )
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                  middle: Text('Modules'),
                  trailing: Material(
                    color: Colors.transparent,
                    child: requestType == RequestType.GetTeachingMaterials
                        ? IconButton(
                            icon: Icon(MdiIcons.folderDownload),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      OfflinePage(moduleName: '')));
                            },
                          )
                        : Container(
                            width: 2.0,
                          ),
                  )),
              child: FutureBuilder<Widget>(
                  future: _checkInternetConnection(context),
                  initialData: CupertinoActivityIndicator(),
                  builder: (context, snapshot) => snapshot.data),
            ),
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
