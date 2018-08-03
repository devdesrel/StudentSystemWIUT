import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/bloc/new_post_page/new_post_bloc.dart';
import 'package:student_system_flutter/bloc/new_post_page/new_post_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class NewPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var bloc = NewPostBloc();

    return NewPostProvider(
      // newPostBloc: bloc,
      child: CustomScaffold(),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = NewPostProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Post'),
        iconTheme: IconThemeData(color: whiteColor),
        elevation: 0.0,
        backgroundColor: accentColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.close,
          ),
        ),
      ),
      body: CustomBody(bloc: bloc),
      // body: Column(
      //   children: <Widget>[
      //     TextFormField(
      //       autofocus: false,
      //       maxLines: null,
      //       keyboardType: TextInputType.text,
      //       decoration: InputDecoration(
      //         border: InputBorder.none,
      //         contentPadding:
      //             EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      //         hintText: 'Share your ideas',
      //       ),
      //     ),
      //     Expanded(
      //         child: StreamBuilder(
      //             stream: bloc.postItems,
      //             builder: (context, snapshot) {
      //               if (snapshot.hasData && snapshot.data.length > 0) {
      //                 // imagesList = snapshot.data.toList();
      //                 return GridView.count(
      //                     crossAxisCount: 2,
      //                     children: snapshot.data.map((item) => Image.file(
      //                           item,
      //                           width: 250.0,
      //                           height: 400.0,
      //                         )));
      //               } else {
      //                 print('Nothting thereee');
      //                 return Container();
      //               }
      //             }))
      //   ],
      // ),
      bottomNavigationBar: BottomAppBar(
        color: accentColor,
        hasNotch: true,
        elevation: 5.0,
        child: Theme(
          data: ThemeData(
              iconTheme: IconThemeData(color: whiteColor, size: 20.0)),
          child: ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              CustomSizedBox(
                icon: FontAwesomeIcons.camera,
                type: AttachmentTypes.CAMERA,
              ),
              // getImage: getImage(true)
              CustomSizedBox(
                icon: FontAwesomeIcons.image,
                type: AttachmentTypes.GALLERY,
              ),
              CustomSizedBox(
                  icon: FontAwesomeIcons.tasks,
                  type: AttachmentTypes.QUESTIONNAIRE),
              CustomSizedBox(
                  icon: Icons.attach_file, type: AttachmentTypes.FILE),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () => print("Pressed"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class CustomBody extends StatelessWidget {
  const CustomBody({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final NewPostBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextFormField(
        autofocus: false,
        maxLines: null,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          hintText: 'Share your ideas',
        ),
      ),
      StreamBuilder(
          stream: bloc.postItems,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              // imagesList = snapshot.data.toList();
              return Expanded(
                child: GridView.count(
                    crossAxisCount: snapshot.data.length > 2 ? 3 : 2,
                    children: snapshot.data
                        .map<Widget>((File item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 5.0),
                              child: Image.file(
                                item,
                                width: 250.0,
                                height: 400.0,
                              ),
                            ))
                        .toList()),
              );

              // <Widget>[
              //   Image.file(
              //     snapshot.data[0],
              //     width: 250.0,
              //     height: 400.0,
              //   )
              // ],
              // );

            } else {
              print('Nothting thereee');
              return Container();
            }
          })
    ]);
  }
}

class CustomSizedBox extends StatelessWidget {
  final IconData icon;
  final AttachmentTypes type;
  //File _image;
  // final Future getImage;

  CustomSizedBox({Key key, @required this.icon, @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bloc = NewPostProvider.of(context);
    //var bloc = NewPostProvider.of(context);
    return SizedBox(
      height: 20.0,
      child: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: Icon(icon),
          onPressed: () async {
            switch (type) {
              case AttachmentTypes.CAMERA:
                File file = await getImage(true);
                if (file != null) {
                  _bloc.addWidget.add(file);
                }
                //getImage(imagepath) => bloc.addWidget.add(imagepath);
                break;
              case AttachmentTypes.GALLERY:
                File file = await getImage(false);
                if (file != null) {
                  _bloc.addWidget.add(file);
                }
                //getImage(imageName) => bloc.addWidget.add('Image is here');
                break;
              case AttachmentTypes.QUESTIONNAIRE:
                print('Get QUESTIONNAIRE');
                break;
              case AttachmentTypes.FILE:
                print('Get Files');
                break;
              default:
                print('Default');
                break;
            }
          }),
    );
  }

  // void setState(Function param0) {}
}

class CustomGridView {
  BuildContext context;
  NewPostBloc bloc;
  CustomGridView(this.context, this.bloc);

  List<Widget> getList() {
    List<Widget> imagesList = [];

    StreamBuilder<List<File>>(
        stream: bloc.postItems,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            // imagesList = snapshot.data.toList();

            snapshot.data.map((item) => imagesList.add(Image.file(
                  item,
                  width: 250.0,
                  height: 400.0,
                )));
          } else {
            print('Nothting thereee');
          }
        });
    return imagesList;
  }

  Widget build() {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.55;

    return SliverGrid.count(
        childAspectRatio: (itemWidth / itemHeight), //0.85
        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          Text('NJJKLOK'),
          Text('NJJKLOK'),
          Text('NJJKLOK'),
          Text('NJJKLOK'),
        ]);
    // getList());

    //     StreamBuilder<List<File>>(
    // stream: bloc.postItems,
    // builder: (context, snapshot) {
    //   if (snapshot.hasData && snapshot.data.length > 0) {
    //         snapshot.data
    //             .map((item) => Image.file(
    //                   item,
    //                   width: 250.0,
    //                   height: 400.0,
    //                 ))
    //             .toList()
    // })
  }
}
