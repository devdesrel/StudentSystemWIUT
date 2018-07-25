import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences prefs;
  String currentUserPin;
  bool dataNotValid = false;
  final formKey = GlobalKey<FormState>();
  String newPin;
  String confirmPin;
  String currentPin;
  String notMatched;
  bool _value = false;

  @override
  initState() {
    _getCurrentUserPin();

    super.initState();
  }

  _getCurrentUserPin() async {
    prefs = await SharedPreferences.getInstance();
    currentUserPin = prefs.getString(pinCode);

    return currentUserPin;
  }

//TODO//
  // setPinValues() {}

  //-//

  void savePin() {
    final form = formKey.currentState;

    FocusScope.of(context).requestFocus(FocusNode());
    // checkCurrentPin();

    if (form.validate()) {
      form.save();

      prefs.setString(pinCode, confirmPin);

      dataNotValid = false;
      Navigator.pop(context);
    } else {
      setState(() {
        dataNotValid = true;
      });
    }
  }

  Widget _CustomeFormField(
      String placeholder, ChangePinCodeDialogArguments type) {
    return TextFormField(
        autovalidate: dataNotValid,
        style: Theme.of(context).textTheme.body2.copyWith(
            color: Theme.of(context).accentColor,
            decorationColor: Colors.white),
        autofocus: false,
        obscureText: true,
        keyboardType: TextInputType.number,
        validator: (val) {
          switch (type) {
            case ChangePinCodeDialogArguments.CurrentPin:
              currentPin = val;
              break;
            case ChangePinCodeDialogArguments.NewPin:
              newPin = val;
              break;
            case ChangePinCodeDialogArguments.ConfirmPin:
              confirmPin = val;
              break;
            default:
          }

          currentUserPin = prefs.getString(pinCode);

          if (val.length == 0) {
            return '$placeholder can not be empty';
          } else if (val.length != 4) {
            return '$placeholder should contain 4 digits';
          } else if (currentUserPin != currentPin &&
              type == ChangePinCodeDialogArguments.CurrentPin) {
            return 'Wrong PIN';
          } else {
            if (confirmPin != newPin &&
                type == ChangePinCodeDialogArguments.ConfirmPin) {
              return 'New PIN is not confirmed correctly';
            }
          }
        },
        onSaved: (val) {
          type == ChangePinCodeDialogArguments.ConfirmPin
              ? confirmPin = val
              : null;
        },

        // isConfirmPin==true? confirmPin=val: null

        decoration: InputDecoration(
          labelText: placeholder,
        ));
  }

  Future<Null> showPinDialog(BuildContext context) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 20.0, left: 20.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
          title: Text('Change PIN code'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  _CustomeFormField(
                      'Current PIN', ChangePinCodeDialogArguments.CurrentPin),
                  SizedBox(
                    height: 5.0,
                  ),
                  _CustomeFormField(
                      'New PIN', ChangePinCodeDialogArguments.NewPin),
                  SizedBox(
                    height: 5.0,
                  ),
                  _CustomeFormField('Confirm new PIN',
                      ChangePinCodeDialogArguments.ConfirmPin),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                dataNotValid = false;
                //TODO
                //_cleanUserData();
                // Navigator.of(context).pushReplacementNamed(loginPage);
              },
            ),
            FlatButton(
              child: Text('Save'.toUpperCase()),
              onPressed: () {
                savePin();
              },
            ),
          ],
        );
      },
    );
  }

  // TextFormField(
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: 'Enter your Current PIN'),
  //         ),
  //         TextFormField(
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: 'Enter new PIN'),
  //         ),
  //         TextFormField(
  //           obscureText: true,
  //           decoration: InputDecoration(labelText: 'Confirm new PIN'),
  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }

  void _getSettingsValues() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _value = prefs.getBool(useFingerprint) ?? true;
    });
  }

  void _onChanged(value) {
    setState(() {
      _value = value;
      prefs.setBool(useFingerprint, value);
    });
  }

  Widget build(BuildContext context) {
    _getSettingsValues();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            value: _value,
            onChanged: (value) {
              _onChanged(value);
            },
            secondary: Icon(Icons.fingerprint),
            title: Text('Fingerprint to log in'),
          ),
          ListTile(
            onTap: () {
              showPinDialog(context);
            },
            leading: Image.asset(
              'assets/key.png',
              height: 28.0,
            ),
            title: Text('Change PIN code'),
          ),
        ],
      ),
    );
  }
}
