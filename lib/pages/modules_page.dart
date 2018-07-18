import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_modules.dart';
import '../models/modules_list_model.dart';

// void _showSnackBar(String text) {
//   scaffoldKey.currentState.showSnackBar(SnackBar(
//     backgroundColor: Colors.blueGrey,
//     content: Text(text),
//     duration: Duration(seconds: 2),
//   ));
// }

Future<List<Module>> getModulesWithMarks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString(token);
  final _studentID = prefs.getString(studentID);

  final response = await http.post("$apiStudentMarks?UserID=$_studentID",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

  return compute(parseModules, response.body);
}

List<Module> parseModules(String responseBody) {
  final studentViewModuleMarksPropField = 'studentViewModuleMarksPropField';

  final parsedData = json.decode(responseBody)[studentViewModuleMarksPropField];

  ModulesList modulesList = ModulesList(
      studentViewModuleMarksPropField:
          parsedData.map<Module>((json) => Module.fromJson(json)).toList());

  return modulesList.studentViewModuleMarksPropField;
}

class ModulesPage extends StatefulWidget {
  final requestType;

  ModulesPage({this.requestType});

  @override
  _ModulesPageState createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  // var _levelsList = List<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marks Page')),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: FutureBuilder<List<Module>>(
            future: widget.requestType == RequestType.GetMarks
                ? getModulesWithMarks()
                : getModulesWithMarks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _modulesList = snapshot.data;

                List<Entry> _sortedModulesList = <Entry>[
                  Entry('Level 6',
                      _modulesList.where((m) => m.levelField == '6').toList()),
                  Entry('Level 5',
                      _modulesList.where((m) => m.levelField == '5').toList()),
                  Entry('Level 4',
                      _modulesList.where((m) => m.levelField == '4').toList()),
                  Entry('Level 3',
                      _modulesList.where((m) => m.levelField == '3').toList()),
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
                              .map((m) => ItemModules(module: m))
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
      ),
    );
  }
}

class Entry {
  Entry(this.title, this.children);

  final String title;

  final List<Module> children;
}

class EntryItem extends StatefulWidget {
  EntryItem(this.entry);

  final Entry entry;

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  @override
  Widget build(BuildContext context) {
    // return _buildTiles(widget.entry);
    return ExpansionTile(
      key: PageStorageKey<Entry>(widget.entry),
      title: Text(widget.entry.title),
      children:
          widget.entry.children.map((m) => ItemModules(module: m)).toList(),
    );
  }
}
