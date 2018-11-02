import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final tag;
  final widget;

  ImageDetailPage({this.tag, this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        child: Center(
          child: Hero(tag: tag, child: widget),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
