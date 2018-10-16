import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_provider.dart';
import 'package:student_system_flutter/bloc/home_page/home_page_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/deadlines_model.dart';
// import 'package:student_system_flutter/helpers/feedback_form.dart';
// import 'package:student_system_flutter/models/feedback_model.dart';
import 'package:student_system_flutter/pages/home_page.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  TwoPanels({this.controller});

  @override
  _TwoPanelsState createState() => _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> {
  @override
  initState() {
    super.initState();
  }

  static const header_height = 32.0;

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return RelativeRectTween(
            begin: RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(
            CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    // final List<FeedbackModel> _questionNumbers = <FeedbackModel>[
    //   FeedbackModel(questionTitle: 'Web Application Development'),
    //   FeedbackModel(questionTitle: 'Internet Marketing'),
    //   FeedbackModel(questionTitle: 'Software Quality, Performance and Testing'),
    // ];

    final List<DeadlinesModel> deadlinesList = <DeadlinesModel>[
      DeadlinesModel(date: '7', month: 'Nov', moduleName: 'QM'),
      DeadlinesModel(date: '15', month: 'Nov', moduleName: 'EAP'),
      DeadlinesModel(date: '23', month: 'Nov', moduleName: 'PD'),
      DeadlinesModel(date: '15', month: 'Dec', moduleName: 'WWW'),
      DeadlinesModel(date: '18', month: 'Dec', moduleName: 'CoB'),
      DeadlinesModel(date: '20', month: 'Dec', moduleName: 'IL'),
    ];
    var deadlineTextStyle = TextStyle(color: Colors.white);

    var _bloc = BackdropProvider.of(context);
    var homePageBloc = HomePageBloc();

    var size = MediaQuery.of(context).size;
    bool isSmallScreen = false;

    if (size.width <= smallDeviceWidth) {
      isSmallScreen = true;
    }

    return SafeArea(
      bottom: false,
      child: Container(
          child: Stack(children: <Widget>[
        SafeArea(
          child: Container(
            color: Platform.isIOS ? backgroundColor : accentColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomBackdropMenuItems(
                  itemName: 'Home',
                  icon: Platform.isAndroid ? 0xe88a : 0xF447,
                  iconFont: Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                  controller: widget.controller,
                  selected: true,
                ),
                CustomBackdropMenuItems(
                  itemName: 'Support',
                  icon: Platform.isAndroid ? 0xe0c9 : 0xF3FB,
                  iconFont: Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                  controller: widget.controller,
                  selected: false,
                ),
                CustomBackdropMenuItems(
                  itemName: 'Contacts',
                  icon: Platform.isAndroid ? 0xe0b0 : 0xF4B8,
                  iconFont: Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                  controller: widget.controller,
                  selected: false,
                ),
                CustomBackdropMenuItems(
                  itemName: 'Settings',
                  icon: Platform.isAndroid ? 0xe8b8 : 0xF411,
                  iconFont: Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                  controller: widget.controller,
                  selected: false,
                ),
              ],
            ),
          ),
        ),
        PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              color: backgroundColor,
              elevation: 12.0,
              borderRadius: Platform.isIOS
                  ? BorderRadius.all(Radius.circular(0.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0)),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      // onVerticalDragUpdate: onVerticalDragUpdate,
                      // onVerticalDragEnd: onVerticalDragEnd,
                      onTap: () {
                        widget.controller.fling(
                            velocity: _bloc.isBackdropPanelHidden ? -2.0 : 2.0);

                        _bloc.setBackdropPanelHidden
                            .add(!_bloc.isBackdropPanelHidden);
                      },
                      child: new Container(
                          padding: EdgeInsets.only(top: 5.0),
                          width: double.infinity,
                          child: StreamBuilder<bool>(
                            stream: _bloc.backdropPanelHidden,
                            initialData: true,
                            builder: (context, snapshot) => RotatedBox(
                                  child: Icon(CupertinoIcons.left_chevron),
                                  quarterTurns: snapshot.data ? 3 : 1,
                                ),
                          )),
                    ),
                  ),
                  // SliverToBoxAdapter(
                  //     child: SafeArea(
                  //   bottom: false,
                  //   child: FeedbackForm(questionNumbers: _questionNumbers),
                  // )),
                  StreamBuilder(
                    initialData: true,
                    stream: homePageBloc.isUnderDevelopmentFeaturesOn,
                    builder: (context, snapshot) => snapshot.data == false
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 22.0,
                                  bottom: 5.0, /* left: 24.0 */
                                ),
                                child: Text(
                                  'Deadline dates'.toUpperCase(),
                                  style: TextStyle(
                                    color: Platform.isAndroid
                                        ? lightGreyTextColor
                                        : lightGreyTextColor,
                                    fontSize: 11.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(),
                  ),
                  StreamBuilder(
                    initialData: true,
                    stream: homePageBloc.isUnderDevelopmentFeaturesOn,
                    builder: (context, snapshot) => snapshot.data == false
                        ? SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: SizedBox(
                                height: 100.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: deadlinesList.length,
                                  itemBuilder: (context, index) => index == 0
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.0,
                                              top: 7.0,
                                              right: 10.0),
                                          child: Column(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: redColor,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      deadlinesList[index].date,
                                                      style: deadlineTextStyle
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 26.0),
                                                    ),
                                                    Text(
                                                      deadlinesList[index]
                                                          .month
                                                          .toUpperCase(),
                                                      style: deadlineTextStyle
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // ClipRRect(
                                              //   borderRadius: BorderRadius.all(
                                              //       Radius.circular(200.0)),
                                              //   child: Container(
                                              //     padding: EdgeInsets.symmetric(
                                              //         horizontal: 16.0, vertical: 5.0),
                                              //     color: redColor,
                                              //     child: Column(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.center,
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.center,
                                              //       mainAxisSize: MainAxisSize.min,
                                              //       children: <Widget>[
                                              //         Text(
                                              //           deadlinesList[index].date,
                                              //           style: deadlineTextStyle.copyWith(
                                              //               fontSize: 26.0),
                                              //         ),
                                              //         Text(
                                              //           deadlinesList[index]
                                              //               .month
                                              //               .toUpperCase(),
                                              //           style: deadlineTextStyle.copyWith(
                                              //               fontSize: 10.0),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                deadlinesList[index]
                                                    .moduleName
                                                    .toUpperCase(),
                                                style:
                                                    deadlineTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: redColor,
                                                        fontSize: 15.0),
                                              )
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 7.0),
                                          child: Column(
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      deadlinesList[index].date,
                                                      style: deadlineTextStyle
                                                          .copyWith(
                                                              color:
                                                                  lightGreyTextColor,
                                                              fontSize: 26.0),
                                                    ),
                                                    Text(
                                                      deadlinesList[index]
                                                          .month
                                                          .toUpperCase(),
                                                      style: deadlineTextStyle
                                                          .copyWith(
                                                              color:
                                                                  lightGreyTextColor,
                                                              fontSize: 10.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // FloatingActionButton(
                                              //     backgroundColor: Colors.white,
                                              //     onPressed: () {},
                                              //     child: Column(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.center,
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.center,
                                              //       mainAxisSize: MainAxisSize.min,
                                              //       children: <Widget>[
                                              //         Text(
                                              //           deadlinesList[index].date,
                                              //           style: deadlineTextStyle.copyWith(
                                              //               color: lightGreyTextColor,
                                              //               fontSize: 26.0),
                                              //         ),
                                              //         Text(
                                              //           deadlinesList[index]
                                              //               .month
                                              //               .toUpperCase(),
                                              //           style: deadlineTextStyle.copyWith(
                                              //               color: lightGreyTextColor,
                                              //               fontSize: 10.0),
                                              //         )
                                              //       ],
                                              //     ),
                                              //     shape: CircleBorder(
                                              //         side: BorderSide(color: redColor))),
                                              // // ClipRRect(
                                              //   borderRadius: BorderRadius.all(
                                              //       Radius.circular(200.0)),
                                              //   child: Container(
                                              //     padding: EdgeInsets.symmetric(
                                              //         horizontal: 16.0, vertical: 5.0),
                                              //     color: redColor.withAlpha(150),
                                              //     // radius: 30.0,
                                              //     child: Column(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.center,
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.center,
                                              //       mainAxisSize: MainAxisSize.min,
                                              //       children: <Widget>[
                                              //         Text(
                                              //           deadlinesList[index].date,
                                              //           style: deadlineTextStyle.copyWith(
                                              //               color: lightGreyTextColor,
                                              //               fontSize: 26.0),
                                              //         ),
                                              //         Text(
                                              //           deadlinesList[index]
                                              //               .month
                                              //               .toUpperCase(),
                                              //           style: deadlineTextStyle.copyWith(
                                              //               color: lightGreyTextColor,
                                              //               fontSize: 10.0),
                                              //         )
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                deadlinesList[index]
                                                    .moduleName
                                                    .toUpperCase(),
                                                style:
                                                    deadlineTextStyle.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            lightGreyTextColor,
                                                        fontSize: 15.0),
                                              )
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(),
                  ),
                  // SliverToBoxAdapter(
                  //     child: SafeArea(
                  //   bottom: false,
                  //   child: FeedbackForm(questionNumbers: _questionNumbers),
                  // )),
                  StreamBuilder(
                      stream: homePageBloc.userRoleStream,
                      builder: (context, snapshot) => snapshot.hasData
                          ? snapshot.data == "staff"
                              ? CustomGridViewForTeachers(context).build()
                              : CustomGridView(context).build()
                          : SliverToBoxAdapter()),

                  StreamBuilder(
                    stream: homePageBloc.isUnderDevelopmentFeaturesOn,
                    initialData: true,
                    builder: (context, snapshot) => snapshot.data == false
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 22.0,
                                  bottom: 5.0, /*left: 22.0 */
                                ),
                                child: Text(
                                  'Under development'.toUpperCase(),
                                  style: TextStyle(
                                    color: Platform.isAndroid
                                        ? lightGreyTextColor
                                        : lightGreyTextColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(),
                  ),
                  StreamBuilder(
                      initialData: true,
                      stream: homePageBloc.isUnderDevelopmentFeaturesOn,
                      builder: (context, snapshot) => snapshot.data == false
                          ? CustomGridView2(context).build()
                          : SliverToBoxAdapter()),
                  SliverToBoxAdapter(
                    child: ListTile(
                        title: Text(
                          'Hide under development features',
                          style:
                              TextStyle(fontSize: isSmallScreen ? 13.0 : 15.0),
                        ),
                        trailing:
                            //  StreamBuilder(
                            //     initialData: false,
                            //     builder: (context, snapshot) =>
                            StreamBuilder(
                          initialData: true,
                          stream: homePageBloc.isUnderDevelopmentFeaturesOn,
                          builder: (context, snapshot) => Switch(
                              // value:   snapshot.hasData ? snapshot.data : false,
                              value: snapshot.hasData ? snapshot.data : true,
                              onChanged: (val) => homePageBloc
                                  .setUnderDevelopmentFeaturesVisibility
                                  .add(val)),
                        )
                        // ),
                        ),
                    //           )
                    // //         ],
                    //       ),
                  )
                ],
              ),
            ))
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }
}

class CustomBackdropMenuItems extends StatelessWidget {
  final String itemName;
  final int icon;
  final String iconFont;
  final controller;
  final selected;

  CustomBackdropMenuItems(
      {Key key,
      @required this.itemName,
      @required this.icon,
      @required this.iconFont,
      this.controller,
      @required this.selected})
      : super(key: key);

  void openSelectedBackdropItem(BuildContext context, itemName) {
    var _bloc = BackdropProvider.of(context);
    switch (itemName) {
      case 'Home':
        controller.fling(velocity: 1.0);
        _bloc.setBackdropPanelHidden.add(true);
        break;
      case 'NOTIFICATIONS':
        controller.fling(velocity: 1.0);
        _bloc.setBackdropPanelHidden.add(true);

        Navigator.of(context).pushNamed(offencesPage);
        break;
      case 'Support':
        controller.fling(velocity: 1.0);
        _bloc.setBackdropPanelHidden.add(true);

        Navigator.of(context).pushNamed(supportPage);
        break;
      case 'Contacts':
        controller.fling(velocity: 1.0);
        _bloc.setBackdropPanelHidden.add(true);

        Platform.isAndroid
            ? Navigator.of(context).pushNamed(contactsPage)
            : Navigator.of(context).pushNamed(iosContactsPage);
        break;
      case 'Settings':
        controller.fling(velocity: 1.0);
        _bloc.setBackdropPanelHidden.add(true);

        Navigator.of(context).pushNamed(settingsPage);
        break;

      default:
        print('Nothing');
    }
  }

  @override
  Widget build(BuildContext context) {
    var osSpecificColor;

    if (selected)
      osSpecificColor = Platform.isIOS ? Colors.black : Colors.white;
    else
      osSpecificColor = Platform.isIOS ? blackColor : whiteColor;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.white.withOpacity(0.25),
          // borderRadius: BorderRadius.all(Radius.circular(80.0)),
          onTap: () {
            openSelectedBackdropItem(context, itemName);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
              color: selected
                  ? Colors.white.withOpacity(0.20)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: Platform.isAndroid ? 16.0 : 30.0),
                Icon(
                  IconData(icon, fontFamily: iconFont),
                  size: 24.0,
                  color: osSpecificColor,
                ),
                SizedBox(width: 30.0),
                Text(
                  itemName,
                  style: TextStyle(color: osSpecificColor, fontSize: 17.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
