import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/file_manager.dart';

class OfflinePage extends StatelessWidget {
  final moduleName;

  OfflinePage({this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Downloaded Materials'),
            ),
            body: FileManager(
                mainDirectory: '/WIUT Mobile/$moduleName', isFilePicker: false),
          )
        : Material(
            color: Colors.transparent,
            child: CupertinoPageScaffold(
              backgroundColor: backgroundColor,
              navigationBar: CupertinoNavigationBar(
                middle: Text('Downloaded Materials'),
              ),
              child: FileManager(
                  mainDirectory: '/WIUT Mobile/$moduleName',
                  isFilePicker: false),
            ),
          );
  }
}
