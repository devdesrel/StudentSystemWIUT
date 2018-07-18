import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_system_flutter/bloc/new_post_bloc.dart';
import 'package:student_system_flutter/bloc/new_post_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class TweetPage extends StatefulWidget {
  @override
  _TweetPageState createState() => _TweetPageState();
}

class _TweetPageState extends State<TweetPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = NewPostBloc();

    List<Widget> widgetsList = <Widget>[
      SliverToBoxAdapter(
        child: TextFormField(
          controller: TextEditingController(),
          autofocus: false,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Share your ideas',
          ),
        ),
      ),
      CustomGridView(context, bloc).build()
      //TODO

      // snapshot.hasData
      //     ? ListView(
      //         children: snapshot.data
      //             .map((item) => Image.file(
      //                   item,
      //                   width: 300.0,
      //                   height: 200.0,
      //                 ))
      //             .toList())
      //     // ListView.builder(
      //     //     itemBuilder: (context, index) => Image.file(
      //     //           snapshot.data[index],
      //     //           width: 300.0,
      //     //           height: 200.0,
      //     //         ),
      //     // itemCount: snapshot.data.length,
      //     // )
      //     : Container)
    ];
    return NewPostProvider(
      newPostBloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
          iconTheme: IconThemeData(color: whiteColor),
          elevation: 0.0,
          backgroundColor: accentColor,
          // title: Text(
          //   'Tweet',
          //   style: TextStyle(color: Theme.of(context).accentColor),
          // ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
            ),
          ),
          // actions: <Widget>[
          //     Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Text(
          //       'send'.toUpperCase(),
          //       //style: TextStyle(color: Theme.of(context).accentColor),
          //       style: TextStyle(fontSize: 24.0, color: accentColor),
          //     ),
          //   )
          //   // FloatingActionButton(
          //   //     child: Text('Tweet'),
          //   //     backgroundColor: accentColor,
          //   //     //shape:BoxShape.rectangle(Border),
          //   //     onPressed: () {}),
          // ],
        ),
        body: CustomScrollView(
          //padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          slivers: widgetsList,

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   //crossAxisAlignment: CrossAxisAlignment.end,
          //   children: <Widget>[
          //     Icon(Icons.perm_media),
          //     Icon(Icons.gif),
          //     Icon(Icons.pie_chart),
          //     Icon(Icons.perm_media),
          //     SizedBox(
          //       width: 10.0,
          //     ),
          //     Icon(Icons.check_circle_outline),
          //     Icon(Icons.add)
          //   ],
          // )
        ),
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
          onPressed: () => debugPrint("Pressed"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
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
    //var bloc = NewPostProvider.of(context);
    return SizedBox(
      height: 20.0,
      child: IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: Icon(icon),
          onPressed: () {
            switch (type) {
              case AttachmentTypes.CAMERA:
                getImage(true);
                //getImage(imagepath) => bloc.addWidget.add(imagepath);
                break;
              case AttachmentTypes.GALLERY:
                getImage(false);
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

  void setState(Function param0) {}
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
            debugPrint('Nothting thereee');
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
        children: getList());

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
    //   })
  }
}
