import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class AppUpdatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset(
                'assets/playmarket.png',
                height: 60.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text('Application Update',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23.0,
                  )),
              Text(
                'Version 2.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: Text(
              'Bug fixes, performance enhancements, feature additions',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontFamily: 'RalewayRegular'),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: RaisedButton(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              color: Colors.white,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
              ),
              child: Text(
                'Ugrade now'.toUpperCase(),
                style: TextStyle(color: accentColor),
              ),
              onPressed: () {},
            ),
            // RaisedButton(
            //   padding: EdgeInsets.symmetric(vertical: 15.0),
            //   onPressed: () {},
            //   color: whiteColor,
            //   child: Text(
            //     'Ugrade now'.toUpperCase(),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
