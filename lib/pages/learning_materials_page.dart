import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:student_system_flutter/bloc/file_download/file_download_bloc.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_bloc.dart';
import 'package:student_system_flutter/bloc/file_download/learning_materials_provider.dart';
import 'package:student_system_flutter/helpers/learning_materials_academic_year_expansion_tile.dart';
import 'package:student_system_flutter/helpers/learning_materials_expansion_tile.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/list_items/item_file_downloading.dart';
import 'package:student_system_flutter/models/LearningMaterials/learning_materials_model.dart';
import 'package:student_system_flutter/models/LearningMaterials/single_learning_material_model.dart';
import 'package:student_system_flutter/models/download_file_model.dart';
import 'package:student_system_flutter/pages/offline_page.dart';

import '../helpers/app_constants.dart';

class LearningMaterialsPage extends StatefulWidget {
  final LearningMaterialsModel module;

  LearningMaterialsPage({this.module});

  @override
  _LearningMaterialsPageState createState() => _LearningMaterialsPageState();
}

class _LearningMaterialsPageState extends State<LearningMaterialsPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage == null) {
      _currentPage = _createCurrentPage(context);
    }

    return _currentPage;
  }

  Widget _createCurrentPage(BuildContext context) {
    var bloc = LearningMaterialsBloc(
        context, widget.module.moduleID, widget.module.moduleMaterial);
    bloc.moduleName = widget.module.moduleName;

    return LearningMaterialsProvider(
        learningMaterialsBloc: bloc,
        child: Platform.isAndroid
            ?

            ///Android version
            Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                appBar: AppBar(
                  bottom: TabBar(
                    tabs: [
                      Tab(text: ('Materials')),
                      Tab(text: ('Downloading')),
                    ],
                    controller: _controller,
                  ),
                  elevation: 0.0,
                  title: Text(widget.module.moduleName),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(MdiIcons.folderDownload),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OfflinePage(
                                moduleName: widget.module.moduleName)));
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
              )
            //End of Android version

            : Material(
                color: Colors.transparent,
                child: StreamBuilder(
                  stream: bloc.currentIndex,
                  initialData: 0,
                  builder: (context, snapshot) => CupertinoTabScaffold(
                      tabBar: CupertinoTabBar(
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.list,
                              size: 18.0,
                            ),
                            title: Text('Materials'),
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(
                              Icons.file_download,
                              size: 18.0,
                            ),
                            title: Text('Downloading'),
                          ),
                        ],
                        onTap: (index) => bloc.setCurrentIndex.add(index),
                        currentIndex: snapshot.hasData ? snapshot.data : 0,
                      ),
                      tabBuilder: (context, index) => CupertinoPageScaffold(
                          navigationBar: CupertinoNavigationBar(
                            middle: Text(
                              widget.module.moduleName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.cloud_download),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OfflinePage(
                                        moduleName: widget.module.moduleName)));
                              },
                            ),
                          ),
                          child: StreamBuilder(
                              stream: bloc.currentIndex,
                              initialData: 0,
                              builder: (context, snapshot) => snapshot.hasData
                                  ? snapshot.data == 0
                                      ? Container(
                                          color: backgroundColor,
                                          child: MaterialsListTab(
                                              materialsList:
                                                  widget.module.moduleMaterial,
                                              controller: _controller,
                                              bloc: bloc),
                                        )
                                      : FileDownloadingTab()
                                  : Container()))

                      // index == 0
                      //     ? Container(
                      //         color: backgroundColor,
                      //         child: MaterialsListTab(
                      //             materialsList: widget.module.moduleMaterial,
                      //             controller: _controller,
                      //             bloc: bloc),
                      //       )
                      //     : FileDownloadingTab(),
                      // child: TabBarView(
                      //   controller: _controller,
                      //   children: [
                      //     MaterialsListTab(
                      //         materialsList: widget.module.moduleMaterial,
                      //         controller: _controller,
                      //         bloc: bloc),
                      //     FileDownloadingTab(),
                      //   ],
                      // )

                      ),
                ),
              )

        // : Scaffold(
        //     backgroundColor: Theme.of(context).backgroundColor,
        //     appBar: AppBar(
        //       backgroundColor: backgroundColor,
        //       centerTitle: true,
        //       title: Text(
        //         widget.module.moduleName,
        //         overflow: TextOverflow.ellipsis,
        //         style: TextStyle(color: Colors.black),
        //       ),
        //       leading: IconButton(
        //         icon: Icon(CupertinoIcons.back),
        //         color: blackColor,
        //         onPressed: () {
        //           Navigator.of(context).pop();
        //         },
        //       ),
        //       actions: <Widget>[
        //         IconButton(
        //           icon: Icon(Icons.cloud_download),
        //           color: accentColor,
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (context) => OfflinePage(
        //                     moduleName: widget.module.moduleName)));
        //           },
        //         ),
        //       ],
        //     ),
        //     body: TabBarView(
        //       controller: _controller,
        //       children: [
        //         MaterialsListTab(
        //             materialsList: widget.module.moduleMaterial,
        //             controller: _controller,
        //             bloc: bloc),
        //         FileDownloadingTab(),
        //       ],
        //     ),
        //     bottomNavigationBar: StreamBuilder(
        //       stream: bloc.currentIndex,
        //       initialData: 0,
        //       builder: (context, snapshot) => BottomNavigationBar(
        //           type: BottomNavigationBarType.fixed,
        //           currentIndex: snapshot.hasData ? snapshot.data : 0,
        //           items: [
        //             BottomNavigationBarItem(
        //               icon: Icon(Icons.list),
        //               title: Text('Materials'),
        //             ),
        //             BottomNavigationBarItem(
        //               icon: Icon(Icons.file_download),
        //               title: Text('Dowloading'),
        //             ),
        //           ],
        //           onTap: (index) {
        //             _controller.animateTo(index);
        //             bloc.setCurrentIndex.add(index);
        //           }),
        //     ),
        //   )

        ///START
        // Material(
        //     child: CupertinoTabScaffold(
        //       tabBar: CupertinoTabBar(items: <BottomNavigationBarItem>[
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.list,
        //             size: 18.0,
        //           ),
        //           title: Text('Materials'),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.file_download,
        //             size: 18.0,
        //           ),
        //           title: Text('Downloading'),
        //         ),
        //       ]),
        //       tabBuilder: (context, index) => CupertinoPageScaffold(
        //           navigationBar: CupertinoNavigationBar(
        //             middle: Text(
        //               widget.module.moduleName,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             trailing: IconButton(
        //               icon: Icon(Icons.cloud_download),
        //               onPressed: () {
        //                 Navigator.of(context).push(MaterialPageRoute(
        //                     builder: (context) => OfflinePage(
        //                         moduleName: widget.module.moduleName)));
        //               },
        //             ),
        //           ),
        //           child: index == 0
        //               ? MaterialsListTab(
        //                   materialsList: widget.module.moduleMaterial,
        //                   controller: _controller,
        //                   bloc: bloc)
        //               : FileDownloadingTab()),
        //     ),
        //   )
        ///END
        //     tabBar: CupertinoTabBar(
        //       items: <BottomNavigationBarItem>[
        //         BottomNavigationBarItem(
        //           icon: Icon(FontAwesomeIcons.file),
        //           title: Text('Materials'),
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Icon(FontAwesomeIcons.levelDownAlt),
        //           title: Text('Downloading'),
        //         ),
        //       ],
        //     ),
        // navigationBar: CupertinoNavigationBar(
        //   middle: Text(widget.module.moduleName),
        //   backgroundColor: Theme.of(context).backgroundColor,
        // ),

        // child:CupertinoTabView(
        //   controller: _controller,
        //   children: [
        //     MaterialsListTab(
        //         materialsList: widget.module.moduleMaterial,
        //         controller: _controller,
        //         bloc: bloc),
        //     FileDownloadingTab(),
        //   ],
        // ),
        // )
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
  final GlobalKey<AppExpansionTileState2> acadYearExpansionTile =
      new GlobalKey();
  final GlobalKey<AppExpansionTileState> materialTypeExpansionTile =
      new GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print('Rebuild Materials List Tab');

    Map<int, String> _academicYearsList = {};
    _academicYearsList[19] = '2018/2019';
    _academicYearsList[18] = '2017/2018';
    _academicYearsList[17] = '2016/2017';

    List<String> _learningMaterialTypes = <String>[
      'Lectures',
      'Seminars',
      'Other',
      // 'Courseworks'
    ];

    double halfWidth = (MediaQuery.of(context).size.width / 2) - 24.0;

    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 6.0, top: 10.0),
                color: backgroundColor,
                child: SizedBox(
                  width: halfWidth,
                  child: StreamBuilder(
                    initialData: _academicYearsList[19],
                    stream: widget.bloc.academicYearStream,
                    builder: (context, snapshot) => SafeArea(
                          bottom: false,
                          child: LearningMaterialsAcademicYearExpansionTile(
                              bloc: widget.bloc,
                              expansionTile: acadYearExpansionTile,
                              expansionChildrenList: _academicYearsList),
                        ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 6.0, top: 10.0),
                color: backgroundColor,
                child: SizedBox(
                  width: halfWidth,
                  child: StreamBuilder(
                    initialData: _learningMaterialTypes[0].toString(),
                    stream: widget.bloc.learningMaterialType,
                    builder: (context, snapshot) => SafeArea(
                          bottom: false,
                          child: LearningMaterialsExpansionTile(
                              bloc: widget.bloc,
                              expansionTile: materialTypeExpansionTile,
                              expansionChildrenList: _learningMaterialTypes),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<List<SingleLearningMaterialsModel>>(
            stream: widget.bloc.materialsList,
            builder: (context, snapshot) => snapshot.hasData
                ? snapshot.data.length > 0
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: LearningMaterialsCard(
                                    learningMaterialsModel:
                                        snapshot.data[index],
                                    controller: widget.controller,
                                    bloc: widget.bloc),
                              );
                            } else if (index == snapshot.data.length - 1) {
                              return SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: LearningMaterialsCard(
                                      learningMaterialsModel:
                                          snapshot.data[index],
                                      controller: widget.controller,
                                      bloc: widget.bloc),
                                ),
                              );
                            } else {
                              return LearningMaterialsCard(
                                learningMaterialsModel: snapshot.data[index],
                                controller: widget.controller,
                                bloc: widget.bloc,
                              );
                            }
                          },
                          childCount: snapshot.data.length,
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Center(child: Text(noFilesToDownload))))
                : SliverToBoxAdapter(
                    child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: DrawPlatformCircularIndicator())))
        // itemCount: widget.materialsList.length,
        // itemBuilder:
        // (context, index) => index == 0
        //     ? Padding(
        //         padding: const EdgeInsets.only(top: 8.0),
        //         child: LearningMaterialsCard(
        //             learningMaterialsModel: widget.materialsList[index],
        //             controller: widget.controller,
        //             bloc: widget.bloc),
        //       )
        //     : LearningMaterialsCard(
        //         learningMaterialsModel: widget.materialsList[index],
        //         controller: widget.controller,
        //         bloc: widget.bloc,
        //       )),
      ],
    );
  }
}

class FileDownloadingTab extends StatefulWidget {
  @override
  _FileDownloadingTabState createState() => _FileDownloadingTabState();
}

class _FileDownloadingTabState extends State<FileDownloadingTab>
    with AutomaticKeepAliveClientMixin {
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
        downloadFile.folderName =
            _getMaterialType(learningMaterialsModel.materialTypeID) +
                '/' +
                learningMaterialsModel.title;

        _listOfWidgets.add(CustomSimpleDialogOption(
          controller: controller,
          downloadFile: downloadFile,
          bloc: bloc,
          flushBar: bloc.flushBar,
        ));
      }
    } else {
      _listOfWidgets.add(Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(noFilesToDownload),
          ),
        ),
      ));
    }

    if (Platform.isAndroid) {
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
    }

    return _listOfWidgets;
  }

  String _getMaterialType(typeID) {
    if (typeID == 1) {
      return 'Lectures';
    } else if (typeID == 2) {
      return 'Seminars';
    } else if (typeID == 3) {
      return 'Other';
    }
    return '';
  }

  _showDialogToDownload(BuildContext context) async {
    var bloc = LearningMaterialsProvider.of(context);

    if (Platform.isAndroid) {
      try {
        Permission permission = Permission.WriteExternalStorage;
        bool result = await SimplePermissions.checkPermission(permission);
        if (result) {
          await showDialog(
              context: context,
              builder: (context) {
                return FutureBuilder<List<DownloadFileModel>>(
                  future: bloc.getFileUrlsToDownload(
                      context, learningMaterialsModel.id),
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
                                        for (var downloadFile
                                            in snapshot.data) {
                                          downloadFile.folderName =
                                              _getMaterialType(
                                                      learningMaterialsModel
                                                          .materialTypeID) +
                                                  '/' +
                                                  learningMaterialsModel.title;

                                          bloc.addFileToDownload
                                              .add(downloadFile);
                                        }
                                        Navigator.pop(context);

                                        bloc.setCurrentIndex.add(1);
                                        controller.animateTo(1);
                                        bloc.flushBar.show(context);
                                      })
                                  : Container()
                            ],
                          ),
                          children: _getDialogItems(context, snapshot.data))
                      : DrawPlatformCircularIndicator(),
                );
              });
        } else {
          bool result2 = await SimplePermissions.requestPermission(permission);

          if (result2) {
            await showDialog(
                context: context,
                builder: (context) {
                  return FutureBuilder<List<DownloadFileModel>>(
                    future: bloc.getFileUrlsToDownload(
                        context, learningMaterialsModel.id),
                    builder: (context, snapshot) => snapshot.hasData
                        ? SimpleDialog(
                            titlePadding: EdgeInsets.only(
                                top: 15.0,
                                left: 24.0,
                                right: 24.0,
                                bottom: 5.0),
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
                                          for (var downloadFile
                                              in snapshot.data) {
                                            downloadFile
                                                .folderName = _getMaterialType(
                                                    learningMaterialsModel
                                                        .materialTypeID) +
                                                '/' +
                                                learningMaterialsModel.title;

                                            bloc.addFileToDownload
                                                .add(downloadFile);
                                          }
                                          Navigator.pop(context);

                                          bloc.setCurrentIndex.add(1);
                                          controller.animateTo(1);
                                          bloc.flushBar.show(context);
                                        })
                                    : Container()
                              ],
                            ),
                            children: _getDialogItems(context, snapshot.data))
                        : DrawPlatformCircularIndicator(),
                  );
                });
          }
        }
      } catch (e) {}
    } else {
      // await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return FutureBuilder<List<DownloadFileModel>>(
      //         future: bloc.getFileUrlsToDownload(
      //             context, learningMaterialsModel.id),
      //         builder: (context, snapshot) => snapshot.hasData
      //             ? CupertinoAlertDialog(
      //                 title: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: <Widget>[
      //                     Theme(
      //                         data: ThemeData(platform: TargetPlatform.iOS),
      //                         child: Text('Download')),
      //                     snapshot.data.length > 1
      //                         ? Material(
      //                             color: Colors.transparent,
      //                             child: InkWell(
      //                                 child: Padding(
      //                                   padding: const EdgeInsets.all(8.0),
      //                                   child: Icon(Icons.cloud_download),
      //                                 ),
      //                                 onTap: () {
      //                                   for (var downloadFile
      //                                       in snapshot.data) {
      //                                     downloadFile.folderName =
      //                                         _getMaterialType(
      //                                                 learningMaterialsModel
      //                                                     .materialTypeID) +
      //                                             '/' +
      //                                             learningMaterialsModel.title;

      //                                     bloc.addFileToDownload
      //                                         .add(downloadFile);
      //                                   }
      //                                   Navigator.pop(context);

      //                                   bloc.setCurrentIndex.add(1);
      //                                   controller.animateTo(1);
      //                                   bloc.flushBar.show(context);
      //                                 }),
      //                           )
      //                         : Container()
      //                   ],
      //                 ),
      //                 content: Material(
      //                   color: Colors.transparent,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: _getDialogItems(context, snapshot.data),
      //                   ),
      //                 ),
      //                 actions: <Widget>[
      //                   CupertinoDialogAction(
      //                     isDestructiveAction: true,
      //                     child: Text('Cancel'.toUpperCase()),
      //                     onPressed: () {
      //                       Navigator.of(context).pop();
      //                     },
      //                   ),
      //                 ],
      //               )
      //             : Center(
      //                 child: Platform.isAndroid
      //                     ? CircularProgressIndicator()
      //                     : CupertinoActivityIndicator()),
      //       );
      //     });

      await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) =>
              FutureBuilder<List<DownloadFileModel>>(
                  future: bloc.getFileUrlsToDownload(
                      context, learningMaterialsModel.id),
                  builder: (context, snapshot) => snapshot.hasData
                      ? CupertinoActionSheet(
                          title:
                              Text('Download ' + learningMaterialsModel.title),

                          actions: _getDialogItems(context, snapshot.data),
                          // <Widget>[
                          //   CupertinoActionSheetAction(
                          //     onPressed: () {},
                          //     child: Text('Lecture 1.pptx'),
                          //   ),
                          //   CupertinoActionSheetAction(
                          //     onPressed: () {},
                          //     child: Text('Lecture 1.docx'),
                          //   ),
                          //   CupertinoActionSheetAction(
                          //     onPressed: () {},
                          //     child: Text('Lecture 1.txt'),
                          //   )
                          // ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () {
                              for (var downloadFile in snapshot.data) {
                                downloadFile.folderName = _getMaterialType(
                                        learningMaterialsModel.materialTypeID) +
                                    '/' +
                                    learningMaterialsModel.title;

                                bloc.addFileToDownload.add(downloadFile);
                              }
                              Navigator.pop(context);

                              bloc.setCurrentIndex.add(1);
                              controller.animateTo(1);
                              bloc.flushBar.show(context);
                            },
                            child: Text('Download All'),
                          ),
                        )
                      : Center(
                          child: Platform.isAndroid
                              ? CircularProgressIndicator()
                              : CupertinoActivityIndicator())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.0, color: whiteColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () => _showDialogToDownload(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(
              learningMaterialsModel.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: lightGreyTextColor, fontSize: 16.0),
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
    if (Platform.isAndroid) {
      return ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 20.0 : 0.0),
        onTap: () {
          bloc.addFileToDownload.add(downloadFile);
          Navigator.pop(context);

          bloc.setCurrentIndex.add(1);
          controller.animateTo(1);
          flushBar.show(context);
        },
        leading: Platform.isAndroid
            ? Icon(
                Icons.file_download,
                color: lightGreyTextColor,
              )
            : Icon(
                IconData(0xF41F, fontFamily: 'CuperIcon'),
                size: 26.0,
                color: lightGreyTextColor,
              ),
        title: Text(
          downloadFile.fileName,
          style: TextStyle(color: lightGreyTextColor),
        ),
      );
    } else {
      return CupertinoActionSheetAction(
        onPressed: () {
          bloc.addFileToDownload.add(downloadFile);
          Navigator.pop(context);

          bloc.setCurrentIndex.add(1);
          controller.animateTo(1);
          flushBar.show(context);
        },
        child: Text(downloadFile.fileName),
      );
    }
  }
}
