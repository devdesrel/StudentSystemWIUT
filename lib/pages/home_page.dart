import 'package:flutter/material.dart';

import '../helpers/app_constants.dart';
import '../helpers/feedback_form.dart';
import '../helpers/function_helpers.dart';
import '../helpers/ui_helpers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = <Widget>[
    Text('Text'),
    Text('Text'),
    Text('Text'),
    Text('Text'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
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
        ),
        drawer: CustomAndroidDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: FeedbackForm(pages: _pages)),
            CustomGridView(context).build(),
          ],
        ));
  }
}

void openSelectedPage(BuildContext context, MainPageGridItems page) {
  switch (page) {
    case MainPageGridItems.MARKS:
      Navigator.of(context).pushNamed(modulesPage);
      break;
    case MainPageGridItems.TIMETABLE:
      print('Timetable');
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
      print('Payment');
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
    return new Padding(
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

enum MainPageGridItems {
  MARKS,
  TIMETABLE,
  LECTURES,
  TUTORIALS,
  OFFENCES,
  PAYMENT,
  BOOK_ORDERING,
  SOCIAL
}
