import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../helpers/app_constants.dart';
import 'dart:async';

class LecturesPage extends StatefulWidget {
  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage>
    with SingleTickerProviderStateMixin {
  List<String> _lectureNames = new List();
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  // List<Widget> lecturecards = List.generate(5, (i) => CustomCard());
  @override
  Widget build(BuildContext context) {
    _lectureNames.add('Lecture 1');
    _lectureNames.add('Lecture 2');
    _lectureNames.add('Lecture 3');

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        bottom: TabBar(
          tabs: [
            Tab(text: ('Lectures')),
            Tab(text: ('Downloading')),
            Tab(text: ('Downloaded')),
          ],
          controller: _controller,
        ),
        title: Text('Lecture Materials'),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ListView.builder(
              itemCount: _lectureNames.length,
              itemBuilder: (context, index) => index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CustomCard(
                          lectureName: _lectureNames[index],
                          controller: _controller),
                    )
                  : CustomCard(
                      lectureName: _lectureNames[index],
                      controller: _controller)),
          //Icon(Icons.directions_car),
          Icon(Icons.directions_transit),
          Icon(Icons.directions_bike),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final lectureName;
  final controller;

  CustomCard({@required this.lectureName, @required this.controller});
  Future _getPermissionToDownload(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              titlePadding: EdgeInsets.only(
                  top: 15.0, left: 24.0, right: 24.0, bottom: 5.0),
              contentPadding: EdgeInsets.only(bottom: 0.0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Download'),
                  InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.cloud_download),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        controller.animateTo(1);
                      })
                ],
              ),
              children: <Widget>[
                CustomSimpleDialogOption(controller: controller),
                CustomSimpleDialogOption(controller: controller),
                CustomSimpleDialogOption(controller: controller),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: accentColor),
                    ),
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(600.0),
        child: Card(
          child: InkWell(
            onTap: () => _getPermissionToDownload(context),
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

class CustomSimpleDialogOption extends StatelessWidget {
  CustomSimpleDialogOption({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        controller.animateTo(1);
      },
      //=> Navigator.pop(context),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.file_download,
            color: lightGreyTextColor,
          ),
          SizedBox(width: 10.0),
          Text(
            'Download',
            style: TextStyle(color: lightGreyTextColor),
          )
        ],
      ),
    );
  }
}
