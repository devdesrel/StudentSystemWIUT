import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/pages/module_assignment_turnitin_page.dart';

class ModuleTurnitinPage extends StatelessWidget {
  final LearningMaterialsModel module;
  ModuleTurnitinPage({this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(module.moduleName),
          centerTitle: true,
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ModuleAssignmentTurnitinPage(module: module)));
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        color: greyColor,
                        // color: Colors.white,
                        width: 75.0,
                        height: 75.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '23',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.0),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Similarity',
                                  // textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text('Assignment: '),
                                  Text(
                                    'CW 1',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text('Period: '),
                                  Text(
                                    'Semester One',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.right_chevron,
                        color: lightGreyTextColor,
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //
        ));
  }
}
