import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ccm_carousel.dart';

class CCMFeedbackPage extends StatefulWidget {
  @override
  _CCMFeedbackPageState createState() => _CCMFeedbackPageState();
}

class _CCMFeedbackPageState extends State<CCMFeedbackPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('CCM Feedback'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: CCMCarousel(
          isDotIndicatorBottom: false,
          dotColor: accentColor,
          autoplay: false,
          images: <Widget>[
            SingleChildScrollView(
              child: Column(children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Fundamentals of programming',
                    style: TextStyle(fontSize: 18.0),
                  ),
                )),
                // Text('hjjshjfbsajdhjsafjhsajfbjha'),
                Container(
                  width: double.infinity,
                  // height: 400.0,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
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

                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView(
                          children: <Widget>[
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                            Text('Feedback 1ghjkdfghjkdfghjksdfghjks'),
                          ],
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              constraints:
                                  BoxConstraints.loose(Size.fromHeight(100.0)),
                              child: Theme(
                                data: ThemeData(hintColor: lightGreyTextColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0,
                                            top: 0.0),
                                        // border: OutlineInputBorder(
                                        //     borderRadius: BorderRadius.circular(50.0)),
                                        hintText: 'Write here',
                                      )
                                      // filled: true,
                                      // fillColor: backgroundColor),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: 40.0,
                            // height: 20.0,
                            child: IconButton(
                              icon: Icon(Icons.mic),
                              color: redColor,
                              onPressed: () {},
                            ),
                          ),
                          //SEND BUTTON
                          SizedBox(
                            // width: 40.0,
                            // height: 20.0,
                            child: IconButton(
                              icon: Icon(Icons.send),
                              color: accentColor,
                              onPressed: () => debugPrint("Pressed"),
                              //elevation: 4.0,
                            ),
                          ),
                          // TextField(),

                          // TextField(),
                          // Icon(Icons.insert_emoticon)
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: <Widget>[
                      //     Container(
                      //       child: TextFormField(
                      //         decoration:
                      //             InputDecoration(hintText: 'Write here'),
                      //       ),
                      //     ),
                      //     Icon(Icons.mic),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ]),
            ),
            SingleChildScrollView(
                child: Column(children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Marketing Communication'),
              )),
              Text('hjjshjfbsajdhjsafjhsajfbjha'),
            ])),
          ],
        ),
      ),
    );
  }
}
