import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CourseworkUploadBloc {
  //receiving
  Sink<String> get setModuleName => _setModuleNameController.sink;

  final _setModuleNameController = StreamController<String>();

  Sink<int> get setComponent => _setComponentController.sink;

  final _setComponentController = StreamController<int>();

  Sink<String> get setFileName => _setFileNameController.sink;

  final _setFileNameController = StreamController<String>();

//sending
  Stream<String> get moduleName => _moduleNameSubject.stream;

  final _moduleNameSubject = BehaviorSubject<String>();

  Stream<int> get componentName => _componentNameSubject.stream;

  final _componentNameSubject = BehaviorSubject<int>();

  Stream<String> get fileName => _fileNameSubject.stream;

  final _fileNameSubject = BehaviorSubject<String>();

  CourseworkUploadBloc() {
    // var chosenComponent;
    // var fileName;
    // var moduleName;
    // _setModuleNameController.stream.listen((_moduleName) {
    //   _moduleNameSubject.add(_moduleName);
    // });
    _setComponentController.stream.listen((_component) {
      _componentNameSubject.add(_component);
    });
    _setFileNameController.stream.listen((_fileName) {
      _fileNameSubject.add(_fileName);
      print(_fileName);
    });
  }

  void choseComponent() {
//TODO: choose a component
  }

  void dispose() {
    // _setModuleNameController.close();
    // _setComponentController.close();
    // _setFileNameController.close();

    _moduleNameSubject.close();
    _componentNameSubject.close();
    // _fileNameSubject.close();
  }
}
