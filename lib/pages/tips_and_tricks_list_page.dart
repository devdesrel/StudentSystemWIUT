import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

class TipsAndTricksListPage extends StatelessWidget {
  final TextStyle stylish = TextStyle(color: accentColor);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Tips & Tricks'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: CustomCard(
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(tipsTricksPage);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/outlook.png'),
                      width: 40.0,
                    ),
                    title: Text(
                      'Web Mail (Outlook) ',
                      style: stylish,
                    ),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
            child: CustomCard(
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(tipsTricksPage);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image(
                      image: AssetImage('assets/turnitin.png'),
                      width: 40.0,
                    ),
                    title: Text(
                      'Turnitin ',
                      style: stylish,
                    ),
                    trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
