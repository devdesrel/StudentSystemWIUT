import 'package:flutter/material.dart';

import '../helpers/app_constants.dart';

// class ItemOffences extends StatelessWidget {
//   final offencesList;
//   final OffencesType requestType;
//   const ItemOffences({
//     @required this.offencesList,
//     @required this.requestType,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//       child: Card(
//           //Custom card will be added
//           elevation: 2.0,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   'Type of Offence goes here',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline
//                       .copyWith(color: accentColor),
//                 ),
//                 SizedBox(height: 15.0),
//                 OffenceCustomRow(name: 'Module Name', value: 'WAD'),
//                 SizedBox(height: 10.0),
//                 OffenceCustomRow(name: 'Offences points', value: '2'),
//                 SizedBox(height: 10.0),
//                 OffenceCustomRow(name: 'Offence date', value: '04/22/2018'),
//               ],
//             ),
//           )),
//     );
//   }
// }

class OffenceCustomRow extends StatelessWidget {
  final String name;
  final String value;
  final bool isPoint;
  OffenceCustomRow({this.name, this.value, this.isPoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
              color: accentColor, fontSize: 15.5, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
              color: isPoint ? redColor : textColor,
              fontSize: isPoint ? 22.0 : 15.0),
        )
      ],
    );
  }
}
