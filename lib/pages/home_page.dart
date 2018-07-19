import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/models/feedback_model.dart';

import '../helpers/app_constants.dart';
import '../helpers/feedback_form.dart';
import '../helpers/function_helpers.dart';
import '../helpers/ui_helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 100), value: 1.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('WIUT'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.lock_open),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                showSignOutDialog(context);
              },
            ),
          ],
          leading: IconButton(
            onPressed: () {
              controller.fling(velocity: isPanelVisible ? -1.0 : 1.0);
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: controller.view,
            ),
          ),
        ),
        body: TwoPanels(controller: controller));
  }
}

void openSelectedPage(BuildContext context, MainPageGridItems page) {
  switch (page) {
    case MainPageGridItems.MARKS:
      Navigator.of(context).pushNamed(modulesPage);
      break;
    case MainPageGridItems.TIMETABLE:
      Navigator.of(context).pushNamed(timetablePage);
      break;
    case MainPageGridItems.LECTURES:
      Navigator.of(context).pushNamed(lecturesPage);
      break;
    case MainPageGridItems.TUTORIALS:
      print('Tutorials');
      break;
    case MainPageGridItems.OFFENCES:
      Navigator.of(context).pushNamed(offencesPage);
      break;
    case MainPageGridItems.PAYMENT:
      Navigator.of(context).pushNamed(courseworkUploadPage);
      //print('Payment');
      break;
    case MainPageGridItems.BOOK_ORDERING:
      print('Book Ordering');
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
                    letterSpacing: 4.0, color: textColor, fontSize: 16.0),
              )),
            ],
          ),
        ),
      ),
    );
  }

  SliverGrid build() {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.55;

    return SliverGrid.count(
        // padding: EdgeInsets.all(16.0),
        // shrinkWrap: true,
        childAspectRatio: (itemWidth / itemHeight), //0.85
        // scrollDirection: Axis.vertical,
        // controller: ScrollController(keepScrollOffset: false),
        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          makeGridCell("Marks", 'assets/marks.png', MainPageGridItems.MARKS, 0),
          makeGridCell("Timetable", 'assets/timetable.png',
              MainPageGridItems.TIMETABLE, 1),
          makeGridCell(
              "Lectures", 'assets/lectures.png', MainPageGridItems.LECTURES, 2),
          makeGridCell("Tutorials", 'assets/tutorials.png',
              MainPageGridItems.TUTORIALS, 3),
          makeGridCell(
              "Offences", 'assets/offences.png', MainPageGridItems.OFFENCES, 4),
          makeGridCell(
              "Payment", 'assets/payment.png', MainPageGridItems.PAYMENT, 5),
          makeGridCell("Book ordering", 'assets/bookordering.png',
              MainPageGridItems.BOOK_ORDERING, 6),
          makeGridCell(
              "Social", 'assets/tutorials2.png', MainPageGridItems.SOCIAL, 7),
        ]);
  }
}

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  TwoPanels({this.controller});

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
                  CustomBackdropMenuItems(itemName: 'Home'),
                  CustomBackdropMenuItems(itemName: 'Notifications'),
                  CustomBackdropMenuItems(itemName: 'Support'),
                  CustomBackdropMenuItems(itemName: 'Contacts'),
                  CustomBackdropMenuItems(itemName: 'Settings'),
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
  CustomBackdropMenuItems({Key key, @required this.itemName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: redColor,
      splashColor: whiteColor,
      onTap: () => print('thsdcdsnxc'),
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
