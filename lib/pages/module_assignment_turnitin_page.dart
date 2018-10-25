import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';

class ModuleAssignmentTurnitinPage extends StatelessWidget {
  final LearningMaterialsModel module;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  ModuleAssignmentTurnitinPage({this.module});
  @override
  Widget build(BuildContext context) {
    double screenWidthSize = MediaQuery.of(context).size.width;
    double circularChartSize = screenWidthSize / 1.3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Turnitin Details'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Column(children: <Widget>[
        Container(
          child: AnimatedCircularChart(
            duration: Duration(milliseconds: 1500),
            key: _chartKey,
            size: Size(circularChartSize, circularChartSize),
            initialChartData: <CircularStackEntry>[
              CircularStackEntry(
                <CircularSegmentEntry>[
                  CircularSegmentEntry(
                    23.0,
                    Colors.red[700],
                    rankKey: 'completed',
                  ),
                  CircularSegmentEntry(
                    77.0,
                    // Colors.white,
                    // lightGreyTextColor,
                    Colors.grey[300],
                    rankKey: 'remaining',
                  ),
                ],
                rankKey: 'progress',
              ),
            ],
            chartType: CircularChartType.Radial,
            percentageValues: true,
            holeLabel: '23%',
            labelStyle: TextStyle(
              color: Colors.red[700],
              // fontWeight: FontWeight.bold,
              fontSize: 50.0,
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Text('Module Name: '),
                      Flexible(
                          child: Center(
                        child: Text(
                          module.moduleName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('Deadline: '), Text('12/12/18')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('File name: '), Text('CW.docx')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('Similarity: '), Text('23 %')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text('Late submission: '), Text('No')],
                  ),
                  ButtonTheme(
                    minWidth: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      color: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Report',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
