import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final position;
  final widget;

  ImageDetailPage({this.position, this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Center(
          child: Hero(tag: 'imageHero$position', child: widget),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
