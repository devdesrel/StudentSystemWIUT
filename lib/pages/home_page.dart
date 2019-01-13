import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_bloc.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/backdrop_menu.dart';
import 'package:student_system_flutter/pages/modules_page.dart';
import 'package:student_system_flutter/pages/tips_tricks_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget _buildSignOutAction() {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        padding: EdgeInsets.only(top: 1.0),
        icon: Image.asset(
          Platform.isAndroid
              ? 'assets/exit_run.png'
              : 'assets/exit_run_black.png',
          height: 22.0,
        ),
        onPressed: () {
          showSignOutDialog(context);
        },
      ),
    );
  }

  Widget _buildMenuAction() {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: () {
          controller.fling(velocity: _bloc.isBackdropPanelHidden ? -1.0 : 1.0);

          _bloc.setBackdropPanelHidden.add(!_bloc.isBackdropPanelHidden);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: controller.view,
          color: Platform.isAndroid ? Colors.white : blackColor,
        ),
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
      color: Colors.transparent,
      child: CupertinoPageScaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        navigationBar: CupertinoNavigationBar(
            leading: _buildMenuAction(),
            middle: Text("WIUT"),
            trailing: _buildSignOutAction()),
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            TwoPanels(
              controller: controller,
            ),
            StreamBuilder(
                stream: _bloc.isDeadlineInfoVisible,
                initialData: false,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: blackColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Assignment Deadlines',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(
                                          color: redColor, fontSize: 28.0),
                                ),
                                SizedBox(height: 15.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'If your deadlines list is not full or empty, please approach your Module Leaders.',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(
                                            color: whiteColor, fontSize: 15.0),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                    : Container()),
            StreamBuilder(
                stream: _bloc.isDeadlineInfoVisible,
                initialData: false,
                builder: (context, snapshot) => snapshot.hasData
                    ? snapshot.data
                        ? Positioned(
                            right: 30.0,
                            bottom: 30.0,
                            child: RaisedButton(
                              child: Text(
                                'Got it'.toUpperCase(),
                                style: TextStyle(color: whiteColor),
                              ),
                              color: accentColor,
                              onPressed: () {
                                _bloc.setDeadlineInfoVisible.add(false);
                              },
                            ),
                          )
                        : Container()
                    : Container())
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (_bloc.isDeadlineInfoScreenVisible) {
      _bloc.setDeadlineInfoVisible.add(false);

      return false;
    } else {
      if (!_bloc.isBackdropPanelHidden) {
        controller.fling(velocity: _bloc.isBackdropPanelHidden ? -1.0 : 1.0);

        _bloc.setBackdropPanelHidden.add(!_bloc.isBackdropPanelHidden);
      }

      return _bloc.isBackdropPanelHidden;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? RepaintBoundary(
            child: BackdropProvider(
              bloc: _bloc,
              child: WillPopScope(
                onWillPop: _onBackPressed,
                child: Scaffold(
                    appBar: AppBar(
                        elevation: 0.0,
                        centerTitle: true,
                        title: Text('WIUT'),
                        actions: <Widget>[
                          _buildSignOutAction(),
                        ],
                        leading: _buildMenuAction()),
                    body: Stack(
                      fit: StackFit.loose,
                      children: <Widget>[
                        TwoPanels(
                          controller: controller,
                        ),
                        StreamBuilder(
                            stream: _bloc.isDeadlineInfoVisible,
                            initialData: false,
                            builder: (context, snapshot) => snapshot.hasData
                                ? snapshot.data
                                    ? Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: blackColor,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Assignment Deadlines',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display1
                                                  .copyWith(
                                                      color: redColor,
                                                      fontSize: 28.0),
                                            ),
                                            SizedBox(height: 15.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Text(
                                                'If your deadlines list is not full or empty, please approach your Module Leaders.',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .copyWith(
                                                        color: whiteColor,
                                                        fontSize: 15.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container()
                                : Container()),
                        StreamBuilder(
                            stream: _bloc.isDeadlineInfoVisible,
                            initialData: false,
                            builder: (context, snapshot) => snapshot.hasData
                                ? snapshot.data
                                    ? Positioned(
                                        right: 30.0,
                                        bottom: 30.0,
                                        child: RaisedButton(
                                          child: Text(
                                            'Got it'.toUpperCase(),
                                            style: TextStyle(color: whiteColor),
                                          ),
                                          color: accentColor,
                                          onPressed: () {
                                            _bloc.setDeadlineInfoVisible
                                                .add(false);
                                          },
                                        ),
                                      )
                                    : Container()
                                : Container())
                      ],
                    )),
              ),
            ),
          )
        : RepaintBoundary(
            child: BackdropProvider(bloc: _bloc, child: _getIOSWidgets()));
  }
}

Future _openGmailApp(BuildContext context) async {
  const platform =
      const MethodChannel('com.rtoshmukhamedov.flutter.outlookappopener');
  try {
    bool isInstalled = await platform.invokeMethod('openGmailApp');
    if (!isInstalled) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TipsAndTricksPage(type: TipsRequestType.Gmail)));
    }
  } catch (e) {
    print(e.toString());
  }
}

_openWebMail(BuildContext context) async {
  const outlookUrl = 'ms-outlook://';
  const gmailUrl = 'googlegmail://';
  const appleMailUrl = 'message://';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String webMailTypeEnum =
      prefs.getString(webMailTypePrefs) ?? WebMailType.Outlook.toString();

  if (webMailTypeEnum == WebMailType.Gmail.toString()) {
    if (Platform.isAndroid) {
      _openGmailApp(context);
    } else {
      if (await canLaunch(gmailUrl)) {
        await launch(gmailUrl);
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                TipsAndTricksPage(type: TipsRequestType.Gmail)));
      }
    }
  } else if (webMailTypeEnum == WebMailType.Outlook.toString()) {
    if (await canLaunch(outlookUrl)) {
      await launch(outlookUrl);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TipsAndTricksPage(type: TipsRequestType.Outlook)));
    }
  } else if (webMailTypeEnum == WebMailType.AppleMail.toString()) {
    if (await canLaunch(appleMailUrl)) {
      await launch(appleMailUrl);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              TipsAndTricksPage(type: TipsRequestType.AppleMail)));
    }
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
    case MainPageGridItems.WEBMAIL:
      _openWebMail(context);
      break;
    case MainPageGridItems.OFFENCES:
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => VideoApp()));
      Navigator.of(context).pushNamed(offencesPage);
      break;
    case MainPageGridItems.COURSEWORK_UPLOAD:
      Navigator.of(context).pushNamed(courseworkUploadPage);
      // Navigator.of(context).pushNamed(ccmRoleSelectPage);
      break;
    case MainPageGridItems.BOOK_ORDERING:
      Navigator.of(context).pushNamed(booksPage);
      break;
    // case MainPageGridItems.SOCIAL:
    //   Navigator.of(context).pushNamed(socialPage);
    //   break;
    case MainPageGridItems.CCMFEEDBACK:
      openCCMFeedbackPageByRole()
          .then((val) => Navigator.of(context).pushNamed(val));
      break;
    case MainPageGridItems.TIPSTRICKS:
      Navigator.of(context).pushNamed(tipsTricksListPage);
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

    if (size.width <= smallDeviceWidth) {
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      fontSize: isSmallScreen ? 11.0 : 15.0),
                )),
              ],
            ),
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
          makeGridCell(
              "Web Mail", 'assets/web_mail.png', MainPageGridItems.WEBMAIL, 3),
          makeGridCell("Tips & Tricks", 'assets/tips_tricks.png',
              MainPageGridItems.TIPSTRICKS, 4),
          makeGridCell("CCM Feedback", 'assets/ccmfeedback.png',
              MainPageGridItems.CCMFEEDBACK, 5),
          makeGridCell("Offences", 'assets/offences2.png',
              MainPageGridItems.OFFENCES, 6),
          // makeGridCell(
          //     "Social", 'assets/social.png', MainPageGridItems.SOCIAL, 7),
          // FutureBuilder<bool>(
          //   future: isCCMFeedbackApplicable(),
          //   builder: (context, snapshot) => snapshot.hasData
          //       ? snapshot.data
          //           ? makeGridCell("CCM Feedback", 'assets/ccmfeedback.png',
          //               MainPageGridItems.CCMFEEDBACK, 5)
          //           : Container()
          //       : DrawPlatformCircularIndicator(),
          // )
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

    if (size.width <= smallDeviceWidth) {
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                        fontSize: isSmallScreen ? 11.0 : 15.0),
                  )),
                ],
              ),
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
          makeGridCell("CW Upload", 'assets/cwupload.png',
              MainPageGridItems.COURSEWORK_UPLOAD, 1),
          makeGridCell(
              "Social", 'assets/social.png', MainPageGridItems.SOCIAL, 2),
        ]);
  }
}

class CustomGridViewForTeachers {
  BuildContext context;

  CustomGridViewForTeachers(this.context);

  Widget makeGridCell(
      String name, String imageSource, MainPageGridItems page, int position) {
    var size = MediaQuery.of(context).size;
    bool isSmallScreen = false;

    if (size.width <= smallDeviceWidth) {
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      fontSize: isSmallScreen ? 11.0 : 15.0),
                )),
              ],
            ),
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
          makeGridCell("Timetable", 'assets/timetable.png',
              MainPageGridItems.TIMETABLE, 0),
          makeGridCell("Learning Materials", 'assets/lectures.png',
              MainPageGridItems.LEARNING_MATERIALS, 1),
          makeGridCell(
              "Web Mail", 'assets/web_mail.png', MainPageGridItems.WEBMAIL, 2),
          makeGridCell("Tips & Tricks", 'assets/tips_tricks.png',
              MainPageGridItems.TIPSTRICKS, 3),
          makeGridCell("CCM Feedback", 'assets/ccmfeedback.png',
              MainPageGridItems.CCMFEEDBACK, 4),
          makeGridCell("Offences", 'assets/offences2.png',
              MainPageGridItems.OFFENCES, 5),
          // FutureBuilder<bool>(
          //   future: isCCMFeedbackApplicable(),
          //   builder: (context, snapshot) => snapshot.hasData
          //       ? snapshot.data
          //           ? makeGridCell("CCM Feedback", 'assets/ccmfeedback.png',
          //               MainPageGridItems.CCMFEEDBACK, 4)
          //           : Container()
          //       : DrawPlatformCircularIndicator(),
          // )
        ]);
  }
}
