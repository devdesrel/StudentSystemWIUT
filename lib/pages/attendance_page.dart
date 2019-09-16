import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:student_system_flutter/bloc/attendance_bloc/attendance_bloc.dart';

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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/attendance_image.png',
                  height: 300.0,
                ),
                StreamBuilder(
                    stream: bloc.qrResult,
                    builder: (context, snapshot) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          child: Text(
                            snapshot.hasData
                                ? snapshot.data
                                : 'Click button below to do Attendance',
                            textAlign: TextAlign.center,
                          ),
                        )),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: RaisedButton(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      color: Theme.of(context).accentColor,
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: bloc.scan,
                      child: const Text('SCAN')),
                ),
              ],
            ))
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              navigationBar: CupertinoNavigationBar(
                middle: Text('Attendance QR Scan'),
              ),
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Platform.isAndroid
                            ? RaisedButton(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                color: Theme.of(context).accentColor,
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0)),
                                ),
                                textColor: Colors.white,
                                splashColor: Colors.blueGrey,
                                onPressed: bloc.scan,
                                child: const Text('SCAN'))
                            : CupertinoButton(
                                color: Theme.of(context).accentColor,
                                onPressed: bloc.scan,
                                child: const Text('SCAN'),
                              ),
                      ),
                      StreamBuilder(
                        stream: bloc.qrResult,
                        builder: (context, snapshot) => snapshot.hasData
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 20.0),
                                child: Text(
                                  snapshot.data,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
