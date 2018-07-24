import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/file_manager.dart';

class OfflinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Materials'),
      ),
      body: FileManager(mainDirectory: '/WIUT Mobile/WAD', isFilePicker: false),
    );
  }
}
