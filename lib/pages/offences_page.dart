import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_offences.dart';

int _totalOffences = 7;

class OffencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showFlushBar(
        info, featureNotImplemented, MessageTypes.INFINITE_INFO, context);

    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              elevation: 3.0,
              centerTitle: true,
              title: Text('Offences'),
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                OffenceHeaderMessage(),
                SliverToBoxAdapter(child: SizedBox(height: 5.0)),
                OffenceBody(),
              ],
            ))
        : CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Offences'),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                OffenceHeaderMessage(),
                SliverToBoxAdapter(child: SizedBox(height: 5.0)),
                OffenceBody(),
              ],
            ));
  }
}

class OffenceHeaderMessage extends StatelessWidget {
  const OffenceHeaderMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        color: redColor,
        child: Column(
          children: <Widget>[
            Text(
              _totalOffences.toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .display2
                  .copyWith(color: whiteColor),
            ),
            Text(
              'Total points'.toUpperCase(),
              style:
                  Theme.of(context).textTheme.body2.copyWith(color: whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}

class OffenceBody extends StatelessWidget {
  const OffenceBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ItemOffences(),
        childCount: 10,
      ),
    );
  }
}
