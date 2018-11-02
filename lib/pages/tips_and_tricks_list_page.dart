import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/pages/tips_tricks_page.dart';

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
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TipsAndTricksPage(
                              type: TipsRequestType.Outlook,
                            )));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
                child: CustomCard(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage('assets/outlook.png'),
                        width: 40.0,
                      ),
                      title: Text(
                        'Web Mail (Outlook)',
                        style: stylish,
                      ),
                      trailing: Icon(CupertinoIcons.right_chevron),
                    ),
                    // title: Text(
                    //   'Web Mail (Outlook) ',
                    //   style: stylish,
                    // ),
                    // trailing: Icon(CupertinoIcons.right_chevron),
                  ),
                ),
              )),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TipsAndTricksPage(
                              type: TipsRequestType.Gmail,
                            )));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: CustomCard(
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage('assets/gmail_logo.png'),
                        width: 50.0,
                      ),
                      title: Text(
                        'Web Mail (Gmail)',
                        style: stylish,
                      ),
                      trailing: Icon(CupertinoIcons.right_chevron),
                    ),
                  ),
                ),
              )),
          // InkWell(
          //     onTap: () {
          //       Navigator.of(context).pushNamed(tipsTricksPage);
          //     },
          //     child: Padding(
          //       padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
          //       child: CustomCard(
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: ListTile(
          //             leading: Image(
          //               image: AssetImage('assets/turnitin.png'),
          //               width: 40.0,
          //             ),
          //             title: Text(
          //               'Turnitin ',
          //               style: stylish,
          //             ),
          //             trailing: Icon(CupertinoIcons.right_chevron),
          //           ),
          //         ),
          //       ),
          //     )),
        ],
      ),
    );
  }
}
