import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:student_system_flutter/models/social_content_model.dart';

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

class CardBody extends StatelessWidget {
  final SocialContentModel model;

  CardBody(this.model);
  @override
  Widget build(BuildContext context) {
    final iconSize = 18.0;
    final Icon postLikeIcon = Icon(FontAwesomeIcons.heart);
    final Icon postLikedIcon = Icon(FontAwesomeIcons.solidHeart);

    final _widget = Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: CachedNetworkImageProvider(
                'https://picsum.photos/520/300/?random'),
            fit: BoxFit.fitHeight,
            alignment: Alignment.topLeft),
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );

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
      GestureDetector(
        child: Hero(tag: 'imageHero$model.id', child: _widget),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ImageDetailPage(
                      tag: 'imageHero$model.id', widget: _widget)));
        },
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new SizedBox(
            height: iconSize,
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {},
              icon: model.isLiked ? postLikedIcon : postLikeIcon,
              //icon: IconData (f442, fontFamily: CuperIcon),
              //TextStyle(CuperIcon ),
              iconSize: iconSize,
              color: accentColor,
            ),
          ),
          new SizedBox(
            height: iconSize,
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.of(context).pushNamed(commentsPage);
              },
              icon: Icon(FontAwesomeIcons.comment),
              iconSize: iconSize,
              color: accentColor,
            ),
          ),
          new SizedBox(
            height: iconSize,
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {},
              icon: Icon(Icons.share),
              iconSize: iconSize,
              color: accentColor,
            ),
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
