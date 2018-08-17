import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Support'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'If you have faced technical problems (e.g. _a) hit the contact button'),
            ),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text('Contact'),
          )
        ],
      ),
    );
  }
}
