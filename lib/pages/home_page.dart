import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_bloc.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/backdrop_menu.dart';
import 'package:student_system_flutter/pages/modules_page.dart';

import '../helpers/app_constants.dart';
import '../helpers/function_helpers.dart';
import '../helpers/ui_helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  var _bloc = BackdropBloc();

  @override
  void initState() {
    super.initState();

    getMinimumAppVersion(context);

    getStudentsProfileForSelectedYear();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Widget _buildSignOutAction() {
    return IconButton(
      padding: EdgeInsets.only(top: 1.0),
      icon: Image.asset(
        'assets/exit_run.png',
        height: 22.0,
      ),
      onPressed: () {
        showSignOutDialog(context);
      },
    );
  }

  Widget _buildMenuAction() {
    return IconButton(
      onPressed: () {
        controller.fling(velocity: _bloc.isBackdropPanelHidden ? -1.0 : 1.0);

        _bloc.setBackdropPanelHidden.add(!_bloc.isBackdropPanelHidden);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.close_menu,
        progress: controller.view,
        color: Platform.isAndroid ? Colors.white : blackColor,
      ),
    );
  }

  // bool get isPanelVisible {
  //   final AnimationStatus status = controller.status;
  //   return status == AnimationStatus.completed ||
  //       status == AnimationStatus.forward;
  // }

  Widget _getIOSWidgets() {
    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        navigationBar: CupertinoNavigationBar(
            leading: _buildMenuAction(),
            middle: Text("WIUT"),
            trailing: _buildSignOutAction()),
        child: TwoPanels(
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? RepaintBoundary(
            child: BackdropProvider(
              bloc: _bloc,
              child: Scaffold(
                  appBar: AppBar(
                      elevation: 0.0,
                      centerTitle: true,
                      title: Text('WIUT'),
                      actions: <Widget>[
                        _buildSignOutAction(),
                      ],
                      leading: _buildMenuAction()),
                  body: TwoPanels(
                    controller: controller,
                  )),
            ),
          )
        : RepaintBoundary(
            child: BackdropProvider(bloc: _bloc, child: _getIOSWidgets()));
  }
}

void openSelectedPage(BuildContext context, MainPageGridItems page) {
  switch (page) {
    case MainPageGridItems.MARKS:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ModulesPage(requestType: RequestType.GetMarks)));
      break;
    case MainPageGridItems.TIMETABLE:
      Navigator.of(context).pushNamed(timetablePage);
      break;
    case MainPageGridItems.LEARNING_MATERIALS:
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ModulesPage(requestType: RequestType.GetTeachingMaterials)));
      break;
    case MainPageGridItems.OFFENCES:
      Navigator.of(context).pushNamed(offencesPage);
      break;
    case MainPageGridItems.COURSEWORK_UPLOAD:
      Navigator.of(context).pushNamed(courseworkUploadPage);
      break;
    case MainPageGridItems.BOOK_ORDERING:
      Navigator.of(context).pushNamed(booksPage);
      break;
    case MainPageGridItems.SOCIAL:
      Navigator.of(context).pushNamed(socialPage);
      break;
    default:
      print('Nothing');
  }
}

class CustomGridView {
  BuildContext context;

  CustomGridView(this.context);

  Widget makeGridCell(
      String name, String imageSource, MainPageGridItems page, int position) {
    var size = MediaQuery.of(context).size;
    bool isSmallScreen = false;

    if (size.height < smallDeviceHeight) {
      isSmallScreen = true;
    }

    return Padding(
      padding: position.isEven
          ? EdgeInsets.only(left: 18.0, bottom: 10.0)
          : EdgeInsets.only(right: 18.0, bottom: 10.0),
      child: CustomCard(
        InkWell(
          onTap: () {
            openSelectedPage(context, page);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Center(
                  child: Image.asset(
                imageSource,
                height: 60.0,
              )),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                name.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.body1.copyWith(
                    letterSpacing: 4.0,
                    color: textColor,
                    fontSize: isSmallScreen ? 12.0 : 15.0),
              )),
            ],
          ),
        ),
      ),
    );
  }

  SliverGrid build() {
    // var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2.5;
    // final double itemWidth = size.width / 1.55;

    return SliverGrid.count(
        // padding: EdgeInsets.all(16.0),
        // shrinkWrap: true,
        childAspectRatio: 0.9, //0.85
        // scrollDirection: Axis.vertical,
        // controller: ScrollController(keepScrollOffset: false),
        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          // SliverToBoxAdapter(
          // SliverToBoxAdapter(
          //   child: SliverGrid.count(
          //     crossAxisCount: 2,
          //     children: <Widget>[
          makeGridCell("Marks", 'assets/marks.png', MainPageGridItems.MARKS, 0),
          makeGridCell("Timetable", 'assets/timetable.png',
              MainPageGridItems.TIMETABLE, 1),
          makeGridCell("Learning Materials", 'assets/lectures.png',
              MainPageGridItems.LEARNING_MATERIALS, 2),
          //     ],
          //   ),
          // ),
        ]);
  }
}

class CustomGridView2 {
  BuildContext context;

  CustomGridView2(this.context);

  Widget makeGridCell(
      String name, String imageSource, MainPageGridItems page, int position) {
    var size = MediaQuery.of(context).size;
    bool isSmallScreen = false;

    if (size.height < smallDeviceHeight) {
      isSmallScreen = true;
    }

    return Padding(
      padding: position.isEven
          ? EdgeInsets.only(left: 18.0, bottom: 10.0)
          : EdgeInsets.only(right: 18.0, bottom: 10.0),
      child: Opacity(
        opacity: 0.6,
        child: CustomCard(
          InkWell(
            onTap: () {
              openSelectedPage(context, page);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  imageSource,
                  height: 60.0,
                )),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: Text(
                  name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.body1.copyWith(
                      letterSpacing: 4.0,
                      color: textColor,
                      fontSize: isSmallScreen ? 12.0 : 15.0),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverGrid build() {
    return SliverGrid.count(
        childAspectRatio: 0.9, //0.85

        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          makeGridCell("Book ordering", 'assets/bookordering.png',
              MainPageGridItems.BOOK_ORDERING, 0),
          makeGridCell("Offences", 'assets/offences2.png',
              MainPageGridItems.OFFENCES, 1),
          makeGridCell("CW Upload", 'assets/cwupload.png',
              MainPageGridItems.COURSEWORK_UPLOAD, 2),
          makeGridCell(
              "Social", 'assets/social.png', MainPageGridItems.SOCIAL, 3),
        ]);
  }
}
