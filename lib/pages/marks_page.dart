import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/modules_component.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../models/modules_list_model.dart';

List<ModuleComponentModel> _parseComponents(String responseBody) {
  final parsedData = json.decode(responseBody);

  List<ModuleComponentModel> list = parsedData
      .map<ModuleComponentModel>((item) => ModuleComponentModel.fromJson(item))
      .toList();

  return list;
}

Future<List<ModuleComponentModel>> _getModulesWithComponents(
    BuildContext context, Module module) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString(token);
  final _studentID = prefs.getString(studentID);

  try {
    final response = await http.post(
        "$apiComponentMark?StudentID=$_studentID&AcadYearText=${module.session}&ModuleID=${module.moduleID}",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $_token"
        });

    if (response.statusCode == 200) {
      return _parseComponents(response.body);
    } else {
      showFlushBar('Error', tryAgain, MessageTypes.ERROR, context, 2);
      return null;
    }
  } catch (e) {
    showFlushBar(connectionFailure, checkInternetConnection, MessageTypes.ERROR,
        context, 2);
    return null;
  }
}

class MarksPage extends StatelessWidget {
  final Module module;

  MarksPage({this.module});

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
    TextStyle _getTextStyle() {
      return Theme.of(context).textTheme.headline.copyWith(
          color: getMarkColor(module.moduleMark),
          fontSize: 17.0,
          fontWeight: FontWeight.bold);
    }

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = Platform.isAndroid
        ? (size.height - kToolbarHeight - 24) / 2
        : size.height / 2;

    bool isSmallScreen = false;

    if (size.height < smallDeviceHeight) {
      isSmallScreen = true;
    }

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    print('Query Data' + queryData.devicePixelRatio.toString());

    print('QWidth: ${queryData.size.width}; QHeight: ${queryData.size.height}');
    print('Width: ${queryData.size.width}; Height: ${queryData.size.height}');

    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(module != null ? module.moduleName : ''),
            ),
            // body: CustomGridView(context).build(),
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                        height: itemHeight,
                        child: CustomGridView(context, module).build()),
                    SizedBox(
                      height: itemHeight,
                      child: Container(
                        color: whiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AnimatedCircularChart(
                                    duration: Duration(seconds: 2),
                                    key: _chartKey,
                                    size: isSmallScreen
                                        ? Size(200.0, 200.0)
                                        : Size(230.0, 230.0),
                                    initialChartData: <CircularStackEntry>[
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            getMarkInDouble(module.moduleMark),
                                            isNumeric(module.moduleMark)
                                                ? greenColor
                                                : accentColor,
                                            rankKey: 'completed',
                                            // rankKey: 'progress',
                                          ),
                                          new CircularSegmentEntry(
                                            100 -
                                                getMarkInDouble(
                                                    module.moduleMark),
                                            isNumeric(module.moduleMark)
                                                ? redColor
                                                : accentColor,

                                            rankKey: 'remaining',
                                            // rankKey: 'progress',
                                          ),
                                        ],
                                        rankKey: 'progress',
                                      ),
                                    ],
                                    chartType: CircularChartType.Radial,
                                    percentageValues: true,
                                    holeLabel: '${module.moduleMark}',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .display2
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: getMarkColor(
                                                module.moduleMark))),
                                Text(
                                    module.moduleGrade == '' &&
                                            module.moduleMark == 'TBA'
                                        ? toBeAnnounced
                                        : module.moduleGrade,
                                    style: _getTextStyle()),

                                // CustomAnimatedText()
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text(
                  module != null ? module.moduleName : '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                          height: itemHeight,
                          child: SafeArea(
                              bottom: false,
                              child: CustomGridView(context, module).build())),
                      SizedBox(
                        height: itemHeight,
                        child: Container(
                          color: whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AnimatedCircularChart(
                                      duration: Duration(seconds: 2),
                                      key: _chartKey,
                                      size: isSmallScreen
                                          ? Size(200.0, 200.0)
                                          : Size(230.0, 230.0),
                                      initialChartData: <CircularStackEntry>[
                                        new CircularStackEntry(
                                          <CircularSegmentEntry>[
                                            new CircularSegmentEntry(
                                              getMarkInDouble(
                                                  module.moduleMark),
                                              isNumeric(module.moduleMark)
                                                  ? greenColor
                                                  : accentColor,
                                              rankKey: 'completed',
                                              // rankKey: 'progress',
                                            ),
                                            new CircularSegmentEntry(
                                              100 -
                                                  getMarkInDouble(
                                                      module.moduleMark),
                                              isNumeric(module.moduleMark)
                                                  ? redColor
                                                  : accentColor,

                                              rankKey: 'remaining',
                                              // rankKey: 'progress',
                                            ),
                                          ],
                                          rankKey: 'progress',
                                        ),
                                      ],
                                      chartType: CircularChartType.Radial,
                                      percentageValues: true,
                                      holeLabel: '${module.moduleMark}',
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .display2
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: getMarkColor(
                                                  module.moduleMark))),
                                  Text(
                                      module.moduleGrade == '' &&
                                              module.moduleMark == 'TBA'
                                          ? toBeAnnounced
                                          : module.moduleGrade,
                                      style: _getTextStyle()),

                                  // CustomAnimatedText()
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class CustomAnimatedText extends StatefulWidget {
  @override
  _CustomAnimatedTextState createState() => _CustomAnimatedTextState();
}

class _CustomAnimatedTextState extends State<CustomAnimatedText> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(seconds: 1),
      child: Text(
        'Total Mark'.toUpperCase(),
        style:
            Theme.of(context).textTheme.headline.copyWith(color: accentColor),
      ),
    );
  }
}

class CustomGridView {
  BuildContext context;
  final Module module;

  CustomGridView(this.context, this.module);

  Widget makeGridCell(String componentName, int mark, int weight) {
    TextStyle _componentNameTextStyle =
        Theme.of(context).textTheme.headline.copyWith(color: whiteColor);

    TextStyle _greyTextStyle = Theme.of(context)
        .textTheme
        .headline
        .copyWith(color: Theme.of(context).textSelectionColor, fontSize: 17.0);
    TextStyle _accentTextStyle = Theme.of(context)
        .textTheme
        .headline
        .copyWith(color: Theme.of(context).accentColor, fontSize: 16.0);

    return CustomCard(
      InkWell(
        onTap: () {
          print('object');
        },
        child: Container(
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Container(
                color: Theme.of(context).accentColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  componentName.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _componentNameTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Mark'.toUpperCase(),
                        style: _greyTextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: Text(
                          '$mark',
                          style: _accentTextStyle,
                        ),
                      ),
                    ]),
              ),
              Container(
                color: Theme.of(context).accentColor,
                height: 1.5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Weight'.toUpperCase(),
                        style: _greyTextStyle,
                      ),
                      Text(
                        '$weight%',
                        style: _accentTextStyle,
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build() {
    var size = MediaQuery.of(context).size;
    bool isSmallScreen = false;

    print('Width: ${size.width}; Height: ${size.height}');

    if (size.height < smallDeviceHeight) {
      isSmallScreen = true;
    }
    return FutureBuilder<List<ModuleComponentModel>>(
      future: _getModulesWithComponents(context, module),
      builder: (context, snapshot) => snapshot.hasData
          ? Center(
              child: GridView.count(
                // primary: true,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                crossAxisCount: snapshot.data.length > 2 ? 2 : 1,
                childAspectRatio: isSmallScreen
                    ? snapshot.data.length > 2 ? 1.2 : 2.4
                    : snapshot.data.length > 2 ? 1.4 : 2.8, //1.38
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: ScrollController(keepScrollOffset: false),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                children: snapshot.data
                    .map<Widget>((ModuleComponentModel item) => makeGridCell(
                        item.assessTitle,
                        int.parse(item.mark),
                        int.parse(item.weighting)))
                    .toList(),
                // children: <Widget>[
                //   makeGridCell("СW1", 87, 20),
                //   makeGridCell("СW2", 55, 30),
                //   makeGridCell("СW3", 71, 30),
                //   makeGridCell("СW4", 91, 20),
                // ]
              ),
            )
          : Center(
              child: Platform.isAndroid
                  ? CircularProgressIndicator()
                  : CupertinoActivityIndicator()),
    );
  }
}
