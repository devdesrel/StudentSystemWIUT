import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class BooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int daysLeft = 2;
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('Ordered Books'),
              centerTitle: true,
            ),
            backgroundColor: backgroundColor,
            body: ListView.builder(
              //TODO: change itemCount into list.length
              itemCount: 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 10.0,
                    ),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                  //TODO: change index with list.length-1
                } else if (index == 9) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 5.0, bottom: 10.0),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 5.0,
                    ),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                }
              },
            ),
          )
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Ordered Books'),
            ),
            backgroundColor: backgroundColor,
            child: ListView.builder(
              //TODO: change itemCount into list.length
              itemCount: 10,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 10.0,
                    ),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                  //TODO: change index with list.length-1
                } else if (index == 9) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 5.0, bottom: 10.0),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 5.0,
                    ),
                    child: CustomBooksCard(daysLeft: daysLeft),
                  );
                }
              },
            ),
          );
  }
}

class CustomBooksCard extends StatelessWidget {
  const CustomBooksCard({
    Key key,
    @required this.daysLeft,
  }) : super(key: key);

  final int daysLeft;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/chaffey.jpg',
              height: 115.0,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Business Information Systems nnnjnjnjnnnjnjnjnn nnjnjn',
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: 'SlaboRegular'),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Author: Chaffey and Wood',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: accentColor),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Year: 2010',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: lightGreyTextColor),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '$daysLeft DAYS LEFT',
                        style: TextStyle(color: redColor, fontSize: 15.0),
                        textAlign: TextAlign.right,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
