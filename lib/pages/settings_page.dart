import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/settings_page/settings_bloc.dart';
import 'package:student_system_flutter/bloc/settings_page/settings_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class SettingsPage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  String currentUserPin;
  var formKey = GlobalKey<FormState>();
  String newPin;
  String confirmPin;
  String currentPin;
  String notMatched;

  void savePin(BuildContext context, SettingsBloc bloc) {
    final form = formKey.currentState;

    FocusScope.of(context).requestFocus(FocusNode());
    if (form.validate()) {
      form.save();

      prefs.setString(pinCode, confirmPin);

      bloc.setAutoValidation.add(false);

      Navigator.pop(context);
    } else {
      bloc.setAutoValidation.add(true);
    }
  }

  Widget build(BuildContext context) {
    var _bloc = SettingsBloc();

    _getCurrentUserPin();

    return SettingsProvider(
      settingsBloc: _bloc,
      child: Scaffold(
        backgroundColor: backgroundColor,
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Settings Page'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 13.0, right: 12.0, top: 10.0),
              child: Text(
                'Security',
                style: TextStyle(fontSize: 16.0, color: lightGreyTextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: _bloc.switchtileValue,
                      builder: (context, snapshot) => SwitchListTile(
                            value: snapshot.hasData ? snapshot.data : true,
                            onChanged: (value) {
                              //_onChanged(value);
                              _bloc.setSwitchtileValue.add(value);
                            },
                            secondary: Icon(Icons.fingerprint),
                            subtitle: Text('Security'),

                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: <Widget>[
                            //     Icon(Icons.fingerprint),
                            //     Text(
                            //       'Security',
                            //       style: TextStyle(
                            //           fontSize: 10.0, color: lightGreyTextColor),
                            //     ),
                            //   ],
                            // ),
                            title: Text('Fingerprint to log in'),
                          ),
                    ),
                    ListTile(
                      onTap: () {
                        showPinDialog(context, _bloc);
                      },
                      leading: Image.asset(
                        'assets/key.png',
                        height: 28.0,
                      ),
                      title: Text('Change PIN code'),
                      subtitle: Text('Security'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCurrentUserPin() async {
    prefs = await SharedPreferences.getInstance();
    currentUserPin = prefs.getString(pinCode);

    return currentUserPin;
  }

  Widget customeFormField(String placeholder, ChangePinCodeDialogArguments type,
      BuildContext context, SettingsBloc bloc) {
    return StreamBuilder(
      stream: bloc.isAutoValidationOn,
      builder: (context, snapshot) => TextFormField(
          autovalidate: snapshot.hasData ? snapshot.data : false,
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
            } else if (!isNumeric(val)) {
              return '$placeholder should be a number';
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
          decoration: InputDecoration(
            labelText: placeholder,
          )),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<Null> showPinDialog(BuildContext context, SettingsBloc bloc) async {
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
                  customeFormField('Current PIN',
                      ChangePinCodeDialogArguments.CurrentPin, context, bloc),
                  SizedBox(
                    height: 5.0,
                  ),
                  customeFormField('New PIN',
                      ChangePinCodeDialogArguments.NewPin, context, bloc),
                  SizedBox(
                    height: 5.0,
                  ),
                  customeFormField('Confirm new PIN',
                      ChangePinCodeDialogArguments.ConfirmPin, context, bloc),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                bloc.setAutoValidation.add(false);
              },
            ),
            FlatButton(
              child: Text('Save'.toUpperCase()),
              onPressed: () {
                savePin(context, bloc);
                showSnackBar(
                    'PIN code was changed successfully', scaffoldKey, 5, true);
              },
            ),
          ],
        );
      },
    );
  }
}
