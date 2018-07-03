import 'package:flutter/material.dart';

import '../helpers/app_constants.dart';
import '../list_items/item_offences.dart';

int _totalOffences = 7;

class OffencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 3.0,
          title: Text('Offences'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            OffenceHeaderMessage(),
            SliverToBoxAdapter(child: SizedBox(height: 5.0)),
            OffenceBody(),
          ],
        ));
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
