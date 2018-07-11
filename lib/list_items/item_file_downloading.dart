import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:student_system_flutter/bloc/file_download_bloc.dart';
import 'package:student_system_flutter/bloc/file_download_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class ItemFileDownloading extends StatefulWidget {
  final DownloadFile downloadFile;

  ItemFileDownloading({@required this.downloadFile});

  @override
  _ItemFileDownloadingState createState() => _ItemFileDownloadingState();
}

class _ItemFileDownloadingState extends State<ItemFileDownloading> {
  var httpClient = new HttpClient();
  int _totalSize = 0;
  int _downloadedChunkSize = 0;
  double _progress = 0.0;

  Permission permission = Permission.WriteExternalStorage;

  _requestPermission(FileDownloadBloc bloc) async {
    bool res = await SimplePermissions.requestPermission(permission);
    print("permission request result is " + res.toString());

    if (res) {
      await _downloadFile(
          widget.downloadFile.url, widget.downloadFile.fileName);
      bloc.removeItemFromDownloadingList.add(widget.downloadFile.url);
    }
  }

  Future<Uint8List> customConsolidateHttpClientResponseBytes(
      HttpClientResponse response) {
    // response.contentLength is not trustworthy when GZIP is involved
    // or other cases where an intermediate transformer has been applied
    // to the stream.
    final Completer<Uint8List> completer = new Completer<Uint8List>.sync();
    final List<List<int>> chunks = <List<int>>[];

    setState(() {
      _totalSize = response.contentLength;
    });
    int contentLength = 0;
    response.listen((List<int> chunk) {
      chunks.add(chunk);
      contentLength += chunk.length;

      setState(() {
        //Total downloaded bytes
        _downloadedChunkSize = contentLength;
        //Total progress
        _progress = (_downloadedChunkSize / 1048576) / (_totalSize / 1048576);
      });
    }, onDone: () {
      final Uint8List bytes = new Uint8List(contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      completer.complete(bytes);
    }, onError: completer.completeError, cancelOnError: true);

    return completer.future;
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await customConsolidateHttpClientResponseBytes(response);
    String dir = Platform.isAndroid
        ? (await getExternalStorageDirectory()).path
        : (await getApplicationDocumentsDirectory()).path;

    final path = '$dir/WIUT Mobile/WAD/Lectures/Lecture 1/';
    final myDir = Directory(path);
    myDir.exists().then((isExists) async {
      if (!isExists) {
        await myDir.create(recursive: true);
      }

      File file = new File('$path$filename');
      await file.writeAsBytes(bytes);
      return file;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = FileDownloadProvider.of(context);
    // bool startDownloading = true;

    // if (startDownloading) {
    //   startDownloading = false;
    //   _requestPermission();
    // }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                  child: Text('Download'),
                  onPressed: () => _requestPermission(_bloc)),
              SizedBox(
                height: 10.0,
              ),
              Text('File name: ${widget.downloadFile.fileName}'),
              SizedBox(
                height: 10.0,
              ),
              LinearProgressIndicator(
                value: _progress,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${(_downloadedChunkSize/1048576).toStringAsFixed(2)} MB / ${(_totalSize/1048576).toStringAsFixed(2)} MB',
                textAlign: TextAlign.end,
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
