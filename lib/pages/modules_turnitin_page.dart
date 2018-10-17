import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';

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
        floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.report,
            )),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Column(children: <Widget>[
            Center(
              child: Container(
                color: Colors.white,
                height: 150.0,
                width: 150.0,
                child: Center(
                    child: Text(
                  '23 %',
                  style: TextStyle(
                      color: yellowColor,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Level: '),
                        Text(module.level),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Module Name: '),
                        Flexible(
                            child: Text(
                          module.moduleName,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Module Code: '),
                        Flexible(
                            child: Text(
                          module.moduleCode,
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('File name'), Text('CW.docx')],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('Grade'), Text(' ')],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('Similarity'), Text('23 %')],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('Late submission'), Text(' ')],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        )));
  }
}
