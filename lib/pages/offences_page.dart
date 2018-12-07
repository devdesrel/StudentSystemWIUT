import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/offences_page/offences_bloc.dart';
import 'package:student_system_flutter/models/offences/acad_offences_model.dart';
import 'package:student_system_flutter/models/offences/atten_offences_model.dart';
import 'package:student_system_flutter/models/offences/discip_offences_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_offences.dart';

// int _totalOffences = 7;

class OffencesPage extends StatefulWidget {
  @override
  _OffencesPageState createState() => _OffencesPageState();
}

class _OffencesPageState extends State<OffencesPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = OffencesBloc();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Platform.isAndroid
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  elevation: 3.0,
                  centerTitle: true,
                  title: Text('Offences'),
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        child: Text('Academic'),
                      ),
                      Tab(
                        child: Text('Attendance'),
                      ),
                      Tab(
                        child: Text('Disciplinary'),
                      ),
                    ],
                  ),
                ),
                body: TabBarView(children: <Widget>[
                  AcademicOffencesBody(
                      bloc: bloc,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  AttendanceOffencesBody(
                      bloc: bloc,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                  DisciplinaryOffencesBody(
                      bloc: bloc,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                ])),
          )
        : WillPopScope(
            onWillPop: () => Future<bool>.value(true),
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text("Offences"),
                automaticallyImplyLeading: true,
                backgroundColor: backgroundColor,
              ),
              child: CupertinoTabScaffold(
                tabBar: CupertinoTabBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.book, size: 20.0),
                      title: Text('Academic'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.calendarAlt, size: 20.0),
                      title: Text('Attendance'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.peopleCarry, size: 20.0),
                      title: Text('Disciplinary'),
                    ),
                  ],
                ),
                tabBuilder: (BuildContext context, int index) {
                  assert(index >= 0 && index <= 2);
                  switch (index) {
                    case 0:
                      return Material(
                        child: CupertinoTabView(
                          builder: (BuildContext context) {
                            return AcademicOffencesBody(
                                bloc: bloc,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight);
                          },
                        ),
                      );
                      break;
                    case 1:
                      return CupertinoTabView(builder: (BuildContext context) {
                        return Material(
                          child: AttendanceOffencesBody(
                              bloc: bloc,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight),
                        );
                      });
                      break;
                    case 2:
                      return CupertinoTabView(builder: (BuildContext context) {
                        return Material(
                          child: DisciplinaryOffencesBody(
                              bloc: bloc,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight),
                        );
                      });
                      break;
                  }
                  return null;
                },
              ),
            ),
          );
  }
}

class DisciplinaryOffencesBody extends StatelessWidget {
  const DisciplinaryOffencesBody({
    Key key,
    @required this.bloc,
    @required this.screenWidth,
    @required this.screenHeight,
  }) : super(key: key);

  final OffencesBloc bloc;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: SizedBox(height: 5.0)),
        StreamBuilder<List<DisciplinaryOffencesModel>>(
          stream: bloc.disciplinaryOffencesList,
          initialData: [],
          builder: (context, snapshot) => (snapshot.hasData) &
                  (snapshot.data.length > 0)
              ? SliverToBoxAdapter(
                  child: Container(
                    width: screenWidth - 30.0,
                    height: screenHeight - screenHeight / 4.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[i].offencesNature,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(color: accentColor),
                                  ),
                                  SizedBox(height: 15.0),
                                  OffenceCustomRow(
                                      isPoint: false,
                                      name: "Offence:",
                                      value: snapshot.data[i].offenceComment),
                                  SizedBox(height: 10.0),
                                  OffenceCustomRow(
                                      isPoint: false,
                                      name: 'Outcome:',
                                      value: snapshot.data[i].outcome),
                                  SizedBox(height: 10.0),
                                  OffenceCustomRow(
                                      isPoint: true,
                                      name: 'Points given:',
                                      value: snapshot.data[i].points),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              : NoOffenceMessage(),
        ),
      ],
    );
  }
}

class NoOffenceMessage extends StatelessWidget {
  const NoOffenceMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
          width: 200.0,
          height: 40.0,
          padding: EdgeInsets.all(10.0),
          color: greenColor,
          child: Text(
            "No Offences to show",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class AttendanceOffencesBody extends StatelessWidget {
  const AttendanceOffencesBody({
    Key key,
    @required this.bloc,
    @required this.screenWidth,
    @required this.screenHeight,
  }) : super(key: key);

  final OffencesBloc bloc;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: SizedBox(height: 5.0)),
        StreamBuilder<List<AttendanceOffencesModel>>(
          stream: bloc.attendanceOffencesList,
          initialData: [],
          builder: (context, snapshot) => (snapshot.hasData) &
                  (snapshot.data.length > 0)
              ? SliverToBoxAdapter(
                  child: Container(
                    width: screenWidth - 30.0,
                    height: screenHeight - screenHeight / 4.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[i].moduleNameField,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(color: accentColor),
                                  ),
                                  SizedBox(height: 15.0),
                                  OffenceCustomRow(
                                      isPoint: false,
                                      name: "Offence:",
                                      value:
                                          snapshot.data[i].offenceCommentField),
                                  SizedBox(height: 10.0),
                                  OffenceCustomRow(
                                      isPoint: false,
                                      name: 'Outcome:',
                                      value: snapshot.data[i].outcomeField),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              : NoOffenceMessage(),
        ),
      ],
    );
  }
}

class AcademicOffencesBody extends StatelessWidget {
  const AcademicOffencesBody({
    Key key,
    @required this.bloc,
    @required this.screenWidth,
    @required this.screenHeight,
  }) : super(key: key);

  final OffencesBloc bloc;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(child: SizedBox(height: 5.0)),
        StreamBuilder<List<AcademicOffencesModel>>(
          stream: bloc.academOffencesList,
          initialData: [],
          builder: (context, snapshot) => (snapshot.hasData) &
                  (snapshot.data.length > 0)
              ? SliverToBoxAdapter(
                  child: Container(
                    width: screenWidth - 30.0,
                    height: screenHeight - screenHeight / 4.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) => Card(
                            elevation: 2.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data[i].moduleName,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .copyWith(color: accentColor),
                                  ),
                                  SizedBox(height: 15.0),
                                  OffenceCustomRow(
                                      isPoint: false,
                                      name: "Outcome:",
                                      value: snapshot.data[i].outcome),
                                  SizedBox(height: 10.0),
                                  OffenceCustomRow(
                                      isPoint: true,
                                      name: 'Points given:',
                                      value: snapshot.data[i].pointsGiven),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                )
              : NoOffenceMessage(),
        ),
      ],
    );
  }
}

// class OffenceHeaderMessage extends StatelessWidget {
//   const OffenceHeaderMessage({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: SafeArea(
//         bottom: false,
//         child: Container(
//           width: 100.0,
//           padding: const EdgeInsets.symmetric(vertical: 7.0),
//           color: redColor,
//           child: Column(
//             children: <Widget>[
//               Text(
//                 _totalOffences.toString().toUpperCase(),
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context)
//                     .textTheme
//                     .display2
//                     .copyWith(color: whiteColor),
//               ),
//               Text(
//                 'Total points'.toUpperCase(),
//                 style: Theme.of(context)
//                     .textTheme
//                     .body2
//                     .copyWith(color: whiteColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class OffenceBody extends StatelessWidget {
//   final OffencesType requestType;
//   final OffencesBloc bloc;
//   const OffenceBody({
//     @required this.requestType,
//     @required this.bloc,
//     Key key,
//   }) : super(key: key);

//   // offencesList(OffencesType requestType) {
//   //   switch (requestType) {
//   //     case OffencesType.Academic:
//   //       parseAcademOffences();
//   //       break;
//   //     case OffencesType.Attendance:
//   //       parseAttenOffences();
//   //       break;
//   //     case OffencesType.Disciplinary:
//   //       parseDiscipOffences();
//   //       break;
//   //     default:
//   //       parseAcademOffences();
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) => Card(),

//         // ItemOffences(
//         //       requestType: requestType,
//         //       offencesList: offencesList(requestType),
//         //     ),
//         // FutureBuilder<List<AcademicOffencesModel>>(
//         //     // initialData: Container(),
//         //     future: parseAcademOffences(),
//         //     builder: (context, snapshot) => snapshot.hasData
//         //         ? Padding(
//         //             padding: const EdgeInsets.symmetric(
//         //                 horizontal: 8.0, vertical: 2.0),
//         //             child: ListView.builder(
//         //               itemCount: snapshot.data.length,
//         //               itemBuilder: (context, i) => Card(
//         //                   //Custom card will be added
//         //                   elevation: 2.0,
//         //                   child: Padding(
//         //                     padding: const EdgeInsets.all(16.0),
//         //                     child: Column(
//         //                       mainAxisSize: MainAxisSize.min,
//         //                       children: <Widget>[
//         //                         Text(
//         //                           snapshot.data[i].moduleName,
//         //                           style: Theme.of(context)
//         //                               .textTheme
//         //                               .headline
//         //                               .copyWith(color: accentColor),
//         //                         ),
//         //                         SizedBox(height: 15.0),
//         //                         OffenceCustomRow(
//         //                             name: "Outcome",
//         //                             value: snapshot.data[i].outcome),
//         //                         SizedBox(height: 10.0),
//         //                         OffenceCustomRow(
//         //                             name: 'Points given',
//         //                             value: snapshot.data[i].pointsGiven),
//         //                         SizedBox(height: 10.0),
//         //                         // OffenceCustomRow(
//         //                         //     name: 'Offence date', value: snapshot.data[i].),
//         //                       ],
//         //                     ),
//         //                   )),
//         //             ),
//         //           )
//         //         : CustomCard(Text('No offences'))),
//       ),
//     );
//   }
// }
