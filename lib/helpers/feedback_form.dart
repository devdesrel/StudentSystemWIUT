import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

import '../helpers/ui_helpers.dart';

class FeedbackForm extends StatefulWidget {
  final List<Widget> pages;

  FeedbackForm({
    Key key,
    @required this.pages,
  }) : super(key: key);
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  double _rating = 3.5;
  var _controller = PageController();

  @override
  Widget build(BuildContext context) {
    TextStyle _buttonStyle =
        Theme.of(context).textTheme.button.copyWith(color: textColor);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      height: 155.0,
      child: PageView.builder(
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return new CustomCard(Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Text('Web Application Development'),
                Expanded(
                  child: StarRating(
                    rating: _rating,
                    onRatingChanged: (rating) =>
                        setState(() => _rating = rating),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    index != 0
                        ? FlatButton(
                            child: Text('Previous'.toUpperCase(),
                                style: _buttonStyle),
                            onPressed: () {
                              _controller.previousPage(
                                  duration: kTabScrollDuration,
                                  curve: Curves.ease);
                            },
                          )
                        : Container(),
                    index == widget.pages.length - 1
                        ? FlatButton(
                            child: Text(
                              'Finish'.toUpperCase(),
                              style: _buttonStyle.copyWith(color: accentColor),
                            ),
                            onPressed: () {})
                        : FlatButton(
                            child:
                                Text('Next'.toUpperCase(), style: _buttonStyle),
                            onPressed: () {
                              _controller.nextPage(
                                  duration: kTabScrollDuration,
                                  curve: Curves.ease);
                            }),
                  ],
                )
              ],
            ));
          },
          itemCount: widget.pages.length),
    );
  }
}
