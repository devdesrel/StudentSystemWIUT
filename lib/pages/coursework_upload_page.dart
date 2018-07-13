import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:student_system_flutter/bloc/coursework_upload_bloc.dart';
import 'package:student_system_flutter/bloc/coursework_upload_provider.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/custom_expansion_tile.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

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

class CourseworkUploadPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  bool dataNotValid = false;
  // TextEditingController _controller = TextEditingController();

  // final String _title;
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
    ModulesList modulesList = ModulesList(_moduleNamesList);
    var bloc = CourseworkUploadBloc();

    void _upload() {
      final form = formKey.currentState;

      //FocusScope.of(context).requestFocus(FocusNode());
      form.save();
    }

    return CourseworkUploadProvider(
      courseworkUploadBloc: bloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Coursework upload page'),
          elevation: 3.0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 16.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                autovalidate: dataNotValid,
                style: Theme.of(context).textTheme.body2.copyWith(
                    color: Theme.of(context).accentColor,
                    decorationColor: Colors.white),
                autofocus: false,
                maxLines: 1,
                keyboardType: TextInputType.text,
                validator: (val) =>
                    val.length == 0 ? 'Title can not be empty' : null,
                // onSaved: (val) => _title = val,
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        gapPadding: 2.0,
                        borderSide: BorderSide(
                            color: Colors.white, style: BorderStyle.solid),
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
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                    builder: (context, snapshot) => Text(
                          snapshot.hasData ? snapshot.data : 'lll',
                          style: TextStyle(color: Color(0xBF616161)),
                        ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      // var filePath = await Navigator
                      //     .of(context)
                      //     .pushNamed(filePickerPage);

                      // var filePath =
                      //     await Navigator.of(context).pushNamed(filePickerPage);

                      bloc.setFileName.add('njnjn');
                    },
                    textColor: Theme.of(context).accentColor,
                    child: Text('Choose file'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ],

                //                  StreamBuilder(
                // initialData: chosenFile,
                // stream: bloc.fileName,
                // builder: (context, snapshot) => Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: <Widget>[
                //         Padding(
                //           padding: const EdgeInsets.only(left: 8.0),
                //           child:
                //                                     Text(
                //             snapshot.hasData ? snapshot.data : chosenFile,
                //             style: TextStyle(color: Color(0xBF616161)),
                //           ),
                //         ),
                //         RaisedButton(
                //           onPressed: () async {
                //             var filePath = await Navigator
                //                 .of(context)
                //                 .pushNamed(filePickerPage);
                //                  },

                // setState(() {
                //   chosenFile = basename(filePath);
                // });
              ),
              SizedBox(
                height: 30.0,
              ),
              RaisedButton(
                child: Text('Upload'),
                onPressed: _upload,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                color: Theme.of(context).accentColor,
                textColor: whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
// class _CourseworkUploadPageState extends State<CourseworkUploadPage>
//     with SingleTickerProviderStateMixin {

//   }
// }

// if (chosenComponent = null) {
//   dataNotValid = true;
//   showSnackBar('Please fill in all required fields', scaffoldKey);
// } else if (_title.length == 0) {
//   dataNotValid = true;
//   showSnackBar('Please fill in all required fields', scaffoldKey);
// } else {
//   return null;
// }

// class CustomRadioButtons extends StatelessWidget {
//   const CustomRadioButtons({
//     Key key,
//     @required this.chosenComponent,
//   }) : super(key: key);

//   final int chosenComponent;

// void _upload() {
//   final form = formKey.currentState;

//   FocusScope.of(context).requestFocus(FocusNode());

//   if (form.validate()) {
// form.save();
//     setState(() {
//       'Uploading';
//     });
//     'Uploaded';
//   } else {
//     setState(() {
//       dataNotValid = true;
//       //_showSnackBar('Please, fill in all required fields');
//     });
//   }
// }
