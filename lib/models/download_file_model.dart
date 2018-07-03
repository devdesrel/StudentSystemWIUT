class DownloadFile {
  final String url;
  final String materialName;
  final String fileName;
  final int totalSize;

  DownloadFile(
      {this.url, this.materialName, this.fileName, this.totalSize = 0});
}
