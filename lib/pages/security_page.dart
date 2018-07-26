import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/app_constants.dart';

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool authenticated = false;
  bool isFingerPrintOn;
  bool fingerprintDenied;
  String _pinCode = '';
  String userPinCode;
  String _pinCodeMask = '';

  @override
  initState() {
    _getUserSettings();

    super.initState();
  }

  void _getUserSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userPinCode = prefs.getString(pinCode);
    isFingerPrintOn = prefs.getBool(useFingerprint);

    if (isFingerPrintOn) {
      fingerprintDenied = false;
    } else {
      fingerprintDenied = true;
    }

    _authenticate();
  }

  Future _authenticate() async {
    if (!authenticated && !fingerprintDenied) {
      final LocalAuthentication auth = LocalAuthentication();
      try {
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan your fingerprint to authenticate',
            useErrorDialogs: true,
            stickyAuth: true);
        authenticated
            ? Navigator.of(context).pushReplacementNamed(homePage)
            : null;
        fingerprintDenied = true;
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: redColor,
      content: Text(text),
      duration: Duration(seconds: 2),
    ));
  }

  void enterPIN(String digit) {
    setState(() {
      if (digit != null && digit == 'DEL' && _pinCode.length > 0) {
        _pinCodeMask = _pinCodeMask.substring(0, _pinCodeMask.length - 1);
        _pinCode = _pinCode.substring(0, _pinCode.length - 1);
      } else {
        if (_pinCode.length != null && _pinCode.length < 4 && digit != 'DEL') {
          _pinCodeMask = '$_pinCodeMask*';
          _pinCode = _pinCode + digit;

          if (_pinCode.length == 4 && _pinCode == userPinCode) {
            Navigator.of(context).pushReplacementNamed(homePage);
          } else if (_pinCode.length == 4 && _pinCode != pinCode) {
            _pinCodeMask = '';
            _pinCode = '';
            _showSnackBar('Incorrect pin. Try again.');
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        color: Colors.blue,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100.0,
            ),
            Text(
              _pinCodeMask,
              maxLines: 1,
              style: Theme
                  .of(context)
                  .textTheme
                  .display3
                  .copyWith(color: Colors.white70, letterSpacing: 40.0),
            ),
            Divider(color: Colors.white),
            SizedBox(
              height: 25.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomDigitColumn(
                    firstNumber: '1',
                    secondNumber: '4',
                    thirdNumber: '7',
                    fourthNumber: ' ',
                    enterPIN: enterPIN,
                  ),
                  CustomDigitColumn(
                    firstNumber: '2',
                    secondNumber: '5',
                    thirdNumber: '8',
                    fourthNumber: '0',
                    enterPIN: enterPIN,
                  ),
                  CustomDigitColumn(
                    firstNumber: '3',
                    secondNumber: '6',
                    thirdNumber: '9',
                    fourthNumber: 'DEL',
                    enterPIN: enterPIN,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return FutureBuilder(
    //     future: _authenticate(),
    //     builder: (context, snapshot) {
    //       if (authenticated) {
    //         Container();
    //         Navigator.of(context).pushNamed(social);
    //       } else if (!authenticated) {

    //       }
    //     });
  }
}

class CustomDigitColumn extends StatelessWidget {
  final Function enterPIN;

  const CustomDigitColumn(
      {Key key,
      this.firstNumber,
      this.secondNumber,
      this.thirdNumber,
      this.fourthNumber,
      this.enterPIN})
      : super(key: key);

  final String firstNumber;
  final String secondNumber;
  final String thirdNumber;
  final String fourthNumber;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        Theme.of(context).textTheme.display2.copyWith(color: Colors.white);

    return Material(
      color: Colors.blue,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              enterPIN(firstNumber);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                firstNumber,
                style: textStyle,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          InkWell(
            onTap: () {
              enterPIN(secondNumber);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                secondNumber,
                style: textStyle,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          InkWell(
            onTap: () {
              enterPIN(thirdNumber);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                thirdNumber,
                style: textStyle,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          fourthNumber == ' '
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    fourthNumber,
                    style: textStyle,
                  ),
                )
              : InkWell(
                  onTap: () {
                    enterPIN(fourthNumber);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      fourthNumber,
                      style: textStyle,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
