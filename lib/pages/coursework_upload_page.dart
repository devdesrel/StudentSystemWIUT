import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/custom_expansion_tile.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class CourseworkUploadPage extends StatefulWidget {
  @override
  _CourseworkUploadPageState createState() => _CourseworkUploadPageState();
}

TextEditingController _controller = TextEditingController();

class _CourseworkUploadPageState extends State<CourseworkUploadPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  bool dataNotValid = false;

  String _title;
  String value = 'Select a module';
  int chosenComponent;
  String chosenFile = 'No file chosen';
  List<String> _moduleNamesList = [
    'Web applications development',
    'Another looooong module name',
    'Another looooong module name'
  ];

  @override
  Widget build(BuildContext context) {
    ModulesList modulesList = ModulesList(_moduleNamesList);

    void _upload() {
      final form = formKey.currentState;

      //FocusScope.of(context).requestFocus(FocusNode());
      form.save();

      if (chosenComponent = null) {
        dataNotValid = true;
        showSnackBar('Please fill in all required fields', scaffoldKey);
      } else if (_title.length == 0) {
        dataNotValid = true;
        showSnackBar('Please fill in all required fields', scaffoldKey);
      } else {
        return null;
      }
    }

    void chooseComponent(int c) {
      setState(() {
        if (c == 1) {
          chosenComponent = 1;
        } else if (c == 2) {
          chosenComponent = 2;
        } else if (c == 3) {
          chosenComponent = 3;
        }
      });
    }

    return Scaffold(
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
              onSaved: (val) => _title = val,
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
            CustomExpansionTile(
                expansionTile: expansionTile,
                value: value,
                modulesList: modulesList),
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
                  ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Radio(
                              value: 1,
                              onChanged: (int c) => chooseComponent(c),
                              groupValue: chosenComponent,
                            ),
                            Text('CW1', style: TextStyle(fontSize: 10.0))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Radio(
                              value: 2,
                              onChanged: (int c) => chooseComponent(c),
                              groupValue: chosenComponent,
                            ),
                            Text('CW2', style: TextStyle(fontSize: 10.0))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Radio(
                              value: 3,
                              onChanged: (int c) => chooseComponent(c),
                              groupValue: chosenComponent,
                            ),
                            Text(
                              'CW3',
                              style: TextStyle(fontSize: 10.0),
                            )
                          ],
                        )
                      ]),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    chosenFile,
                    style: TextStyle(color: Color(0xBF616161)),
                  ),
                ),
                RaisedButton(
                  onPressed: () {},
                  textColor: Theme.of(context).accentColor,
                  child: Text('Choose file'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ],
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
    );
  }
}

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
