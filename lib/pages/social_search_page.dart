import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/social/social_search_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/social_search_model.dart';
import 'package:student_system_flutter/pages/social_test_page.dart';

class SocialSearchPage extends StatefulWidget {
  @override
  _SocialSearchPageState createState() => _SocialSearchPageState();
}

class _SocialSearchPageState extends State<SocialSearchPage> {
  @override
  Widget build(BuildContext context) {
    // double _screenWidth = MediaQuery.of(context).size.width;
    SocialSearchBloc bloc = SocialSearchBloc();
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: Container(
                  // width: _screenWidth * 0.8,
                  width: double.infinity,
                  child: TextField(
                    onChanged: (text) => bloc.setSearchQuery.add(text),
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: Theme.of(context).accentColor,
                        decorationColor: Colors.white),
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            gapPadding: 3.0,
                            borderSide: BorderSide(
                                color: Colors.white, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8.0)),
                        suffixIcon: IconButton(
                            icon: Icon(CupertinoIcons.clear_circled),
                            onPressed: () {})),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<SocialSearchModel>>(
                    stream: bloc.searchResult,
                    builder: (context, snapshot) => snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SocialProfileTestPage(
                                            userId: snapshot.data[index].id
                                                .toString(),
                                          )));
                                },
                                child: snapshot.data[index] ==
                                        snapshot.data.last
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          fileBaseUrl +
                                                              snapshot
                                                                  .data[index]
                                                                  .avatarUrl),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(snapshot
                                                        .data[index].firstName),
                                                    Text(' '),
                                                    Text(snapshot
                                                        .data[index].lastName)
                                                  ],
                                                ),
                                                // subtitle: RaisedButton(
                                                //   child: Text('Follow'),
                                                //   onPressed: () {},
                                                // ),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: lightGreyTextColor,
                                                      width: 0.09),
                                                  color: whiteColor),
                                            ),
                                            RaisedButton(
                                              child: Text('Load more'),
                                              onPressed: () {
                                                bloc.incrementPageNumber.add(1);
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100.0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        // color: whiteColor,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    fileBaseUrl +
                                                        snapshot.data[index]
                                                            .avatarUrl),
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(snapshot
                                                  .data[index].firstName),
                                              Text(' '),
                                              Text(
                                                  snapshot.data[index].lastName)
                                            ],
                                          ),
                                          // subtitle: RaisedButton(
                                          //   child: Text('Follow'),
                                          //   onPressed: () {},
                                          // ),
                                        ),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: lightGreyTextColor,
                                                width: 0.09),
                                            color: whiteColor),
                                      )))
                        : Container()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
