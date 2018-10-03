import 'dart:async';

import 'package:rxdart/subjects.dart';

class ChangePinBloc {
  Sink<bool> get setAutoValidation => _setAutoValidationController.sink;

  final _setAutoValidationController = StreamController<bool>();

  Stream<bool> get isAutoValidationOn => _isAutoValidationOnSubject.stream;

  final _isAutoValidationOnSubject = BehaviorSubject<bool>();
  ChangePinBloc() {
    _setAutoValidationController.stream.listen((autoValidation) {
      _isAutoValidationOnSubject.add(autoValidation);
    });
  }

  dispose() {
    _isAutoValidationOnSubject.close();
    _setAutoValidationController.close();
  }
}
