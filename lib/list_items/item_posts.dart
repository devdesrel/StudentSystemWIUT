import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:student_system_flutter/models/social_content_model.dart';
// import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../pages/image_detail_page.dart';

class ItemPosts extends StatelessWidget {
  final SocialContentModel model;
  ItemPosts({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: CustomCard(
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              CardHeader(model),
              CardBody(model),
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
  bool _isPlaying = false;
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
    // TODO: implement dispose
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

  CardHeader(this.model);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 22.0,
            backgroundImage: CachedNetworkImageProvider(
                'https://picsum.photos/100/100/?random'),
            child: Text(model.userName[0]),
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
                    model.postedDate,
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

  CardBody(this.model);
  @override
  Widget build(BuildContext context) {
    final iconSize = 18.0;
    final Icon postLikeIcon = Icon(FontAwesomeIcons.heart);
    final Icon postLikedIcon = Icon(FontAwesomeIcons.solidHeart);

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

      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: <Widget>[
      //     new SizedBox(
      //       height: iconSize,
      //       child: IconButton(
      //         padding: const EdgeInsets.all(0.0),
      //         onPressed: () {},
      //         icon: model.isLiked ? postLikedIcon : postLikeIcon,
      //         //icon: IconData (f442, fontFamily: CuperIcon),
      //         //TextStyle(CuperIcon ),
      //         iconSize: iconSize,
      //         color: accentColor,
      //       ),
      //     ),
      //     new SizedBox(
      //       height: iconSize,
      //       child: IconButton(
      //         padding: const EdgeInsets.all(0.0),
      //         onPressed: () {
      //           Navigator.of(context).pushNamedpp(commentsPage);
      //         },
      //         icon: Icon(FontAwesomeIcons.comment),
      //         iconSize: iconSize,
      //         color: accentColor,
      //       ),
      //     ),
      //     new SizedBox(
      //       height: iconSize,
      //       child: IconButton(
      //         padding: const EdgeInsets.all(0.0),
      //         onPressed: () {},
      //         icon: Icon(Icons.share),
      //         iconSize: iconSize,
      //         color: accentColor,
      //       ),
      //     )
      //   ],
      // ),

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ImageDetailPage(
                    tag: '$fileUrl', widget: ImageBox(fileUrl: fileUrl))));
      },
      child: Hero(
        tag: '$fileUrl',
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
    return Row(
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
    );
  }
}

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
