import 'package:flutter/material.dart';

import '../helpers/app_constants.dart';

class ItemOffences extends StatelessWidget {
  const ItemOffences({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Card(
          //Custom card will be added
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Type of Offence goes here',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline
                      .copyWith(color: accentColor),
                ),
                SizedBox(height: 15.0),
                OffenceCustomRow(name: 'Module Name', value: 'WAD'),
                SizedBox(height: 10.0),
                OffenceCustomRow(name: 'Module Name', value: 'WAD'),
                SizedBox(height: 10.0),
                OffenceCustomRow(name: 'Module Name', value: 'WAD'),
              ],
            ),
          )),
    );
  }
}

class OffenceCustomRow extends StatelessWidget {
  final String name;
  final String value;

  OffenceCustomRow({this.name, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(name), Text(value)],
    );
  }
}
