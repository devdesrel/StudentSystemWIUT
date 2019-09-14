import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/settings_page/change_pin_bloc.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';
import 'package:student_system_flutter/pages/iOS_pages/ios_pin_set.dart';
import '../helpers/app_constants.dart';
import '../helpers/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements AuthStateListener {
  var bloc = ChangePinBloc();

  final formKey = GlobalKey<FormState>();
  final pinFormKey = GlobalKey<FormState>();
  String pin;

  String currentUserPin;
  String newPin;
  String confirmPin;
  String currentPin;
  String notMatched;

  bool dataNotValid = false;
  bool progressDialogVisible = false;

  String _username;
  String _password;

  _LoginPageState() {
    var authStateProvider = AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  initState() {
    getMinimumAppVersion(context);

    super.initState();
    _setDefaultSettings();
  }

  void _login() async {
    final form = formKey.currentState;

    FocusScope.of(context).requestFocus(FocusNode());

    if (form.validate()) {
      form.save();
      setState(() {
        progressDialogVisible = true;
      });
      postAuthData();
    } else {
      setState(() {
        dataNotValid = true;
        // progressDialogVisible = false;
      });
    }
  }

  void savePin(BuildContext context) async {
    final form = pinFormKey.currentState;

    if (form.validate()) {
      form.save();
      FocusScope.of(context).requestFocus(FocusNode());

      await Future.delayed(const Duration(milliseconds: 200));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pinCode, confirmPin);

      prefs.setBool(isPinFilled, true);

      bloc.setAutoValidation.add(false);
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(securityPage);
    } else {
      bloc.setAutoValidation.add(true);
    }
  }

  Future postAuthData() async {
    try {
      http.Response res = await http.post(apiAuthenticate,
          body: {"Username": _username, "Password": _password},
          headers: {"Accept": "application/json"}); // post api call

      Map data = json.decode(res.body);

      if (res.statusCode == 200) {
        String _role = data['role'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(data[token]);
        await prefs.setString(token, data['token']);

        if (_role != null && _role.contains('student')) {
          await prefs.setString(userRole, 'student');
          await prefs.setBool(isSU, false);
        } else if (_role != null && _role.contains('staff')) {
          await prefs.setString(userRole, 'staff');
          await prefs.setBool(isSU, false);
        }

        if (_role != null && _role.contains('SU')) {
          await prefs.setBool(isSU, true);
        }

        await prefs.setString(tokenExpireDay,
            DateTime.now().toUtc().add(Duration(days: 6)).toString());
        await prefs.setString(userID, _username);
        await prefs.setString(userPasssword, _password);
        await prefs.setBool(isLoggedIn, true);
        var pin = prefs.getString(pinCode);
        var securityValue = prefs.getBool(isSecurityValueOn) ?? true;
        // AnimationController controller;
        // Animation<double> animation =
        //     new Tween(begin: 0.1, end: 1.0).animate(controller);

        getUserProfileForTheCurrentYear();
        getUserTableId();

        if (pin == null) {
          Platform.isAndroid
              ? showPinDialog(context, bloc)
              : Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      IosPinSetPage(pinRequestType: IosPinRequestType.SetPin)));

          //Navigator.of(context).pushReplacementNamed(iosPinSetPage);
          // return CupertinoFullscreenDialogTransition(
          //     child: Container(color: Colors.redAccent), animation: animation);
        } else {
          if (securityValue) {
            Navigator.of(context).pushReplacementNamed(securityPage);
          } else {
            Navigator.of(context).pushReplacementNamed(homePage);
          }
        }
      } else
        showFlushBar(authProblems, usernamePasswordIncorrect,
            MessageTypes.ERROR, context, 2);

      setState(() {
        progressDialogVisible = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        progressDialogVisible = false;
      });

      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    Widget authTextFields(String placeholderName, bool isPassword) {
      return Theme(
        data: ThemeData(hintColor: whiteColor),
        // child: EnsureVisibleWhenFocused(
        // focusNode: isPassword ? _focusNodeFirstName : _focusNodeLastName,
        child: TextFormField(
          // controller: isPassword ? _passwordController : _idController,
          // focusNode: isPassword ? _focusNodePassword : _focusNodeId,
          autovalidate: dataNotValid,
          style: Theme.of(context).textTheme.body2.copyWith(
              color: Theme.of(context).accentColor,
              decorationColor: Colors.white),
          autofocus: false,
          obscureText: isPassword,
          keyboardType:
              isPassword ? TextInputType.emailAddress : TextInputType.text,
          validator: (val) =>
              val.length == 0 ? '$placeholderName can not be empty' : null,
          onSaved: (val) => isPassword ? _password = val : _username = val,

          decoration: InputDecoration(
              labelText: placeholderName,
              // focusedBorder: OutlineInputBorder(
              //   borderSide:
              //       BorderSide(color: Colors.white, style: BorderStyle.solid),
              // ),
              enabledBorder: OutlineInputBorder(
                  gapPadding: 5.0,
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8.0)),
              border: OutlineInputBorder(
                  gapPadding: 5.0,
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8.0))),
        ),
        // ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.only(top: 0.0),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/bg.png',
                fit: BoxFit.fill,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 0.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo_white.png',
                          height: 70.0,
                        ),
                        Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                authTextFields('WIUT ID', false),
                                Container(
                                  height: 15.0,
                                ),
                                authTextFields('Password', true),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Platform.isAndroid ? 12.0 : 7.0),
                          child: RaisedButton(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            color: Theme.of(context).accentColor,
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _login,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              progressDialogVisible
                  ? Container(
                      color: lightOverlayColor,
                      child: DrawPlatformCircularIndicator())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget customeFormField(String placeholder, ChangePinCodeDialogArguments type,
      BuildContext context, ChangePinBloc bloc) {
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
          decoration:
              InputDecoration(labelText: placeholder, fillColor: Colors.red)),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  Future<Null> showPinDialog(BuildContext context, ChangePinBloc bloc) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: AlertDialog(
            titlePadding: EdgeInsets.only(top: 20.0, left: 20.0),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 23.0, vertical: 0.0),
            title: Text('Set PIN code'),
            content: SingleChildScrollView(
              child: Form(
                key: pinFormKey,
                child: ListBody(
                  children: <Widget>[
                    customeFormField('New PIN',
                        ChangePinCodeDialogArguments.NewPin, context, bloc),
                    customeFormField('Confirm new PIN',
                        ChangePinCodeDialogArguments.ConfirmPin, context, bloc),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Save'.toUpperCase()),
                onPressed: () async {
                  savePin(context);
                },
              ),
            ],
          ),
        );

        // return CupertinoAlertDialog(
        //   title: Text('Set PIN code'),
        //   content: SingleChildScrollView(
        //     child: Form(
        //       key: pinFormKey,
        //       child: Material(
        //         child: ListBody(
        //           children: <Widget>[
        //             customeFormField('New PIN',
        //                 ChangePinCodeDialogArguments.NewPin, context, bloc),
        //             customeFormField(
        //                 'Confirm new PIN',
        //                 ChangePinCodeDialogArguments.ConfirmPin,
        //                 context,
        //                 bloc),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        //   actions: <Widget>[
        //     CupertinoDialogAction(
        //       child: Text('Save'.toUpperCase()),
        //       onPressed: () async {
        //         savePin(context);
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }

  @override
  void onAuthStateChanged(AuthState state) async {
    var prefs = await SharedPreferences.getInstance();
    var securityValue = prefs.getBool(isSecurityValueOn) ?? true;
    if (state == AuthState.SHOW_PREVIEW_PAGE)
      Navigator.of(context).pushReplacementNamed(previewPage);
    else if (state == AuthState.LOGGED_IN) {
      if (securityValue) {
        Navigator.of(context).pushReplacementNamed(securityPage);
      } else {
        Navigator.of(context).pushReplacementNamed(homePage);
      }
    }
  }
}

void _setDefaultSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var _useFingerprint = prefs.getBool(useFingerprint);
  _useFingerprint ?? prefs.setBool(useFingerprint, true);
}
