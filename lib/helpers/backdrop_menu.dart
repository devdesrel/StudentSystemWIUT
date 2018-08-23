import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/feedback_form.dart';
import 'package:student_system_flutter/models/feedback_model.dart';
import 'package:student_system_flutter/pages/home_page.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;
  var isPanelVisible;

  TwoPanels({this.controller, this.isPanelVisible});

  @override
  _TwoPanelsState createState() => _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> {
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
    final List<FeedbackModel> _questionNumbers = <FeedbackModel>[
      FeedbackModel(questionTitle: 'Web Application Development'),
      FeedbackModel(questionTitle: 'Internet Marketing'),
      FeedbackModel(questionTitle: 'Software Quality, Performance and Testing'),
    ];

    return RepaintBoundary(
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: Platform.isIOS ? backgroundColor : accentColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomBackdropMenuItems(
                    itemName: 'Home',
                    icon: Platform.isAndroid ? 0xe88a : 0xF447,
                    iconFont:
                        Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                    controller: widget.controller,
                    selected: true,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'Support',
                    icon: Platform.isAndroid ? 0xe0c9 : 0xF3FB,
                    iconFont:
                        Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                    controller: widget.controller,
                    selected: false,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'Contacts',
                    icon: Platform.isAndroid ? 0xe0b0 : 0xF4B8,
                    iconFont:
                        Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                    controller: widget.controller,
                    selected: false,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'Settings',
                    icon: Platform.isAndroid ? 0xe8b8 : 0xF411,
                    iconFont:
                        Platform.isAndroid ? 'MaterialIcons' : 'CuperIcon',
                    controller: widget.controller,
                    selected: false,
                  ),
                ],
              ),
            ),
            PositionedTransition(
              rect: getPanelAnimation(constraints),
              child: Material(
                elevation: 12.0,
                borderRadius: Platform.isIOS
                    ? BorderRadius.all(Radius.circular(0.0))
                    : BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                child: Column(
                  children: <Widget>[
                    // new GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   // onVerticalDragUpdate: onVerticalDragUpdate,
                    //   // onVerticalDragEnd: onVerticalDragEnd,
                    //   onTap: () {
                    //     widget.controller
                    //         .fling(velocity: widget.isPanelVisible ? -2.0 : 2.0);
                    //   },
                    //   child: new Container(
                    //     height: 48.0,
                    //     padding: const EdgeInsetsDirectional.only(start: 16.0),
                    //     alignment: AlignmentDirectional.centerStart,
                    //     child: Container(),
                    //   ),
                    // ),
                    Container(),
                    Expanded(
                        child: RepaintBoundary(
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                              child: SafeArea(
                                  bottom: false,
                                  child: FeedbackForm(
                                      questionNumbers: _questionNumbers))),
                          CustomGridView(context).build(),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
    switch (itemName) {
      case 'Home':
        controller.fling(velocity: 1.0);
        break;
      case 'NOTIFICATIONS':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(offencesPage);
        break;
      case 'Support':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(supportPage);
        break;
      case 'Contacts':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(iosContactsPage);
        break;
      case 'Settings':
        controller.fling(velocity: 1.0);
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
                SizedBox(width: 16.0),
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
