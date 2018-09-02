import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/settings_page/change_pin_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';

class IosPinSetPage extends StatefulWidget {
  @override
  _IosPinSetPageState createState() => _IosPinSetPageState();
}

class _IosPinSetPageState extends State<IosPinSetPage> {
  final pinFormkey = GlobalKey<FormState>();

  @override
  initState() {
    getMinimumAppVersion(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = ChangePinBloc();

    String newPin;
    String confirmPin;

    bool isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return int.tryParse(s) != null;
    }

    Widget customeFormField(
        String placeholder,
        ChangePinCodeDialogArguments type,
        BuildContext context,
        ChangePinBloc bloc) {
      return StreamBuilder(
          stream: bloc.isAutoValidationOn,
          builder: (context, snapshot) => TextFormField(
                autovalidate: snapshot.hasData ? snapshot.data : false,
                style: Theme.of(context).textTheme.body2.copyWith(
                    color: Theme.of(context).accentColor,
                    decorationColor: Colors.white),
                autofocus: false,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                validator: (val) {
                  switch (type) {
                    case ChangePinCodeDialogArguments.NewPin:
                      newPin = val;
                      break;
                    case ChangePinCodeDialogArguments.ConfirmPin:
                      confirmPin = val;
                      break;
                    default:
                  }

                  if (val.length == 0) {
                    return '$placeholder can not be empty';
                  } else if (!isNumeric(val)) {
                    return '$placeholder should be a number';
                  } else if (val.length != 4) {
                    return '$placeholder should contain 4 digits';
                  }
                  //  else if (currentUserPin != currentPin &&
                  //     type == ChangePinCodeDialogArguments.CurrentPin) {
                  //   return 'Wrong PIN';
                  // }
                  else {
                    if (confirmPin != newPin &&
                        type == ChangePinCodeDialogArguments.ConfirmPin) {
                      return 'New PIN is not confirmed correctly';
                    }
                  }
                },
                onSaved: (val) {
                  if (type == ChangePinCodeDialogArguments.ConfirmPin)
                    confirmPin = val;
                },
                decoration: InputDecoration(
                    labelText: placeholder,
                    border: OutlineInputBorder(
                        gapPadding: 5.0,
                        borderSide: BorderSide(
                            color: Colors.white, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(8.0))),
              ));
    }

    void savePin(BuildContext context) async {
      final form = pinFormkey.currentState;

      if (form.validate()) {
        form.save();
        FocusScope.of(context).requestFocus(FocusNode());

        await Future.delayed(const Duration(milliseconds: 200));

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(pinCode, confirmPin);

        ///TODO: check
        prefs.setBool(isPinFilled, true);

        ///
        bloc.setAutoValidation.add(false);
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(securityPage);
      } else {
        bloc.setAutoValidation.add(true);
      }
    }

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: backgroundColor,
          middle: Text('Set PIN code'),
          trailing: InkWell(
            onTap: () async {
              savePin(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: accentColor),
            ),
          ),
        ),
        child: Column(children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
              key: pinFormkey,
              child: ListBody(
                children: <Widget>[
                  customeFormField('New PIN',
                      ChangePinCodeDialogArguments.NewPin, context, bloc),
                  SizedBox(height: 20.0),
                  customeFormField('Confirm new PIN',
                      ChangePinCodeDialogArguments.ConfirmPin, context, bloc),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
