import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/file_manager.dart';

class OfflinePage extends StatelessWidget {
  final moduleName;

  OfflinePage({this.moduleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Downloaded Materials'),
      ),
      body: FileManager(
          mainDirectory: '/WIUT Mobile/$moduleName', isFilePicker: false),
    );
  }
}
