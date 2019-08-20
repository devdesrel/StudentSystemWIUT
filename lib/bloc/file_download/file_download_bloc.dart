import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';
import 'package:student_system_flutter/models/download_file_model.dart';

class FileDownloadBloc {
  var httpClient = new HttpClient();
  LearningMaterialsBloc _learningMaterialsBloc;

  FileDownloadBloc(
      LearningMaterialsBloc learningMaterialsBloc, DownloadFileModel file) {
    _learningMaterialsBloc = learningMaterialsBloc;

    _fileNameSubject.add(file.fileName);
    _downloadFile(learningMaterialsBloc.moduleName, file);
  }

  Stream<String> get fileName => _fileNameSubject.stream;

  final _fileNameSubject = BehaviorSubject<String>();

  Stream<double> get downloadProgress => _downloadProgressSubject.stream;

  final _downloadProgressSubject = BehaviorSubject<double>();

  Stream<String> get downloadingFileInformation =>
      _downloadingFileInformationSubject.stream;

  final _downloadingFileInformationSubject = BehaviorSubject<String>();

  Stream<bool> get isDownloaded => _isDownloadedSubject.stream;

  final _isDownloadedSubject = BehaviorSubject<bool>();

  void dispose() {
    _fileNameSubject.close();
    _downloadingFileInformationSubject.close();
    _downloadProgressSubject.close();
    _isDownloadedSubject.close();
  }

  Future<File> _downloadFile(
      String moduleName, DownloadFileModel downloadingFile) async {
    var request = await httpClient.getUrl(Uri.parse(downloadingFile.url));
    var response = await request.close();
    var bytes = await customConsolidateHttpClientResponseBytes(
        response, int.parse(downloadingFile.fileSize));
    String dir = Platform.isAndroid
        ? (await getExternalStorageDirectory()).path
        : (await getApplicationDocumentsDirectory()).path;

    final path = '$dir/WIUT Mobile/$moduleName/${downloadingFile.folderName}/';
    final myDir = Directory(path);
    myDir.exists().then((isExists) async {
      if (!isExists) {
        await myDir.create(recursive: true);
      }

      File file = new File('$path${downloadingFile.fileName}');
      await file.writeAsBytes(bytes);
      return file;
    });
    await Future.delayed(const Duration(seconds: 1));

    _learningMaterialsBloc.removeItemFromDownloadingList
        .add(downloadingFile.url);

    return null;
  }

  // bloc.removeItemFromDownloadingList.add(widget.downloadFile.url);

  Future<Uint8List> customConsolidateHttpClientResponseBytes(
      HttpClientResponse response, int fileSize) {
    // int _totalSize = 0;

    // response.contentLength is not trustworthy when GZIP is involved
    // or other cases where an intermediate transformer has been applied
    // to the stream.
    final Completer<Uint8List> completer = new Completer<Uint8List>.sync();
    final List<List<int>> chunks = <List<int>>[];

    // _totalSize = response.contentLength;

    _downloadingFileInformationSubject.add(fileSize.toString());
    int contentLength = 0;
    response.listen((List<int> chunk) {
      chunks.add(chunk);
      contentLength += chunk.length;

      _downloadProgressSubject
          .add((contentLength / 1048576) / (fileSize / 1048576));
      _downloadingFileInformationSubject.add(
          '${(contentLength / 1048576).toStringAsFixed(2)} MB / ${(fileSize / 1048576).toStringAsFixed(2)} MB');

      // setState(() {
      //   //Total downloaded bytes
      //   _downloadedChunkSize = contentLength;
      //   //Total progress
      //   _progress = (_downloadedChunkSize / 1048576) / (_totalSize / 1048576);
      // });
    }, onDone: () {
      final Uint8List bytes = new Uint8List(contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      completer.complete(bytes);
      _isDownloadedSubject.add(true);
    }, onError: completer.completeError, cancelOnError: true);

    return completer.future;
  }
}
