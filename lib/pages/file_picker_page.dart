import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/file_manager.dart';

class FilePickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File picker'),
      ),
      body: FileManager(
        mainDirectory: '',
      ),
    );
  }
}
