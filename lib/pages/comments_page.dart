import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments page'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Name goes here'),
            isThreeLine: true,
            subtitle: Text.rich(TextSpan(text: 'comment goes here')),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
