import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CCMAddFeedbackBloc {
  double groupCoverage = 0.0;
  String teacherName = '';

  //sending
  Sink<String> get setTeacherName => _setTeacherNameController.sink;

  final _setTeacherNameController = StreamController<String>();

  Sink<bool> get setAutoValidation => _setAutoValidationController.sink;

  final _setAutoValidationController = StreamController<bool>();

  Sink<double> get setGroupCoverageValue =>
      _setGroupCoverageValueController.sink;

  final _setGroupCoverageValueController = StreamController<double>();

  Sink<bool> get setGroupCoverageDataValidation =>
      _setGroupCoverageDataValidationController.sink;

  final _setGroupCoverageDataValidationController = StreamController<bool>();

  Sink<bool> get setTeacherNameDatavalidation =>
      _setTeacherNameDataValidationController.sink;

  final _setTeacherNameDataValidationController = StreamController<bool>();

  Sink<String> get setFeedbackType => _setFeedbackTypeController.sink;

  final _setFeedbackTypeController = StreamController<String>();

  //receiving
  Stream<String> get teacherNameValue => _teacherNameValueSubject.stream;

  final _teacherNameValueSubject = BehaviorSubject<String>();

  Stream<double> get groupCoverageValue => _groupCoverageValueSubject.stream;

  final _groupCoverageValueSubject = BehaviorSubject<double>();

  Stream<bool> get autoValidation => _autoValidationSubject.stream;

  final _autoValidationSubject = BehaviorSubject<bool>();

  Stream<bool> get groupCoverageDataValidation =>
      _groupCoverageDataValidationSubject.stream;

  final _groupCoverageDataValidationSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<bool> get teacherNameDataValidation =>
      _teacherNameDataValidationSubject.stream;

  final _teacherNameDataValidationSubject =
      BehaviorSubject<bool>(seedValue: false);

  Stream<String> get feedbackType => _feedbackTypeSubject.stream;

  final _feedbackTypeSubject = BehaviorSubject<String>();

  CCMAddFeedbackBloc() {
    _setTeacherNameController.stream.listen((_teacherName) {
      _teacherNameValueSubject.add(_teacherName);
    });

    _setGroupCoverageValueController.stream.listen((_groupCoverageValue) {
      _groupCoverageValueSubject.add(_groupCoverageValue);
    });

    _setGroupCoverageDataValidationController.stream
        .listen((_groupCoverageDataValidation) {
      _groupCoverageDataValidationSubject.add(_groupCoverageDataValidation);
    });

    _setTeacherNameDataValidationController.stream
        .listen((_teacherNameDataVAlidation) {
      _teacherNameDataValidationSubject.add(_teacherNameDataVAlidation);
    });

    _setAutoValidationController.stream.listen((autoValidationValue) {
      _autoValidationSubject.add(autoValidationValue);
    });

    _setFeedbackTypeController.stream.listen((_feedbackType) {
      _feedbackTypeSubject.add(_feedbackType);
    });
  }

  void dispose() {
    _setTeacherNameController.close();

    _setAutoValidationController.close();
    _setGroupCoverageValueController.close();
    _setGroupCoverageDataValidationController;
    _setGroupCoverageDataValidationController.close();
    _setTeacherNameDataValidationController.close();
    _setFeedbackTypeController.close();

    _teacherNameValueSubject.close();
    _autoValidationSubject.close();
    _groupCoverageValueSubject.close();
    _groupCoverageDataValidationSubject.cast();
    _teacherNameDataValidationSubject.close();
    _feedbackTypeSubject.close();
  }
}
