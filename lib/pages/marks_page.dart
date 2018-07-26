import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../models/modules_list_model.dart';

class MarksPage extends StatelessWidget {
  final Module module;

  MarksPage({this.module});

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(module != null ? module.moduleNameField : ''),
      ),
      // body: CustomGridView(context).build(),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: <Widget>[
            CustomGridView(context).build(),
            Expanded(
              child: Container(
                color: whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AnimatedCircularChart(
                          duration: Duration(seconds: 1),
                          key: _chartKey,
                          size: const Size(250.0, 250.0),
                          initialChartData: <CircularStackEntry>[
                            new CircularStackEntry(
                              <CircularSegmentEntry>[
                                new CircularSegmentEntry(
                                  double.parse(module.moduleMarkField),
                                  Colors.blue[400],
                                  rankKey: 'completed',
                                  // rankKey: 'progress',
                                ),
                                new CircularSegmentEntry(
                                  100 - double.parse(module.moduleMarkField),
                                  Colors.red[400],
                                  rankKey: 'remaining',
                                  // rankKey: 'progress',
                                ),
                              ],
                              rankKey: 'progress',
                            ),
                          ],
                          chartType: CircularChartType.Radial,
                          percentageValues: true,
                          holeLabel: '${module.moduleMarkField}%',
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .display1
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: accentColor),
                        ),
                        CustomAnimatedText()
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
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

  CustomGridView(this.context);

  Widget makeGridCell(String componentName, int mark, int weight) {
    TextStyle _componentNameTextStyle =
        Theme.of(context).textTheme.headline.copyWith(color: whiteColor);

    TextStyle _greyTextStyle = Theme
        .of(context)
        .textTheme
        .headline
        .copyWith(color: Theme.of(context).textSelectionColor, fontSize: 17.0);
    TextStyle _accentTextStyle = Theme
        .of(context)
        .textTheme
        .headline
        .copyWith(color: Theme.of(context).accentColor, fontSize: 17.0);

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
                      Text(
                        '$mark%',
                        style: _accentTextStyle,
                      )
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

  GridView build() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 0.94;
    return GridView.count(
        // primary: true,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight), //1.38
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        controller: ScrollController(keepScrollOffset: false),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          makeGridCell("СW1", 87, 20),
          makeGridCell("СW2", 55, 30),
          makeGridCell("СW3", 71, 30),
          makeGridCell("СW4", 91, 20),
        ]);
  }
}
