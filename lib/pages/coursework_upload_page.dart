import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:student_system_flutter/bloc/coursework_upload/coursework_upload_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/module_selection_expansion_tile.dart';

class CourseworkUploadPage extends StatefulWidget {
  @override
  _CourseworkUploadPageState createState() => new _CourseworkUploadPageState();
}

class _CourseworkUploadPageState extends State<CourseworkUploadPage> {
  Widget _currentPage;
  @override
  Widget build(BuildContext context) {
    if (_currentPage == null) {
      _currentPage = _createCurrentPage(context);
    }

    return _currentPage;
  }
}

Widget _createCurrentPage(BuildContext context) {
  showFlushBar(
      info, featureNotImplemented, MessageTypes.INFINITE_INFO, context);

  return CourseworkUploadProvider(
      child: Platform.isAndroid
          ? Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Coursework Upload'),
              ),
              body: CourseworkUploadItems(),
            )
          : Material(
              child: CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  middle: Text('Coursework Upload'),
                ),
                child: CourseworkUploadItems(),
              ),
            ));
}

class CourseworkUploadItems extends StatefulWidget {
  @override
  CourseworkUploadItemsState createState() => CourseworkUploadItemsState();
}

class CourseworkUploadItemsState extends State<CourseworkUploadItems> {
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  var formKey = GlobalKey<FormState>();

  String title;
  final String value = 'Select a module';
  final String chosenFile = 'No file selected';
  final List<String> _moduleNamesList = [
    'Web applications developmenttt',
    'Another looooong module name',
    'Short name',
    'The last one was unrealistic, right?))',
  ];
  @override
  Widget build(BuildContext context) {
    var bloc = CourseworkUploadProvider.of(context);

    void saveTitle() {
      final form = formKey.currentState;
      bloc.setAutoValidation.add(true);

      FocusScope.of(context).requestFocus(FocusNode());

      if (form.validate()) {
        form.save();
        print(title);
        //formKey.save();
        // print('Validation done');
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 16.0),
      child: ListView(children: <Widget>[
        // CourseworkTitleTextFormField(),
        Form(
          key: formKey,
          child: StreamBuilder(
            stream: bloc.autoValidation,
            builder: (context, snapshot) => TextFormField(
                  autovalidate: snapshot.hasData ? snapshot.data : false,
                  style: Theme.of(context).textTheme.body2.copyWith(
                      color: Theme.of(context).accentColor,
                      decorationColor: Colors.white),
                  autofocus: false,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    if (val.length == 0) return 'Title can not be empty';
                  },
                  onSaved: (val) => title = val,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          gapPadding: 2.0,
                          borderSide: BorderSide(
                              color: Colors.white, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(8.0))),
                ),
          ),
        ),
        SizedBox(
          height: 25.0,
        ),
        Text(
          'Module',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        SizedBox(
          height: 2.0,
        ),
        StreamBuilder(
          initialData: value,
          stream: bloc.moduleName,
          builder: (context, snapshot) => ModuleSelectionExpansionTile(
              bloc: bloc,
              expansionTile: expansionTile,
              value: snapshot.hasData ? snapshot.data : value,
              expansionChildrenList: _moduleNamesList),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          'Component ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          CustomRadioButtons(),
          //new CustomRadioButtons(),
        ]),
        SizedBox(
          height: 12.0,
        ),
        Text(
          'File ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamBuilder(
              initialData: chosenFile,
              stream: bloc.fileName,
              builder: (context, snapshot) => Flexible(
                    child: Text(
                      snapshot.hasData ? snapshot.data : '',
                      style: TextStyle(color: Color(0xBF616161)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ),
            RaisedButton(
              onPressed: () async {
                var filePath =
                    await Navigator.of(context).pushNamed(filePickerPage);

                bloc.setFileName.add(basename(filePath.toString()));
              },
              textColor: Colors.white,
              color: greyColor,
              child: Text('Choose file'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 36.0,
        ),
        Platform.isAndroid
            ? RaisedButton(
                color: accentColor,
                // onPressed: saveTitle,
                onPressed: saveTitle,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : CupertinoButton(
                color: accentColor,
                // onPressed: saveTitle,
                onPressed: saveTitle,
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              )
      ]),
    );
  }
}

class CustomRadioButtons extends StatelessWidget {
  final radioButtonInitialValue = 0;
  @override
  Widget build(BuildContext context) {
    var bloc = CourseworkUploadProvider.of(context);
    return ButtonBar(alignment: MainAxisAlignment.start, children: <Widget>[
      Column(
        children: <Widget>[
          StreamBuilder(
            initialData: radioButtonInitialValue,
            stream: bloc.componentName,
            builder: (context, snapshot) => Radio(
                  value: 1,
                  onChanged: (c) => bloc.setComponent.add(c),
                  groupValue: snapshot.hasData
                      ? snapshot.data
                      : radioButtonInitialValue,
                ),
          ),
          Text('CW1', style: TextStyle(fontSize: 10.0))
        ],
      ),
      Column(
        children: <Widget>[
          StreamBuilder(
            initialData: radioButtonInitialValue,
            stream: bloc.componentName,
            builder: (context, snapshot) => Radio(
                  value: 2,
                  onChanged: (c) => bloc.setComponent.add(c),
                  groupValue: snapshot.hasData
                      ? snapshot.data
                      : radioButtonInitialValue,
                ),
          ),
          Text('CW2', style: TextStyle(fontSize: 10.0))
        ],
      ),
      Column(
        children: <Widget>[
          StreamBuilder(
            initialData: 0,
            stream: bloc.componentName,
            builder: (context, snapshot) => Radio(
                  value: 3,
                  onChanged: (c) => bloc.setComponent.add(c),
                  groupValue: snapshot.hasData
                      ? snapshot.data
                      : radioButtonInitialValue,
                ),
          ),
          Text(
            'CW3',
            style: TextStyle(fontSize: 10.0),
          )
        ],
      )
    ]);
  }
}
