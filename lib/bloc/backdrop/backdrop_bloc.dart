import 'dart:async';

import 'package:rxdart/rxdart.dart';

class BackdropBloc {
  bool isBackdropPanelHidden = true;

  BackdropBloc() {
    _setBackdropPanelHiddenController.stream.listen((val) {
      _backdropPanelHiddenSubject.add(val);
      isBackdropPanelHidden = val;
    });
  }

  Sink<bool> get setBackdropPanelHidden =>
      _setBackdropPanelHiddenController.sink;

  final _setBackdropPanelHiddenController = StreamController<bool>();

  Stream<bool> get backdropPanelHidden => _backdropPanelHiddenSubject.stream;

  final _backdropPanelHiddenSubject = BehaviorSubject<bool>(seedValue: true);

  void dispose() {
    _setBackdropPanelHiddenController.close();
    _backdropPanelHiddenSubject.close();
  }
}
