import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:student_system_flutter/bloc/social/social_bloc.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/social_content_model.dart';
// import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:student_system_flutter/pages/comments_page.dart';
import 'package:video_player/video_player.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../pages/image_detail_page.dart';

class ItemPosts extends StatelessWidget {
  final SocialContentModel model;
  final bool isLast;
  final SocialBloc bloc;
  final String avatarUrl;
  ItemPosts(
      {Key key,
      @required this.model,
      @required this.isLast,
      @required this.bloc,
      @required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: CustomCard(
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              CardHeader(model, avatarUrl),
              CardBody(model, bloc),
              isLast
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text('Load more'),
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                        ),
                        onPressed: () {
                          bloc.incrementContentPageNumber.add(1);
                        },
                      ),
                    )
                  : Container(
                      height: 0.0,
                    ),
            ]),
          ),
        ),
      );
}

class VideoBox extends StatefulWidget {
  final String fileUrl;
  VideoBox({this.fileUrl});
  @override
  _VideoBoxState createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  // bool _isPlaying = false;
  // VideoPlayerController get _controller =>
  //     // VideoPlayerController.network(fileBaseUrl + widget.fileUrl)
  //     VideoPlayerController.network(fileBaseUrl +
  //         'Uploads/SocialFilePath/e714717e-0a60-49fc-ad2b-d5b87d4b43d0.mp4')
  //       ..addListener(() {
  //         final bool isPlaying = _controller.value.isPlaying;
  //         if (isPlaying != _isPlaying) {
  //           setState(() {
  //             _isPlaying = isPlaying;
  //           });
  //         }
  //       })
  //       ..initialize().then((_) {
  //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //         setState(() {});
  //       });

  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        new VideoPlayerController.network(fileBaseUrl + widget.fileUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Chewie(
      _controller,
      aspectRatio: 3 / 2,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
    ));
  }
}

// class PostCard extends StatelessWidget {
//   final SocialContentModel model;

//   PostCard({Key key, this.model}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomCard(
//       Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(children: <Widget>[
//           CardHeader(model),
//           CardBody(model),
//         ]),
//       ),
//     );
//   }
// }

class CardHeader extends StatelessWidget {
  final SocialContentModel model;
  final String avatarUrl;

  CardHeader(this.model, this.avatarUrl);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 22.0,
            backgroundImage: CachedNetworkImageProvider(
                // 'https://picsum.photos/100/100/?random'
                fileBaseUrl + avatarUrl),
            // child: Text(model.userName[0]
            // ),
          ),
          Container(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.userName,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Container(height: 2.0),
                Row(children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 16.0,
                  ),
                  Text(
                    model.userName,
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                  Container(width: 10.0),
                  Icon(
                    Icons.calendar_today,
                    size: 16.0,
                  ),
                  Text(
                    formatDate(model.postedDate),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic),
                  ),
                ]),
              ],
            ),
          ),
        ],
      );
}

// Future<String> postAuthData() async {
//   var response = await http.post(
//       Uri.encodeFull("http://newintranetapi.wiut.uz/api/Account/Authenticate"),
//       body: {"Username": "00003123", "Password": "frostym"},
//       headers: {"Accept": "application/json"});

//   print(response.body);
//   return response.body;
// }

getFilExtension(String fileUrl) {
  var extension = lookupMimeType(basename(fileUrl));
  var direction;

  switch (extension) {
    case 'image/jpeg':
      direction = ImageHero(fileUrl: fileUrl);
      break;
    case 'image/png':
      direction = ImageHero(fileUrl: fileUrl);
      break;
    case 'video/x-flv':
      direction = VideoBox(fileUrl: fileUrl);
      break;
    case 'video/mp4':
      direction = VideoBox(fileUrl: fileUrl);

      break;
    case 'application/x-mpegURL':
      direction = VideoBox(fileUrl: fileUrl);
      break;
    case 'video/MP2T':
      direction = VideoBox(fileUrl: fileUrl);
      break;
    case 'application/msword':
      //doc file
      direction = DocBox(fileUrl: fileUrl);
      break;
    case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      //docx file
      direction = DocBox(fileUrl: fileUrl);

      break;
    case 'application/vnd.ms-powerpoint':
      //ppt file
      direction = PptBox(fileUrl: fileUrl);
      break;
    case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      //pptx file
      direction = PptBox(fileUrl: fileUrl);
      break;
    case 'application/vnd.ms-excel':
      //xls file
      direction = ExcelBox(fileUrl: fileUrl);
      break;
    case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
      //xlsx file
      direction = ExcelBox(fileUrl: fileUrl);
      break;
    case 'application/pdf':
      //pdf file
      direction = PdfBox(fileUrl: fileUrl);
      break;
    case 'application/zip':
      //zip file
      direction = ZipBox(fileUrl: fileUrl);
      break;
    case 'application/x-rar-compressed':
      //rar file
      direction = RarBox(fileUrl: fileUrl);
      break;
    //TODO: open video plugin
    default:
      direction = Container(
        child: Center(child: Text("Other data type")),
      );
  }

  return direction;
}

class CardBody extends StatelessWidget {
  final SocialContentModel model;
  final SocialBloc bloc;

  CardBody(this.model, this.bloc);
  @override
  Widget build(BuildContext context) {
    final iconSize = 18.0;
    // final Icon postLikeIcon = Icon(
    //   IconData(0xF443, fontFamily: 'CuperIcon'),
    // );
    final Icon postLikeIcon = Icon(FontAwesomeIcons.heart);
    final Icon postLikedIcon = Icon(FontAwesomeIcons.solidHeart);
    final TextStyle postParametersStyle =
        TextStyle(color: textColor, fontSize: 10.0);

    // ImageHero(fileUrl: fil,);

    // final heartIcon = const IconData(442, fontFamily: CuperIcon);
    // final heartIcon = const IconData(442, fontFamily: CuperIcon);
    return Column(children: <Widget>[
      Divider(
        color: Theme.of(context).accentColor,
      ),
      Text(
        model.text,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.0, letterSpacing: 1.0),
      ),
      Container(height: 10.0),
      model.fileUrl != null
          ? getFilExtension(model.fileUrl.toString().substring(0))
          // ImageHero(
          //     fileUrl: model.fileUrl,
          //   )
          // ? GestureDetector(
          //     child: Hero(tag: 'imageHero$model.id', child: _widget),
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (_) => ImageDetailPage(
          //                   tag: 'imageHero$model.id', widget: _widget)));
          //     },
          //   )
          // : Container()
          : Container(),
      SizedBox(
        height: 10.0,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                model.likesCount != 0 ? model.likesCount.toString() : '',
                // 'likes',
                style: postParametersStyle,
              ),
              new SizedBox(
                height: iconSize,
                child: IconButton(
                  padding: const EdgeInsets.only(top: 3.0),
                  onPressed: () {
                    model.isLiked
                        ? bloc.postIdToUnlike.add(model.id)
                        : bloc.postIdToLike.add(model.id);
                  },
                  icon: model.isLiked ? postLikedIcon : postLikeIcon,
                  //icon: IconData (f442, fontFamily: CuperIcon),
                  //TextStyle(CuperIcon ),
                  iconSize: iconSize,
                  color: accentColor,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                  model.commentsCount != 0
                      ? model.commentsCount.toString()
                      : '',
                  // 'comments',
                  style: postParametersStyle),
              new SizedBox(
                  height: iconSize,
                  child: IconButton(
                    padding: const EdgeInsets.only(top: 3.0),
                    onPressed: () {
                      // bloc.postIdForComments.add(model.id);

                      // Navigator.of(context).pushNamed(commentsPage);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CommentsPage(
                                    postId: model.id,
                                  )));
                      // showBottomSheet(context, model.id);
                    },
                    icon: Icon(FontAwesomeIcons.comment),
                    iconSize: iconSize,
                    color: accentColor,
                  )),
            ],
          ),
          Column(
            children: <Widget>[
              Text('shares', style: postParametersStyle),
              new SizedBox(
                height: iconSize,
                child: IconButton(
                  padding: const EdgeInsets.only(top: 3.0),
                  onPressed: () {},
                  icon: Icon(Icons.share),
                  iconSize: iconSize,
                  color: accentColor,
                ),
              ),
            ],
          )
        ],
      ),
      // Center(
      //   child: CachedNetworkImage(
      //     placeholder: CircularProgressIndicator(),
      //     imageUrl: 'https://picsum.photos/520/300/?random',
      //     fit: BoxFit.fill,
      //   ),
      // ),
    ]);
  }
}

class ImageHero extends StatelessWidget {
  final fileUrl;
  const ImageHero({Key key, this.fileUrl}) : super(key: key);
  //  var time=TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ImageDetailPage(
                    tag: '$fileUrl/$time',
                    widget: ImageBox(fileUrl: fileUrl))));
      },
      child: Hero(
        tag: '$fileUrl/$time',
        child: ImageBox(fileUrl: fileUrl),
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({
    Key key,
    @required this.fileUrl,
  }) : super(key: key);

  final fileUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(fileBaseUrl + fileUrl),
            // 'https://picsum.photos/520/300/?random'),

            fit: BoxFit.fitHeight,
            alignment: Alignment.topLeft),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }
}

class DocBox extends StatelessWidget {
  final String fileUrl;
  DocBox({this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //TODO: implement save file and open file function
        // await getFile(fileUrl).then((response) {
        //   ImagePickerSaver.saveFile(fileData: response.bodyBytes);
        // });
        // ImagePickerSaver.saveFile(fileData: ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/file_manager_icons/doc.png",
            height: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: Text(
              basename(fileUrl),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// getFile(String fileUrl) async {
//   var response = await http.get(fileUrl).then((response) {
//     return response;
//   });
// }

class PptBox extends StatelessWidget {
  final String fileUrl;
  PptBox({this.fileUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          "assets/file_manager_icons/ppt.png",
          height: 20.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            basename(fileUrl),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ExcelBox extends StatelessWidget {
  final String fileUrl;
  ExcelBox({this.fileUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset("assets/file_manager_icons/xls.png", height: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            basename(fileUrl),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class PdfBox extends StatelessWidget {
  final String fileUrl;
  PdfBox({this.fileUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset("assets/file_manager_icons/pdf.png", height: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            basename(fileUrl),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ZipBox extends StatelessWidget {
  final String fileUrl;
  ZipBox({this.fileUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset("assets/file_manager_icons/zip.png", height: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            basename(fileUrl),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class RarBox extends StatelessWidget {
  final String fileUrl;
  RarBox({this.fileUrl});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          "assets/file_manager_icons/rar.png",
          height: 20.0,
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            basename(fileUrl),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
    //  ListTile(
    //   leading: Image.asset("assets/file_manager_icons/rar.png", height: 25.0),
    //   title: Text(basename(fileUrl)),
    // );
  }
}

// showBottomSheet(context, postId) {
//   double size = MediaQuery.of(context).size.height;
//   return showModalBottomSheet(
//       context: context,
//       builder: (context) => Platform.isAndroid
//           ? Container(
//               height: 900.0,
//               color: backgroundColor,
//               child: Column(children: <Widget>[
//                 Expanded(
//                   child: FutureBuilder<List<SocialCommentModel>>(
//                     future: getComments(postId),
//                     builder: (context, snapshot) => snapshot.hasData &&
//                             snapshot.data != null
//                         ? ListView.builder(
//                             itemCount: snapshot.data.length,
//                             shrinkWrap: true,
//                             itemBuilder: (context, index) =>
//                                 Column(children: <Widget>[
//                                   ListTile(
//                                       leading: CircleAvatar(
//                                         backgroundImage:
//                                             CachedNetworkImageProvider(
//                                                 fileBaseUrl +
//                                                     snapshot
//                                                         .data[index].avatarUrl),
//                                       ),
//                                       subtitle: CustomCard(Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text(
//                                                   snapshot
//                                                       .data[index].postedByName,
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       fontSize: 16.0),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 5.0,
//                                                 ),
//                                                 Text.rich(TextSpan(
//                                                     text: snapshot.data[index]
//                                                         .commentText,
//                                                     // text:
//                                                     //     "ghjkkjhghjkljhjklkjhghjklajskajksjaksjkajskajskajskajksjaksjakjskajskajksjaksjkajskajskajskajskajksjaksjaksjkajskajskajskajskajskajskajskjaksjaksjaksjaksjakjkjkjkjkjskasjkajskajskajskajskajskajskajskajskjaskjaksjaksjakjskajskajskajskajskajksjaksjaksjakjskajskajskajskajskajskajskajskajskajksjaksjaksjaksjakjsakjsakjskajsakjskasjkasj",
//                                                     style: TextStyle(
//                                                         color: textColor))),
//                                               ])))),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 25.0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: <Widget>[
//                                         Text(
//                                             getDateDifference(snapshot
//                                                 .data[index].postedDate),
//                                             style: TextStyle(color: textColor)),
//                                         SizedBox(
//                                           width: 10.0,
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: Text(
//                                             'Like',
//                                             textAlign: TextAlign.right,
//                                             style: TextStyle(fontSize: 15.5),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10.0,
//                                         ),
//                                         InkWell(
//                                           onTap: () {},
//                                           child: Text(
//                                             'Reply',
//                                             textAlign: TextAlign.right,
//                                             style: TextStyle(fontSize: 15.5),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ]))
//                         : DrawPlatformCircularIndicator(),
//                     // CustomCard(
//                     //     Center(
//                     //       child: Text(
//                     //           'You are the first, YAAAAY!\nLeave your comment'),
//                     //     ),
//                     //   ),
//                   ),
//                 ),
//                 Container(
//                   color: whiteColor,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 6.0, horizontal: 4.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: <Widget>[
//                       CustomSizedBox(
//                         icon: MdiIcons.camera,
//                         type: AttachmentTypes.CAMERA,
//                       ),
//                       // getImage: getImage(true)
//                       CustomSizedBox(
//                         icon: FontAwesomeIcons.image,
//                         type: AttachmentTypes.GALLERY,
//                         // getImage: getImage(false),
//                       ),
//                       Expanded(
//                         child: Container(
//                           constraints:
//                               BoxConstraints.loose(Size.fromHeight(100.0)),
//                           child: Theme(
//                             data: ThemeData(hintColor: greyColor),
//                             child: TextField(
//                                 maxLines: null,
//                                 keyboardType: TextInputType.multiline,
//                                 decoration: InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.only(
//                                       left: 10.0,
//                                       right: 10.0,
//                                       bottom: 10.0,
//                                       top: 0.0),
//                                   // border: OutlineInputBorder(
//                                   //     borderRadius: BorderRadius.circular(50.0)),
//                                   hintText: 'Comment',
//                                 )
//                                 // filled: true,
//                                 // fillColor: backgroundColor),
//                                 ),
//                           ),
//                         ),
//                       ),
//                       CustomSizedBox(
//                         icon: Icons.insert_emoticon,
//                         type: AttachmentTypes.STICKER,
//                       )
//                       //SEND BUTTON
//                       // FloatingActionButton(
//                       //   child: Icon(Icons.send),
//                       //   onPressed: () => debugPrint("Pressed"),
//                       //   //elevation: 4.0,
//                       // ),
//                       // TextField(),

//                       // TextField(),
//                       // Icon(Icons.insert_emoticon)
//                     ],
//                   ),
//                 ),
//               ]),
//             )
//           : Material(
//               color: Colors.transparent,
//               child: CupertinoPageScaffold(
//                 backgroundColor: backgroundColor,
//                 navigationBar: CupertinoNavigationBar(
//                   middle: Text('Comments'),
//                 ),
//                 child: Column(children: <Widget>[
//                   Expanded(
//                     child: FutureBuilder<List<SocialCommentModel>>(
//                       future: getComments(postId),
//                       builder: (context, shot) => shot.hasData &&
//                               shot.data != null
//                           ? ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: shot.data.length,
//                               itemBuilder: (context, index) =>
//                                   Column(children: <Widget>[
//                                     ListTile(
//                                         leading: CircleAvatar(
//                                           backgroundImage:
//                                               CachedNetworkImageProvider(
//                                                   fileBaseUrl +
//                                                       shot.data[index]
//                                                           .avatarUrl),
//                                         ),
//                                         subtitle: CustomCard(Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: <Widget>[
//                                                   Text(
//                                                     shot.data[index]
//                                                         .postedByName,
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: 16.0),
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5.0,
//                                                   ),
//                                                   Text.rich(TextSpan(
//                                                       text: shot.data[index]
//                                                           .commentText,
//                                                       // text:
//                                                       //     "ghjkkjhghjkljhjklkjhghjklajskajksjaksjkajskajskajskajksjaksjakjskajskajksjaksjkajskajskajskajskajksjaksjaksjkajskajskajskajskajskajskajskjaksjaksjaksjaksjakjkjkjkjkjskasjkajskajskajskajskajskajskajskajskjaskjaksjaksjakjskajskajskajskajskajksjaksjaksjakjskajskajskajskajskajskajskajskajskajksjaksjaksjaksjakjsakjsakjskajsakjskasjkasj",
//                                                       style: TextStyle(
//                                                           color: textColor))),
//                                                 ])))),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 25.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: <Widget>[
//                                           Text(
//                                               getDateDifference(
//                                                   shot.data[index].postedDate),
//                                               style:
//                                                   TextStyle(color: textColor)),
//                                           SizedBox(
//                                             width: 10.0,
//                                           ),
//                                           InkWell(
//                                             onTap: () {},
//                                             child: Text(
//                                               'Like',
//                                               textAlign: TextAlign.right,
//                                               style: TextStyle(fontSize: 15.5),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10.0,
//                                           ),
//                                           InkWell(
//                                             onTap: () {},
//                                             child: Text(
//                                               'Reply',
//                                               textAlign: TextAlign.right,
//                                               style: TextStyle(fontSize: 15.5),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ]))
//                           : DrawPlatformCircularIndicator(),
//                       // CustomCard(
//                       //     Center(
//                       //       child: Text(
//                       //           'You are the first, YAAAAY!\nLeave your comment'),
//                       //     ),
//                       //   ),
//                     ),
//                   ),
//                   Container(
//                     color: whiteColor,
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 6.0, horizontal: 4.0),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         CustomSizedBox(
//                           icon: Icons.camera,
//                           type: AttachmentTypes.CAMERA,
//                         ),
//                         // getImage: getImage(true)
//                         CustomSizedBox(
//                           icon: FontAwesomeIcons.image,
//                           type: AttachmentTypes.GALLERY,
//                           // getImage: getImage(false),
//                         ),
//                         Expanded(
//                           child: Container(
//                             constraints:
//                                 BoxConstraints.loose(Size.fromHeight(100.0)),
//                             child: Theme(
//                               data: ThemeData(hintColor: greyColor),
//                               child: TextField(
//                                   maxLines: null,
//                                   keyboardType: TextInputType.multiline,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 10.0,
//                                         right: 10.0,
//                                         bottom: 10.0,
//                                         top: 0.0),
//                                     // border: OutlineInputBorder(
//                                     //     borderRadius: BorderRadius.circular(50.0)),
//                                     hintText: 'Comment',
//                                   )
//                                   // filled: true,
//                                   // fillColor: backgroundColor),
//                                   ),
//                             ),
//                           ),
//                         ),
//                         CustomSizedBox(
//                           icon: Icons.insert_emoticon,
//                           type: AttachmentTypes.STICKER,
//                         )
//                         //SEND BUTTON
//                         // FloatingActionButton(
//                         //   child: Icon(Icons.send),
//                         //   onPressed: () => debugPrint("Pressed"),
//                         //   //elevation: 4.0,
//                         // ),
//                         // TextField(),

//                         // TextField(),
//                         // Icon(Icons.insert_emoticon)
//                       ],
//                     ),
//                   ),
//                 ]),
//               ),
//             ));
// }

// Future<List<SocialCommentModel>> getComments(int postId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String _token = prefs.getString(token);
//   // int postId = 1;
//   List<SocialCommentModel> _comments;
//   try {
//     Response response = await http.get('$apiSocialGetComments/$postId',
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $_token"
//         });
//     if (response.statusCode == 200) {
//       var parsed = json.decode(response.body);
//       _comments = parsed
//           .map<SocialCommentModel>((item) => SocialCommentModel.fromJson(item))
//           .toList();
//     } else {
//       _comments = null;
//     }
//   } catch (e) {
//     print(e);
//   }
//   return _comments;
// }

//  @override
// Widget build(BuildContext context) => Card(
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             CircleAvatar(
//               backgroundColor: Theme.of(context).accentColor,
//               radius: 22.0,
//               child: Text("A"),
//             ),
//             Container(width: 12.0),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "What is Lorem Ipsum? $position",
//                     style: TextStyle(
//                         fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                   Container(height: 2.0),
//                   Row(children: <Widget>[
//                     Icon(
//                       Icons.person,
//                       size: 16.0,
//                     ),
//                     Text(
//                       "John Doe",
//                       style: TextStyle(
//                           color: Theme.of(context).accentColor,
//                           fontSize: 12.0,
//                           fontStyle: FontStyle.italic),
//                     ),
//                     Container(width: 10.0),
//                     Icon(
//                       Icons.calendar_today,
//                       size: 16.0,
//                     ),
//                     Text(
//                       "16 May 2018",
//                       style: TextStyle(
//                           color: Theme.of(context).accentColor,
//                           fontSize: 12.0,
//                           fontStyle: FontStyle.italic),
//                     ),
//                   ]),
//                   Container(height: 10.0),
//                   Text(
//                     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
//                     style: TextStyle(fontSize: 12.0, letterSpacing: 1.0),
//                   ),
//                   Container(height: 10.0),
//                   Center(
//                     child: CachedNetworkImage(
//                       placeholder: CircularProgressIndicator(),
//                       imageUrl: 'https://picsum.photos/520/300/?random',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
