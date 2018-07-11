import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:student_system_flutter/bloc/coursework_upload_bloc.dart';
import 'package:student_system_flutter/bloc/coursework_upload_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/custom_expansion_tile.dart';
import 'package:student_system_flutter/pages/file_picker_page.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CourseworkUploadProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Returning Data Demo'),
        ),
        body: SelectionButton(),
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();

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
    ModulesList modulesList = ModulesList(_moduleNamesList);

    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 16.0),
      child: ListView(children: <Widget>[
        TextFormField(
          // autovalidate: dataNotValid,
          style: Theme.of(context).textTheme.body2.copyWith(
              color: Theme.of(context).accentColor,
              decorationColor: Colors.white),
          autofocus: false,
          maxLines: 1,
          keyboardType: TextInputType.text,
          validator: (val) => val.length == 0 ? 'Title can not be empty' : null,
          // onSaved: (val) => _title = val,
          decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                  gapPadding: 2.0,
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8.0))),
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
          builder: (context, snapshot) => CustomExpansionTile(
              expansionTile: expansionTile,
              value: snapshot.hasData ? snapshot.data : value,
              modulesList: modulesList),
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
              stream: bloc.fileName,
              builder: (context, snapshot) => Text(
                    snapshot.hasData ? snapshot.data : '',
                    style: TextStyle(color: Color(0xBF616161)),
                  ),
            ),
            RaisedButton(
              onPressed: () async {
                // var filePath = await Navigator
                //     .of(context)
                //     .pushNamed(filePickerPage);

                var filePath =
                    await Navigator.of(context).pushNamed(filePickerPage);
                // var filePath = await Navigator.push(
                //   context,
                //   // We'll create the SelectionScreen in the next step!
                //   MaterialPageRoute(
                //       builder: (context) => FilePickerPage()),
                // );

                bloc.setFileName.add(basename(filePath.toString()));
              },
              textColor: Theme.of(context).accentColor,
              child: Text('Choose file'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  // A method that launches the SelectionScreen and awaits the result from
  // Navigator.pop!
  _navigateAndDisplaySelection(
      BuildContext context, CourseworkUploadBloc bloc) async {
    // Navigator.push returns a Future that will complete after we call
    // Navigator.pop on the Selection Screen!
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FilePickerPage()),
    );

    bloc.setFileName.add(basename(result.toString()));
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
