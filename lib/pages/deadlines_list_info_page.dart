import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class DeadlinesListInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
            width: double.infinity,
            child: Image.asset('assets/deadlines.png', fit: BoxFit.fitWidth)),
        Positioned(
          right: 30.0,
          bottom: 30.0,
          child: RaisedButton(
            child: Text(
              'Got it'.toUpperCase(),
              style: TextStyle(color: whiteColor),
            ),
            color: accentColor,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(homePage);
            },
          ),
        )
      ],
    ));
  }
}
