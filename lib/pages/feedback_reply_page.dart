import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

class FeedbackReplyPage extends StatefulWidget {
  @override
  _FeedbackReplyPageState createState() => _FeedbackReplyPageState();
}

class _FeedbackReplyPageState extends State<FeedbackReplyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply page'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomCard(
              Text('Comment goes here'),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
              ),
              child: CustomCard(
                Text('Replies go here'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
