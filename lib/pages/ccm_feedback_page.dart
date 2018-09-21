import 'package:flutter/material.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_carousel.dart';
import 'package:student_system_flutter/pages/ccm_add_feedback_page.dart';

class CCMFeedbackPage extends StatefulWidget {
  @override
  _CCMFeedbackPageState createState() => _CCMFeedbackPageState();
}

class _CCMFeedbackPageState extends State<CCMFeedbackPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CCM Feedback'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Center(
          child: CCMCarousel(
        autoplay: false,
        dotSize: 5.0,
        images: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 14.0, top: 15.0),
              child: Text(
                'Fundamentals of Programming',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, color: accentColor),
              ),
            )),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Positive comments',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: accentColor,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Suggestions',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: accentColor,
                    )
                  ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                    color: backgroundColor,
                    child: ListView(children: <Widget>[
                      Card(
                          color: Colors.white,
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                'Some good moments happened during seminars and lectures. All in all, FunPro is FUN'),
                          )),
                      Card(
                          color: Colors.white,
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                'Some more good things, many many maaaaaaaaaaaanyyyyyyyyy wordssssssssssssssssssssssssssssssssssss'),
                          )),
                    ])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: RaisedButton(
                color: accentColor,
                padding: EdgeInsets.all(10.0),
                onPressed: () {
                  // print('jsdbfkja');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CCMAddFeedBackPage(
                              viewType: FeedbackViewType.Add)));
                },
                // onPressed: () {
                //   Navigator.of(context).pushNamed(ccmAddFeedbackPage);
                //   print('Pressed');
                // },
                child: Text(
                  'Add feedback',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Container(child: Center(child: Text('Marketing Communications'))),
          ]),
        ],
      )),
    );
  }
}
