import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/settings_page/change_pin_bloc.dart';
import 'package:student_system_flutter/bloc/settings_page/change_pin_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import '../helpers/app_constants.dart';
import '../helpers/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements AuthStateListener {
  // FocusNode _focusNodeId = new FocusNode();
  // FocusNode _focusNodePassword = new FocusNode();
  // static final TextEditingController _idController =
  //     new TextEditingController();
  // static final TextEditingController _passwordController =
  //     new TextEditingController();
  var bloc = ChangePinBloc();
  final formKey = GlobalKey<FormState>();
  final pinFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
    super.initState();

    _setDefaultSettings();
  }

  void _login(BuildContext context) {
    final form = formKey.currentState;

    FocusScope.of(context).requestFocus(FocusNode());

    if (form.validate()) {
      form.save();
      setState(() {
        progressDialogVisible = true;
      });
      postAuthData(context);
    } else {
      setState(() {
        dataNotValid = true;
      });
    }
  }

  void postAuthData(BuildContext coontext) async {
    try {
      http.Response res = await http.post(apiAuthenticate,
          body: {"Username": _username, "Password": _password},
          headers: {"Accept": "application/json"}); // post api call

      print('${res.body}');
      Map data = json.decode(res.body);
      print(data['token']);

      if (res.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(token, data['token']);
        await prefs.setString(studentID, _username);
        await prefs.setBool(isLoggedIn, true);
        var pin = prefs.getString(pinCode);

        if (pin == null) {
          showPinDialog(context, bloc);
        } else {
          Navigator.of(context).pushReplacementNamed(securityPage);
        }
      } else
        showFlushBar('Username  Password is incorrect', 'Try again', 3,
            redColor, context);

      setState(() {
        progressDialogVisible = false;
      });
    } catch (e) {
      setState(() {
        progressDialogVisible = false;
      });
      showFlushBar('Internet connection failure', checkInternetConnection, 5,
          redColor, context);
    }
  }

  void savePin(BuildContext context) async {
    final form = pinFormKey.currentState;

    FocusScope.of(context).requestFocus(FocusNode());
    if (form.validate()) {
      form.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pinCode, confirmPin);

      bloc.setAutoValidation.add(false);
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(securityPage);
    } else {
      bloc.setAutoValidation.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
              isPassword ? TextInputType.emailAddress : TextInputType.number,
          validator: (val) =>
              val.length == 0 ? '$placeholderName can not be empty' : null,
          onSaved: (val) => isPassword ? _password = val : _username = val,
          decoration: InputDecoration(
              labelText: placeholderName,
              border: OutlineInputBorder(
                  gapPadding: 5.0,
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8.0))),
        ),
        // ),
      );
    }

    return ChangePinProvider(
      changePinBloc: bloc,
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.fill)),
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            shrinkWrap: false,
            children: <Widget>[
              // Image.asset(
              //   'assets/bg.png',
              //   fit: BoxFit.fill,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 30.0,
                      // ),
                      // Image.asset(
                      //   'assets/logo.png',
                      //   height: 40.0,
                      // ),
                      SizedBox(
                        height: size.height / 4,
                      ),
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          authTextFields('WIUT ID', false),
                          // Container(
                          //   height: 15.0,
                          // ),
                          SizedBox(
                            height: 20.0,
                          ),
                          authTextFields('Password', true),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                      RaisedButton(
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
                        onPressed: () => _login(context),
                      ),
                    ],
                  ),
                ),
              ),
              progressDialogVisible
                  ? Container(
                      color: lightOverlayColor,
                      child: Center(child: CircularProgressIndicator()))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  /// PIN code change dialog
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

  Future<Null> showPinDialog(BuildContext context, ChangePinBloc bloc) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 20.0, left: 20.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 0.0),
          title: Text('Set PIN code'),
          content: SingleChildScrollView(
            child: Form(
              key: pinFormKey,
              child: ListBody(
                children: <Widget>[
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
              child: Text('Save'.toUpperCase()),
              onPressed: () async {
                savePin(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onAuthStateChanged(
    AuthState state,
  ) async {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(context).pushReplacementNamed(securityPage);
  }
}

void _setDefaultSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var _useFingerprint = prefs.getBool(useFingerprint);
  // _pinCode ?? prefs.setString(pinCode, '1234');
  _useFingerprint ?? prefs.setBool(useFingerprint, true);
}
