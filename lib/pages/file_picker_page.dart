import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/file_manager.dart';

class FilePickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('File picker'),
            ),
            body: FileManager(
              mainDirectory: '',
              isFilePicker: true,
            ),
          )
        : Material(
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('File picker'),
              ),
              child: FileManager(
                mainDirectory: '',
                isFilePicker: true,
              ),
            ),
          );
  }
}
