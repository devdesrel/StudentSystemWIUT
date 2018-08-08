import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:student_system_flutter/bloc/file_download/file_download_bloc.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_provider.dart';
import 'package:student_system_flutter/list_items/item_file_downloading.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/models/LearningMaterials/single_learning_material_model.dart';
import 'package:student_system_flutter/models/download_file_model.dart';
import 'package:student_system_flutter/pages/offline_page.dart';

import '../helpers/app_constants.dart';

class LecturesPage extends StatefulWidget {
  final LearningMaterialsModel module;

  LecturesPage({this.module});

  @override
  _LecturesPageState createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var bloc = LearningMaterialsBloc();
    bloc.moduleName = widget.module.moduleName;

    return LearningMaterialsProvider(
      learningMaterialsBloc: bloc,
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
          title: Text(widget.module.moduleName),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OfflinePage(moduleName: widget.module.moduleName)));
              },
            )
          ],
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            MaterialsListTab(
                materialsList: widget.module.moduleMaterial,
                controller: _controller,
                bloc: bloc),
            FileDownloadingTab(),
          ],
        ),
      ),
    );
  }
}

class MaterialsListTab extends StatefulWidget {
  final List<SingleLearningMaterialsModel> materialsList;
  final TabController controller;
  final LearningMaterialsBloc bloc;

  MaterialsListTab({
    Key key,
    @required this.materialsList,
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
        itemCount: widget.materialsList.length,
        itemBuilder: (context, index) => index == 0
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LearningMaterialsCard(
                    learningMaterialsModel: widget.materialsList[index],
                    controller: widget.controller,
                    bloc: widget.bloc),
              )
            : LearningMaterialsCard(
                learningMaterialsModel: widget.materialsList[index],
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
    var bloc = LearningMaterialsProvider.of(context);

    return StreamBuilder<List<DownloadFileModel>>(
        stream: bloc.downloadingFilesList,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.isEmpty) {
            return Center(child: Text('Nothing to download'));
          }

          return ListView(
              children: snapshot.data
                  .map((file) =>
                      ItemFileDownloading(bloc: FileDownloadBloc(bloc, file)))
                  .toList());
        });
  }
}

class LearningMaterialsCard extends StatelessWidget {
  final SingleLearningMaterialsModel learningMaterialsModel;
  final controller;
  final LearningMaterialsBloc bloc;

  LearningMaterialsCard(
      {@required this.learningMaterialsModel,
      @required this.controller,
      @required this.bloc});

  List<Widget> _getDialogItems(
      BuildContext context, List<DownloadFileModel> downloadFilesList) {
    List<Widget> _listOfWidgets = [];

    if (downloadFilesList.length > 0) {
      for (var downloadFile in downloadFilesList) {
        downloadFile.folderName = learningMaterialsModel.title;

        _listOfWidgets.add(CustomSimpleDialogOption(
          controller: controller,
          downloadFile: downloadFile,
          bloc: bloc,
          flushBar: bloc.flushBar,
        ));
      }
    } else {
      _listOfWidgets.add(Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(noFilesToDownload),
        ),
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

  _getPermissionToDownloadAndShowDialog(BuildContext _context) async {
    var bloc = LearningMaterialsProvider.of(_context);
    Permission permission = Permission.WriteExternalStorage;

    bool result = await SimplePermissions.requestPermission(permission);

    if (result) {
      await showDialog(
          context: _context,
          builder: (context) {
            return FutureBuilder<List<DownloadFileModel>>(
              future: bloc.getFileUrlsToDownload(
                  _context, learningMaterialsModel.id),
              builder: (context, snapshot) => snapshot.hasData
                  ? SimpleDialog(
                      titlePadding: EdgeInsets.only(
                          top: 15.0, left: 24.0, right: 24.0, bottom: 5.0),
                      contentPadding: EdgeInsets.only(bottom: 0.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Download'),
                          snapshot.data.length > 1
                              ? InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.cloud_download),
                                  ),
                                  onTap: () {
                                    for (var downloadFile in snapshot.data) {
                                      downloadFile.folderName =
                                          learningMaterialsModel.title;
                                      bloc.addFileToDownload.add(downloadFile);
                                    }
                                    Navigator.pop(context);

                                    controller.animateTo(1);
                                    bloc.flushBar.show(context);
                                  })
                              : Container()
                        ],
                      ),
                      children: _getDialogItems(context, snapshot.data))
                  : Center(child: CircularProgressIndicator()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Card(
        child: InkWell(
          // onTap: () {},
          onTap: () => _getPermissionToDownloadAndShowDialog(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              learningMaterialsModel.title,
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
    );
  }
}

class CustomSimpleDialogOption extends StatelessWidget {
  final controller;
  final DownloadFileModel downloadFile;
  final LearningMaterialsBloc bloc;
  final flushBar;

  CustomSimpleDialogOption(
      {Key key,
      @required this.bloc,
      @required this.downloadFile,
      @required this.controller,
      @required this.flushBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
      onTap: () {
        bloc.addFileToDownload.add(downloadFile);
        Navigator.pop(context);
        controller.animateTo(1);
        flushBar.show(context);
      },
      leading: Icon(
        Icons.file_download,
        color: lightGreyTextColor,
      ),
      title: Text(
        downloadFile.fileName,
        style: TextStyle(color: lightGreyTextColor),
      ),
    );
  }
}
