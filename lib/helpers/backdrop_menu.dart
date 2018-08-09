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
    final ThemeData theme = Theme.of(context);

    final List<FeedbackModel> _questionNumbers = <FeedbackModel>[
      FeedbackModel(questionTitle: 'Web Application Development'),
      FeedbackModel(questionTitle: 'Internet Marketing'),
      FeedbackModel(questionTitle: 'Software Quality, Performance and Testing'),
    ];

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: theme.primaryColor,
            child: Center(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  CustomBackdropMenuItems(
                    itemName: 'HOME',
                    controller: widget.controller,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'SUPPORT',
                    controller: widget.controller,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'CONTACTS',
                    controller: widget.controller,
                  ),
                  CustomBackdropMenuItems(
                    itemName: 'SETTINGS',
                    controller: widget.controller,
                  ),
                ],
              ),
            ),
          ),
          PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: Material(
              elevation: 12.0,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 0.0,
                  ),
                  Expanded(
                      child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                          child:
                              FeedbackForm(questionNumbers: _questionNumbers)),
                      CustomGridView(context).build(),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
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
  final controller;

  CustomBackdropMenuItems({
    Key key,
    @required this.itemName,
    this.controller,
  }) : super(key: key);

  void openSelectedBackdropItem(BuildContext context, itemName) {
    switch (itemName) {
      case 'HOME':
        controller.fling(velocity: 1.0);
        break;
      case 'NOTIFICATIONS':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(offencesPage);
        break;
      case 'SUPPORT':
        controller.fling(velocity: 1.0);
        // Navigator.of(context).pushNamed(offencesPage);
        break;
      case 'CONTACTS':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(contactsPage);
        break;
      case 'SETTINGS':
        controller.fling(velocity: 1.0);
        Navigator.of(context).pushNamed(settingsPage);
        break;

      default:
        print('Nothing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: redColor,
      splashColor: whiteColor,
      onTap: () {
        openSelectedBackdropItem(context, itemName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          itemName.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'SlaboRegular',
              letterSpacing: 2.8,
              color: Colors.white),
        ),
      ),
    );
  }
}
