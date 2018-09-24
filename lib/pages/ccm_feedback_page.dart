import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_bloc.dart';
import 'package:student_system_flutter/bloc/ccm_feedback/ccm_feedback_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_carousel.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

class CCMFeedbackPage extends StatefulWidget {
  @override
  _CCMFeedbackPageState createState() => _CCMFeedbackPageState();
}

class _CCMFeedbackPageState extends State<CCMFeedbackPage> {
  var _bloc = CCMFeedbackBloc();
  // AnimationController _controller;
  // Animation _animation;

  // FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   super.initState();

  //   _controller =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  //   _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
  //     ..addListener(() {
  //       setState(() {});
  //     });

  //   _focusNode.addListener(() {
  //     if (_focusNode.hasFocus) {
  //       _controller.forward();
  //     } else {
  //       _controller.reverse();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   _focusNode.dispose();

  //   super.dispose();
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: false,
//       appBar: AppBar(
//         title: Text('CCM Feedback'),
//         centerTitle: true,
//       ),
//       backgroundColor: backgroundColor,
//       body: Center(
//         child: CCMCarousel(
//           isDotIndicatorBottom: false,
//           dotColor: accentColor,
//           autoplay: false,
//           images: <Widget>[
//             SingleChildScrollView(
//               child: Column(children: <Widget>[
//                 Container(
//                   height: MediaQuery.of(context).size.height / 3,
//                   child: Center(
//                       child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Fundamentals of programming',
//                       style: TextStyle(fontSize: 18.0),
//                     ),
//                   )),
//                 ),
//                 // Text('hjjshjfbsajdhjsafjhsajfbjha'),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       FlatButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Positive comments',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         color: accentColor,
//                       ),
//                       FlatButton(
//                         onPressed: () {},
//                         child: Text(
//                           'Suggestions',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         color: accentColor,
//                       )
//                     ]),

//                 Column(
//                   children: <Widget>[
//                     ListView(
//                       children: <Widget>[
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                         Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ]),
//             ),
//             SingleChildScrollView(
//                 child: Column(children: <Widget>[
//               Center(
//                   child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Marketing Communication'),
//               )),
//               Text('hjjshjfbsajdhjsafjhsajfbjha'),
//             ])),
//           ],
//         ),
//       ),
  // );
  // }
  List<Widget> _getStaffNames() {
    List<Widget> _widgets = [];

    _widgets.add(Text(
      'Lecturer: Vasiliy Kuznetsov',
      style: TextStyle(fontSize: 15.0),
    ));
    _widgets.add(SizedBox(height: 5.0));
    _widgets.add(Text(
      'Seminar-Lecturer: Abduvosid Malikov',
      style: TextStyle(fontSize: 15.0),
    ));

    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return CCMFeedbackProvider(
      ccmFeedbackBloc: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('CCM Feedback'),
          centerTitle: true,
        ),
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(ccmAddFeedbackPage);
          },
          child: Icon(Icons.add),
        ),
        body: Center(
            child: CCMCarousel(
          autoplay: false,
          dotSize: 5.0,
          dotColor: accentColor,
          images: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
              Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
                  child: Text(
                    'Fundamentals of Programming',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: accentColor),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getStaffNames(),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                InkWell(
                  onTap: () {
                    _bloc.setIsPositive.add(true);
                  },
                  child: StreamBuilder(
                    stream: _bloc.isPositive,
                    initialData: true,
                    builder: (context, snapshot) => Container(
                          width: size.width / 2,
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 15.0),
                          child: Center(
                            child: Text(
                              'Positive comments',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: snapshot.data
                                      ? Colors.white
                                      : accentColor),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: snapshot.data ? accentColor : Colors.white,
                              border:
                                  Border.all(width: 1.0, color: accentColor)),
                        ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _bloc.setIsPositive.add(false);
                  },
                  child: StreamBuilder(
                    stream: _bloc.isPositive,
                    builder: (context, snapshot) => Container(
                          width: size.width / 2,
                          padding: EdgeInsets.symmetric(
                              vertical: 3.5, horizontal: 15.0),
                          decoration: BoxDecoration(
                              color: snapshot.data ? Colors.white : accentColor,
                              border:
                                  Border.all(width: 1.0, color: accentColor)),
                          child: Center(
                            child: Text(
                              'Suggestions for improvement',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: snapshot.data
                                      ? accentColor
                                      : Colors.white),
                            ),
                          ),
                        ),
                  ),
                )
              ]),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                    color: backgroundColor,
                    child: ListView(children: <Widget>[
                      CustomCard(Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(0.0),
                              padding: EdgeInsets.all(8.0),
                              color: greyColor,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'To Vasiliy Kuznetsov',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator
                                          .of(context)
                                          .pushNamed(ccmAddFeedbackPage);
                                    },
                                    child: Text(
                                      'Reply',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator
                                      .of(context)
                                      .pushNamed(ccmAddFeedbackPage);
                                },
                                child: DrawCardBody()),
                            Container(
                                margin: EdgeInsets.all(0.0),
                                padding: EdgeInsets.all(8.0),
                                color: CupertinoColors.lightBackgroundGray,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('From 3BIS1',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0)),
                                    Text('2 days ago',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0)),
                                  ],
                                )),
                          ])),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 40.0),
                        child: Text('Replies',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(ccmAddFeedbackPage);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: CustomCard(Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                    'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
                              ),
                              Container(
                                  margin: EdgeInsets.all(0.0),
                                  padding: EdgeInsets.all(8.0),
                                  color: CupertinoColors.lightBackgroundGray,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('From Vasiliy Kuznetsov',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                      Text('30 min ago',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                    ],
                                  )),
                            ],
                          )),
                        ),
                      ),
                      Divider(color: accentColor),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(ccmAddFeedbackPage);
                          },
                          child: CustomCard(Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(0.0),
                                  padding: EdgeInsets.all(8.0),
                                  color: greyColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'To Vasiliy Kuznetsov',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator
                                              .of(context)
                                              .pushNamed(ccmAddFeedbackPage);
                                        },
                                        child: Text(
                                          'Reply',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0, right: 10.0, top: 10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text('Group coverage:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5.0),
                                      Text('95%')
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                      'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
                                ),
                                Container(
                                    margin: EdgeInsets.all(0.0),
                                    padding: EdgeInsets.all(8.0),
                                    color: CupertinoColors.lightBackgroundGray,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('From 3BIS1',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0)),
                                        Text('2 days ago',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0)),
                                      ],
                                    )),
                              ])),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, left: 20.0),
                        child: Text('Replies',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15.0)),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(ccmAddFeedbackPage);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: CustomCard(Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                    'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
                              ),
                              Container(
                                  margin: EdgeInsets.all(0.0),
                                  padding: EdgeInsets.all(8.0),
                                  color: CupertinoColors.lightBackgroundGray,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('From Vasiliy Kuznetsov',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                      Text('30 min ago',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                    ],
                                  )),
                            ],
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(ccmAddFeedbackPage);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: CustomCard(Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                    'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
                              ),
                              Container(
                                  margin: EdgeInsets.all(0.0),
                                  padding: EdgeInsets.all(8.0),
                                  color: CupertinoColors.lightBackgroundGray,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('From Vasiliy Kuznetsov',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                      Text('30 min ago',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0)),
                                    ],
                                  )),
                            ],
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ])),
              ),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
              Container(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 18.0),
                  child: Text(
                    'Marketing Communication',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: accentColor),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _getStaffNames(),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: size.width / 2,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                    child: Center(
                      child: Text(
                        'Positive comments',
                        style: TextStyle(fontSize: 13.0, color: Colors.white),
                      ),
                    ),
                    color: accentColor,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: size.width / 2,
                    padding:
                        EdgeInsets.symmetric(vertical: 3.5, horizontal: 15.0),
                    decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(width: 1.0, color: accentColor)),
                    child: Center(
                      child: Text(
                        'Suggestions for improvement',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.0, color: accentColor),
                      ),
                    ),
                  ),
                )
              ]),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
                    color: backgroundColor,
                    child: ListView(children: <Widget>[
                      CustomCard(Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                            'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: CustomCard(Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              'Some more good things, many many maaaaaaaaaaaanyyyyyyyyy wordssssssssssssssssssssssssssssssssssss'),
                        )),
                      ),
                    ])),
              ),
            ]),
          ],
        )),
      ),
    );
  }
}

class DrawCardBody extends StatelessWidget {
  const DrawCardBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Row(
            children: <Widget>[
              Text('Group coverage:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5.0),
              Text('95%')
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Some good moments happened during seminars and lectures. All in all, FunPro is FUN. All in all, FunPro is FUN'),
        ),
      ],
    );
  }
}
