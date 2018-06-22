import 'package:flutter/material.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_offences.dart';

class LecturesPage extends StatelessWidget {
  List<String> _lectureNames = new List();
  // List<Widget> lecturecards = List.generate(5, (i) => CustomCard());
  @override
  Widget build(BuildContext context) {
    _lectureNames.add('Lecture 1');
    _lectureNames.add('Lecture 2');
    _lectureNames.add('Lecture 3');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: ('Lectures')),
              Tab(text: ('Downloading')),
              Tab(text: ('Downloaded')),
            ],
          ),
          title: Text('Lecture Materials'),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
                itemCount: _lectureNames.length,
                itemBuilder: (context, index) => index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CustomCard(lectureName: _lectureNames[index]),
                      )
                    : CustomCard(lectureName: _lectureNames[index])),
            //Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final lectureName;

  CustomCard({this.lectureName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(600.0),
        child: Card(
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                lectureName,
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline
                    .copyWith(color: lightGreyTextColor, fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
