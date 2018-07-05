import 'package:flutter/material.dart';
import 'package:student_system_flutter/list_items/item_file_downloading.dart';
import 'package:student_system_flutter/models/download_file_model.dart';
import 'package:student_system_flutter/models/file_model.dart';
import 'package:student_system_flutter/pages/files_downloaded_page.dart';

import '../bloc/file_download_provider.dart';
import '../helpers/app_constants.dart';
import 'dart:async';

class LecturesPage extends StatefulWidget {
  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage>
    with SingleTickerProviderStateMixin {
  List<String> _lecturesList = List();
  List<DownloadFile> _fileDownloadingList = List();
  List<FileModel> _downloadedFilesList = List();

  final url =
      'https://images.pexels.com/photos/443446/pexels-photo-443446.jpeg?cs=srgb&dl=daylight-forest-glossy-443446.jpg&fm=jpg';
  final filename = 'Lecture.jpg';

  final url2 = 'http://www.africau.edu/images/default/sample.pdf';
  final filename2 = 'Lecture.pdf';

  TabController _controller;

  void _populateList() {
    _lecturesList = List();
    _fileDownloadingList = List();

    _lecturesList.add('Lecture 1');
    _lecturesList.add('Lecture 2');
    _lecturesList.add('Lecture 3');

    // _fileDownloadingList.add(DownloadFile(url: url, filename: filename));
    // _fileDownloadingList.add(DownloadFile(url: url2, filename: filename2));
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  // List<Widget> lecturecards = List.generate(5, (i) => CustomCard());
  @override
  Widget build(BuildContext context) {
    _populateList();

    return FileDownloadProvider(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: ('Lectures')),
              Tab(text: ('Downloading')),
              Tab(text: ('Downloaded')),
            ],
            controller: _controller,
          ),
          title: Text('Lecture Materials'),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            ListView.builder(
                itemCount: _lecturesList.length,
                itemBuilder: (context, index) => index == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CustomCard(
                            downloadFile: DownloadFile(
                                url: url,
                                fileName: filename,
                                materialName: _lecturesList[index]),
                            controller: _controller),
                      )
                    : CustomCard(
                        downloadFile: DownloadFile(
                            url: url,
                            fileName: filename,
                            materialName: _lecturesList[index]),
                        controller: _controller)),
            FileDownloadingTab(),
            FilesDownloadedPage()
          ],
        ),
      ),
    );
  }
}

class FileDownloadingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = FileDownloadProvider.of(context);

    return StreamBuilder<List<DownloadFile>>(
        stream: bloc.items,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(
                child:
                    Text('Empty', style: Theme.of(context).textTheme.headline));
          }

          return ListView(
              children: snapshot.data
                  .map((item) => ItemFileDownloading(downloadFile: item))
                  .toList());
        });

    // return ListView.builder(
    //   itemCount: fileDownloadingList.length,
    //   itemBuilder: (context, index) => fileDownloadingList.length == 0
    //       ? Container()
    //       : ItemFileDownloading(downloadFile: fileDownloadingList[index]),
    // );
  }
}

class CustomCard extends StatelessWidget {
  final DownloadFile downloadFile;
  final controller;

  CustomCard({@required this.downloadFile, @required this.controller});
  Future _getPermissionToDownload(BuildContext context) async {
    var bloc = FileDownloadProvider.of(context);

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.only(
                top: 15.0, left: 24.0, right: 24.0, bottom: 5.0),
            contentPadding: EdgeInsets.only(bottom: 0.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Download'),
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.cloud_download),
                    ),
                    onTap: () {
                      bloc.addFileToDownload.add(downloadFile);

                      Navigator.pop(context);

                      controller.animateTo(1);
                    })
              ],
            ),
            children: <Widget>[
              CustomSimpleDialogOption(controller: controller),
              CustomSimpleDialogOption(controller: controller),
              CustomSimpleDialogOption(controller: controller),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: accentColor),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(600.0),
        child: Card(
          child: InkWell(
            onTap: () => _getPermissionToDownload(context),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                downloadFile.materialName,
                textAlign: TextAlign.center,
                style: Theme
                    .of(context)
                    .textTheme
                    .headline
                    .copyWith(color: lightGreyTextColor, fontSize: 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSimpleDialogOption extends StatelessWidget {
  CustomSimpleDialogOption({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final controller;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context);
        controller.animateTo(1);
      },
      //=> Navigator.pop(context),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.file_download,
            color: lightGreyTextColor,
          ),
          SizedBox(width: 10.0),
          Text(
            'Download',
            style: TextStyle(color: lightGreyTextColor),
          )
        ],
      ),
    );
  }
}
