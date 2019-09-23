import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

//Material Drawer
class CustomAndroidDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text('Ramziddin Toshmukhamedov',
                      style: TextStyle(color: Colors.white)),
                ]),
            decoration: BoxDecoration(color: Theme.of(context).accentColor),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

Widget getPlatformButton(
    {BuildContext context, Widget child, VoidCallback function}) {
  return Platform.isAndroid
      ? RaisedButton(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          color: Theme.of(context).accentColor,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
          ),
          textColor: Colors.white,
          splashColor: Colors.blueGrey,
          onPressed: function,
          child: child)
      : CupertinoButton(
          color: Theme.of(context).accentColor,
          onPressed: function,
          child: child);
}

// Material Card
class CustomCard extends StatelessWidget {
  final Widget _child;

  CustomCard(
    this._child,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.0, color: whiteColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: _child,
    );
  }
}

//Rating Bar
typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  StarRating(
      {this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        size: 30.0,
        color: Theme.of(context).primaryColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        size: 30.0,
        color: color ?? Theme.of(context).primaryColor,
      );
    } else {
      icon = new Icon(
        Icons.star,
        size: 30.0,
        color: color ?? Theme.of(context).primaryColor,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}

class DrawPlatformCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Center(child: CircularProgressIndicator());
    } else if (Platform.isIOS) {
      return Center(child: CupertinoActivityIndicator());
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

final List<String> months = [
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
  'DEC',
];
