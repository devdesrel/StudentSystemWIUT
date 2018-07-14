class DownloadFileModel {
  final String url;
  final String fileName;
  final int totalSize;

  DownloadFileModel({this.url, this.fileName, this.totalSize = 0});
}
