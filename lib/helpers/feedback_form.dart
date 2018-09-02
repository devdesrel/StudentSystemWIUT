import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/models/feedback_model.dart';

import '../helpers/ui_helpers.dart';

class FeedbackForm extends StatefulWidget {
  List<FeedbackModel> questionNumbers;

  FeedbackForm({
    Key key,
    @required this.questionNumbers,
  }) : super(key: key);
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  var _controller = PageController();

  @override
  Widget build(BuildContext context) {
    TextStyle _buttonStyle =
        Theme.of(context).textTheme.button.copyWith(color: textColor);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
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
                Text(widget.questionNumbers[index].questionTitle),
                Expanded(
                  child: StarRating(
                      rating: widget.questionNumbers[index].rating,
                      onRatingChanged: (rating) {
                        return setState(() {
                          widget.questionNumbers[index].rating = rating;
                          if (index != widget.questionNumbers.length - 1)
                            _controller.nextPage(
                                duration: kTabScrollDuration,
                                curve: Curves.ease);
                        });
                      }),
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
                    index == widget.questionNumbers.length - 1
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
          itemCount: widget.questionNumbers.length),
    );
  }
}
