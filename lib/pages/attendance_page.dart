import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:student_system_flutter/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/Attendance/attendance_model.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = AttendanceBloc();
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              title: Text('Attendance QR Scan'),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: _getBodyWidget(bloc))
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
                backgroundColor: Colors.white,
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Attendance QR Scan'),
                ),
                child: _getBodyWidget(bloc)));
  }

  Widget _getBodyWidget(AttendanceBloc bloc) {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          'assets/attendance_image.png',
          height: 300.0,
        ),
        StreamBuilder<AttendanceModel>(
            stream: bloc.qrResult,
            builder: (context, snapshot) => snapshot.hasData
                ? snapshot.data.isSuccess
                    ? Column(
                        children: <Widget>[
                          Text('Successfully attended',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  color: greenColor)),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.0),
                            child: Text(snapshot.data.module,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 48.0),
                            child: Text(snapshot.data.lesson,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14.0)),
                          ),
                        ],
                      )
                    : Text(snapshot.data.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))
                : Text('Click button below to do Attendance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold))),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: StreamBuilder<AttendanceModel>(
              stream: bloc.qrResult,
              builder: (context, snapshot) =>
                  snapshot.hasData && snapshot.data.isSuccess
                      ? getPlatformButton(
                          context: context,
                          function: Navigator.of(context).pop,
                          child: Text('Go to Home Page'.toUpperCase()))
                      : getPlatformButton(
                          context: context,
                          function: bloc.scan,
                          child: Text('Scan'.toUpperCase()))),
        )
      ],
    ));
  }
}
