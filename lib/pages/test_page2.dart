import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class FormDemo extends StatefulWidget {
  @override
  _FormDemoState createState() => _FormDemoState();
}

class _FormDemoState extends State<FormDemo>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();

  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getBool(isLoggedIn);
    _controller.reverse();
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());

    // _focusNode
    // FocusScope.of(context).requestFocus(FocusNode());

    return value;
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false, // this avoids the overflow error
        appBar: AppBar(
          title: Text('TextField Animation Demo'),
        ),
        body: new InkWell(
          // to dismiss the keyboard when the user tabs out of the TextField
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: _animation.value),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'I move!',
                  ),
                  focusNode: _focusNode,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
