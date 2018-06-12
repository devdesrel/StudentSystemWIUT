import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemSuggestions extends StatelessWidget {
  final positionIndex;

  ItemSuggestions({Key key, this.positionIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                'https://picsum.photos/100/100/?random'),
          ),
          Text('John Doe $positionIndex')
        ],
      );
}
