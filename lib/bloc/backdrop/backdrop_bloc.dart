import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:student_system_flutter/models/deadlines_model.dart';

class BackdropBloc {
  bool isBackdropPanelHidden = true;
  String minute;

  BackdropBloc() {
    _setBackdropPanelHiddenController.stream.listen((val) {
      _backdropPanelHiddenSubject.add(val);
      isBackdropPanelHidden = val;
    });
    _chooseDeadlineModuleController.stream.listen((mod) {
      if (mod.minute == 0 || mod.minute.toString().length == 1) {
        minute = mod.minute.toString();
        minute = minute.padLeft(2, '0');
      } else {
        minute = mod.minute.toString();
      }
      //  else if (mod.minute.toString().length == 1) {
      //   mod.minute = (mod.minute / 10).round();
      // }

      _showDeadlineModuleSubject.add(mod);
    });
  }

  Sink<bool> get setBackdropPanelHidden =>
      _setBackdropPanelHiddenController.sink;

  final _setBackdropPanelHiddenController = StreamController<bool>();

  Sink<DeadlinesModel> get chooseDeadlineModule =>
      _chooseDeadlineModuleController.sink;

  final _chooseDeadlineModuleController = StreamController<DeadlinesModel>();

  Stream<bool> get backdropPanelHidden => _backdropPanelHiddenSubject.stream;

  final _backdropPanelHiddenSubject = BehaviorSubject<bool>(seedValue: true);

  Stream<DeadlinesModel> get showDeadlineModule =>
      _showDeadlineModuleSubject.stream;

  final _showDeadlineModuleSubject = BehaviorSubject<DeadlinesModel>();

  void dispose() {
    _setBackdropPanelHiddenController.close();
    _backdropPanelHiddenSubject.close();
    _chooseDeadlineModuleController.close();
    _showDeadlineModuleSubject.close();
  }
}
