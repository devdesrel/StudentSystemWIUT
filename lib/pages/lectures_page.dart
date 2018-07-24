import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/file_download_bloc.dart';
import 'package:student_system_flutter/list_items/item_file_downloading.dart';
import 'package:student_system_flutter/models/download_file_model.dart';
import 'package:student_system_flutter/models/learning_materials_model.dart';

import '../bloc/file_download_provider.dart';
import '../helpers/app_constants.dart';
import 'dart:async';

class LecturesPage extends StatefulWidget {
  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage>
    with SingleTickerProviderStateMixin {
  List<LearningMaterialsModel> _lecturesList = [];

  TabController _controller;

  void _populateList() {
    final url1 =
        'https://images.pexels.com/photos/443446/pexels-photo-443446.jpeg?cs=srgb&dl=daylight-forest-glossy-443446.jpg&fm=jpg';
    final filename1 = 'Lecture1.jpg';
    final url2 = 'http://www.africau.edu/images/default/sample.pdf';
    final filename2 = 'Lecture1.pdf';
    final url3 = 'http://topmusic.uz/get/single-13449.mp3';
    final filename3 = 'Lecture1.mp3';

    List<DownloadFileModel> downloadFilesList = [
      DownloadFileModel(url: url1, fileName: filename1),
      DownloadFileModel(url: url2, fileName: filename2),
      DownloadFileModel(url: url3, fileName: filename3),
    ];

    _lecturesList.add(LearningMaterialsModel('Lecture 1', downloadFilesList));
    _lecturesList.add(LearningMaterialsModel('Lecture 2', downloadFilesList));
    _lecturesList.add(LearningMaterialsModel('Lecture 3', downloadFilesList));
  }

  @override
  void initState() {
    _populateList();

    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = FileDownloadBloc();
    return FileDownloadProvider(
      fileDownloadBloc: bloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: ('Lectures')),
              Tab(text: ('Downloading')),
            ],
            controller: _controller,
          ),
          title: Text('Lecture Materials'),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            MaterialsListTab(
                lecturesList: _lecturesList,
                controller: _controller,
                bloc: bloc),
            FileDownloadingTab(),

            // FilesDownloadedPage()
          ],
        ),
      ),
    );
  }
}

class MaterialsListTab extends StatefulWidget {
  final List<LearningMaterialsModel> lecturesList;
  final TabController controller;
  final FileDownloadBloc bloc;

  MaterialsListTab({
    Key key,
    @required this.lecturesList,
    @required this.controller,
    @required this.bloc,
  }) : super(key: key);

  @override
  _MaterialsListTabState createState() => _MaterialsListTabState();
}

class _MaterialsListTabState extends State<MaterialsListTab>
    with AutomaticKeepAliveClientMixin {
  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print('Rebuild Materials List Tab');

    return ListView.builder(
        itemCount: widget.lecturesList.length,
        itemBuilder: (context, index) => index == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomCard(
                    learningMaterialsModel: widget.lecturesList[index],
                    controller: widget.controller,
                    bloc: widget.bloc),
              )
            : CustomCard(
                learningMaterialsModel: widget.lecturesList[index],
                controller: widget.controller,
                bloc: widget.bloc,
              ));
  }
}

class FileDownloadingTab extends StatefulWidget {
  @override
  _FileDownloadingTabState createState() => _FileDownloadingTabState();
}

class _FileDownloadingTabState extends State<FileDownloadingTab>
    with AutomaticKeepAliveClientMixin {
  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('Rebuild FileDownloading Tab');
    var bloc = FileDownloadProvider.of(context);

    return StreamBuilder<List<DownloadFileModel>>(
        stream: bloc.items,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(child: Text('Nothing to download'));
          }

          return ListView(
              children: snapshot.data
                  .map((item) => ItemFileDownloading(downloadFile: item))
                  .toList());
        });
  }
}

// class FileDownloadingTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var bloc = FileDownloadProvider.of(context);

//     return StreamBuilder<List<DownloadFileModel>>(
//         stream: bloc.items,
//         builder: (context, snapshot) {
//           if (snapshot.data == null || snapshot.data.isEmpty) {
//             return Center(child: Text('Nothing to download'));
//           }

//           return ListView(
//               children: snapshot.data
//                   .map((item) => ItemFileDownloading(downloadFile: item))
//                   .toList());
//         });

//     // return ListView.builder(
//     //   itemCount: fileDownloadingList.length,
//     //   itemBuilder: (context, index) => fileDownloadingList.length == 0
//     //       ? Container()
//     //       : ItemFileDownloading(downloadFile: fileDownloadingList[index]),
//     // );
//   }
// }

class CustomCard extends StatelessWidget {
  final LearningMaterialsModel learningMaterialsModel;
  final controller;
  final bloc;

  CustomCard(
      {@required this.learningMaterialsModel,
      @required this.controller,
      @required this.bloc});

  List<Widget> _getDialogItems(BuildContext context) {
    List<Widget> _listOfWidgets = [];

    for (var downloadFile in learningMaterialsModel.downloadFilesList) {
      _listOfWidgets.add(CustomSimpleDialogOption(
        controller: controller,
        downloadFile: downloadFile,
        bloc: bloc,
      ));
    }

    _listOfWidgets.add(Align(
      alignment: Alignment.bottomRight,
      child: FlatButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancel',
          style: TextStyle(color: accentColor),
        ),
      ),
    ));

    return _listOfWidgets;
  }

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
                        for (var downloadFile
                            in learningMaterialsModel.downloadFilesList) {
                          bloc.addFileToDownload.add(downloadFile);
                        }
                        Navigator.pop(context);

                        controller.animateTo(1);
                      })
                ],
              ),
              children: _getDialogItems(context));
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
                learningMaterialsModel.lectureName,
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
  final controller;
  final DownloadFileModel downloadFile;
  final bloc;

  CustomSimpleDialogOption({
    Key key,
    @required this.bloc,
    @required this.downloadFile,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        bloc.addFileToDownload.add(downloadFile);
        Navigator.pop(context);
        controller.animateTo(1);
      },
      child: Row(
        children: <Widget>[
          Icon(
            Icons.file_download,
            color: lightGreyTextColor,
          ),
          SizedBox(width: 10.0),
          Text(
            downloadFile.fileName,
            style: TextStyle(color: lightGreyTextColor),
          )
        ],
      ),
    );
  }
}
