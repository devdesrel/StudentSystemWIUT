import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/app_constants.dart';
import '../helpers/ui_helpers.dart';
import '../pages/image_detail_page.dart';

class ItemPosts extends StatelessWidget {
  final positionIndex;

  ItemPosts({Key key, this.positionIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
        child: PostCard(
          position: positionIndex,
        ),
      );
}

class PostCard extends StatelessWidget {
  final position;

  PostCard({Key key, this.position}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          CardHeader(position),
          CardBody(position),
        ]),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final position;

  CardHeader(this.position);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 22.0,
            backgroundImage: CachedNetworkImageProvider(
                'https://picsum.photos/100/100/?random'),
            child: Text("A"),
          ),
          Container(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "What is Lorem Ipsum? $position",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Container(height: 2.0),
                Row(children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 16.0,
                  ),
                  Text(
                    'John Doe',
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
                    '16 May 2018',
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
  final position;

  CardBody(this.position);
  @override
  Widget build(BuildContext context) {
    final iconSize = 18.0;
    final Icon postLikeIcon = Icon(FontAwesomeIcons.heart);

    // final heartIcon = const IconData(442, fontFamily: CuperIcon);
    // final heartIcon = const IconData(442, fontFamily: CuperIcon);
    return Column(children: <Widget>[
      Divider(
        color: Theme.of(context).accentColor,
      ),
      Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.0, letterSpacing: 1.0),
      ),
      Container(height: 10.0),
      GestureDetector(
        child: Hero(
          tag: 'imageHero$position',
          child: Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      'https://picsum.photos/520/300/?random'),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ImageDetailPage(position)));
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
              icon: postLikeIcon,
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
      Center(
        child: CachedNetworkImage(
          placeholder: CircularProgressIndicator(),
          imageUrl: 'https://picsum.photos/520/300/?random',
          fit: BoxFit.fill,
        ),
      ),
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
