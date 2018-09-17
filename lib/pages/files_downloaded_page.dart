import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';

class FilesDownloadedPage extends StatefulWidget {
  @override
  _FilesDownloadedPageState createState() => _FilesDownloadedPageState();
}

class _FilesDownloadedPageState extends State<FilesDownloadedPage> {
  bool externalStoragePermissionOkay = false;

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }

  @override
  initState() {
    super.initState();
    _initPlatformState();
  }

  // Future<Widget> _getAllDownloadedFiles() async {
  //   String dir = Platform.isAndroid
  //       ? (await getExternalStorageDirectory()).path
  //       : (await getApplicationDocumentsDirectory()).path;

  //   final path = '$dir/WIUT Mobile/WAD/Lectures/Lecture 1/';
  //   final myDir = Directory(path);

  //   myDir.exists().then((isExists) async {
  //     if (isExists) {
  //       var list = myDir.listSync();
  //       var file = File(list[0].path);

  //       var fileSize = file.length();
  //       var modifiedTime = file.lastModifiedSync();
  //       var fileName = basename(file.path);

  //       return Column(
  //         children: <Widget>[
  //           Text('File name: $fileName'),
  //           Text('File size: $fileSize'),
  //           Text('File size: $modifiedTime')
  //         ],
  //       );
  //     }
  //   });
  //   return Text('');
  // }

  _initPlatformState() async {
    if (Platform.isAndroid) {
      SimplePermissions.checkPermission(Permission.WriteExternalStorage)
          .then((checkOkay) {
        if (!checkOkay) {
          SimplePermissions.requestPermission(Permission.WriteExternalStorage)
              .then((okDone) {
            if (okDone) {
              setState(() {
                externalStoragePermissionOkay = okDone;
              });
            }
          });
        } else {
          setState(() {
            externalStoragePermissionOkay = checkOkay;
          });
        }
      });
    }
  }

  Widget _buildSuggestions() {
    if (Platform.isAndroid && externalStoragePermissionOkay) {
      return new FutureBuilder<Directory>(
          future: getExternalStorageDirectory(), builder: _buildDirectory);
    } else {
      return new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Text("You're not on Android"));
    }
  }

  Widget _buildDirectory(
      BuildContext context, AsyncSnapshot<Directory> snapshot) {
    Text text = const Text('');
    Directory dir;
    List<FileSystemEntity> _files;
    List<String> paths = List();

    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        text = new Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        dir = new Directory(
            snapshot.data.path + '/WIUT Mobile/WAD/Lectures/Lecture 1/');
        _files = dir.listSync(recursive: false, followLinks: true);

        for (int i = 0; i < _files.length; i++) {
          if (_files.elementAt(i).runtimeType != Directory)
            paths.add(_files.elementAt(i).path);
        }
        paths.sort();
      } else {
        text = const Text('path unavailable');
      }
    }
    if (null != _files) {
      return new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: paths.length,
          itemBuilder: (context, i) {
            return _buildRow(paths.elementAt(i));
          });
    } else {
      return new Padding(padding: const EdgeInsets.all(16.0), child: text);
    }
  }

  Widget _buildRow(String path) {
    var file = File(path);

    var modifiedTime = file.lastModifiedSync();

    return ListTile(
      leading: Icon(Icons.ac_unit),
      title: Text(basename(path)),
      subtitle: Text(modifiedTime.toString()),
    );
  }
}
