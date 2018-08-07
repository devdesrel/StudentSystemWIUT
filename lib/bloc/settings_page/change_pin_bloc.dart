import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePinBloc {
  SharedPreferences prefs;

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
