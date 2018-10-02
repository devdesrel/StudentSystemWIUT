import 'dart:async';

import 'package:rxdart/subjects.dart';

class SecurityBloc {
  Sink<bool> get setUseFingerprint => _setUseFingerprintController.sink;

  final _setUseFingerprintController = StreamController<bool>();

  Sink<bool> get setFingerprintDenied => _setFingerprintDeniedController.sink;

  final _setFingerprintDeniedController = StreamController<bool>();

  Stream<bool> get useFingerprint => _useFingerprintSubject.stream;

  final _useFingerprintSubject = BehaviorSubject<bool>();

  Stream<bool> get fingerprintDenied => _fingerprintDeniedSubject.stream;

  final _fingerprintDeniedSubject = BehaviorSubject<bool>();

  SecurityBloc() {
    _setUseFingerprintController.stream.listen((value) {
      _useFingerprintSubject.add(value);
    });

    _setFingerprintDeniedController.stream.listen((value) {
      _fingerprintDeniedSubject.add(value);
    });
  }

  void dispose() {
    _setUseFingerprintController.close();
    _useFingerprintSubject.close();

    _setFingerprintDeniedController.close();
    _fingerprintDeniedSubject.close();
  }
}
