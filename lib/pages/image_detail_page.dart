import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final position;

  ImageDetailPage(this.position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero$position',
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          'https://picsum.photos/520/300/?random'),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft)),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
