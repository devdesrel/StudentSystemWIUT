import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CCMFeedbackBloc {
  Sink<bool> get setIsPositive => _setIsPositiveController.sink;

  final _setIsPositiveController = StreamController<bool>();

  Stream<bool> get isPositive => _isPositiveSubject.stream;

  final _isPositiveSubject = BehaviorSubject<bool>(seedValue: true);

  CCMFeedbackBloc() {
    _setIsPositiveController.stream.listen((_value) {
      _isPositiveSubject.add(_value);
    });
  }

  void dispose() {
    _setIsPositiveController.close();
    _isPositiveSubject.close();
  }
}
