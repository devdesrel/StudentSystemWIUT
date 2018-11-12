import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/bloc/settings_page/settings_bloc.dart';
import 'package:student_system_flutter/bloc/settings_page/settings_provider.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:flutter/services.dart';
import 'package:student_system_flutter/pages/iOS_pages/ios_pin_set.dart';

class SettingsPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  // final double _kPickerItemHeight = 32.0;
  // final double _kPickerSheetHeight = 216.0;
  final List<String> webMailOptionList = ["Outlook", "Gmail", "Apple Mail"];

  // Widget _buildBottomPicker(Widget picker) {
  //   return Container(
  //     height: _kPickerSheetHeight,
  //     padding: const EdgeInsets.only(top: 6.0),
  //     color: CupertinoColors.white,
  //     child: DefaultTextStyle(
  //       style: const TextStyle(
  //         color: CupertinoColors.black,
  //         fontSize: 22.0,
  //       ),
  //       child: GestureDetector(
  //         onTap: () {},
  //         child: SafeArea(
  //           top: false,
  //           child: picker,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    SharedPreferences prefs;
    String currentUserPin;
    String newPin;
    String confirmPin;
    String currentPin;
    var _bloc = SettingsBloc();

    void savePin(BuildContext context, SettingsBloc bloc) async {
      final form = formKey.currentState;

      FocusScope.of(context).requestFocus(FocusNode());
      if (form.validate()) {
        form.save();

        prefs.setString(pinCode, confirmPin);

        bloc.setAutoValidation.add(false);
        Navigator.pop(context);

        showFlushBar('Success', 'PIN was successfully changed',
            MessageTypes.SUCCESS, context, 2);
      } else {
        bloc.setAutoValidation.add(true);
      }
    }

    _getCurrentUserPin() async {
      prefs = await SharedPreferences.getInstance();
      currentUserPin = prefs.getString(pinCode);

      return currentUserPin;
    }

    Widget customeFormField(
        String placeholder,
        ChangePinCodeDialogArguments type,
        BuildContext context,
        SettingsBloc bloc) {
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
              if (type == ChangePinCodeDialogArguments.ConfirmPin)
                confirmPin = val;
            },
            decoration: InputDecoration(
              labelText: placeholder,
            )),
      );
    }

    Future<Null> showPinDialog(BuildContext context, SettingsBloc bloc) async {
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
              title: Text('Change PIN code'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: ListBody(
                    children: <Widget>[
                      customeFormField(
                          'Current PIN',
                          ChangePinCodeDialogArguments.CurrentPin,
                          context,
                          bloc),
                      customeFormField('New PIN',
                          ChangePinCodeDialogArguments.NewPin, context, bloc),
                      customeFormField(
                          'Confirm new PIN',
                          ChangePinCodeDialogArguments.ConfirmPin,
                          context,
                          bloc),
                    ],
                  ),
                ),
                // actions: <Widget>[
                //   CupertinoDialogAction(
                //     isDestructiveAction: true,
                //     child: Text('Cancel'.toUpperCase()),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       bloc.setAutoValidation.add(false);
                //     },
                //   ),
                //   CupertinoDialogAction(
                //     isDefaultAction: false,
                //     child: Text('Save'.toUpperCase()),
                //     onPressed: () {
                //       savePin(context, bloc);
                //     },
                //   ),
                // ],
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
                  },
                ),
              ],
            ),
          );
          // return CupertinoAlertDialog(
// titlePadding: EdgeInsets.only(top: 20.0, left: 20.0),
          // contentPadding:
          //     EdgeInsets.symmetric(horizontal: 23.0, vertical: 0.0),
          //   title: Text('Change PIN code'),
          //   content: SingleChildScrollView(
          //     child: Form(
          //       key: formKey,
          //       child: Material(
          //         child: ListBody(
          //           children: <Widget>[
          //             customeFormField(
          //                 'Current PIN',
          //                 ChangePinCodeDialogArguments.CurrentPin,
          //                 context,
          //                 bloc),
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
          //       isDestructiveAction: true,
          //       child: Text('Cancel'.toUpperCase()),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //         bloc.setAutoValidation.add(false);
          //       },
          //     ),
          //     CupertinoDialogAction(
          //       isDefaultAction: false,
          //       child: Text('Save'.toUpperCase()),
          //       onPressed: () {
          //         savePin(context, bloc);
          //       },
          //     ),
          //   ],
          // );
          // }
        },
      );
    }

    _getCurrentUserPin();

    return SettingsProvider(
      settingsBloc: _bloc,
      child: Platform.isAndroid
          ? Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                centerTitle: true,
                title: Text('Settings'),
              ),
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Security',
                          style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        StreamBuilder(
                          stream: _bloc.isSecurityOn,
                          initialData: true,
                          builder: (context, snapshot) => Switch(
                              onChanged: (value) {
                                _bloc.setSecurityValue.add(value);
                              },
                              value: snapshot.hasData ? snapshot.data : true),
                        ),
                        // SwitchListTile(onChanged: (value) {}, value: true)
                      ],
                    ),
                  ),
                  // CustomSettingsCategory(
                  //   text: 'Security',
                  //   color: accentColor,
                  //   textWeight: FontWeight.bold,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 2.0,
                      child: Column(
                        children: <Widget>[
                          StreamBuilder(
                            stream: _bloc.isSecurityOn,
                            initialData: true,
                            builder: (context, shot) => StreamBuilder(
                                  stream: _bloc.switchtileValue,
                                  builder: (context, snapshot) => ListTile(
                                        enabled:
                                            shot.hasData ? shot.data : true,
                                        onTap: () {
                                          _bloc.setSwitchtileValue
                                              .add(!_bloc.switchValue);
                                          _bloc.switchValue =
                                              !_bloc.switchValue;
                                        },
                                        trailing: Switch(
                                          value: shot.data
                                              ? snapshot.hasData
                                                  ? snapshot.data
                                                  : true
                                              : false,
                                          onChanged: shot.data
                                              ? (value) {
                                                  _bloc.setSwitchtileValue
                                                      .add(value);
                                                }
                                              : null,
                                        ),
                                        leading: Icon(Icons.fingerprint),
                                        title: Text('Fingerprint to log in'),
                                      ),
                                ),
                          ),
                          Divider(
                            height: 0.0,
                          ),
                          StreamBuilder(
                            stream: _bloc.isSecurityOn,
                            initialData: true,
                            builder: (context, snapshot) => ListTile(
                                  enabled:
                                      snapshot.hasData ? snapshot.data : true,
                                  onTap: () {
                                    showPinDialog(context, _bloc);
                                  },
                                  leading: Image.asset(
                                    'assets/key.png',
                                    height: 28.0,
                                  ),
                                  title: Text('Change PIN code'),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Start
                  Padding(
                    padding:
                        EdgeInsets.only(left: 14.0, top: 9.0, bottom: 13.0),
                    child: Text(
                      'Web mail',
                      style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      elevation: 2.0,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        offset: Offset(1.0, 0.0),
                        onSelected: (value) {
                          value == "Outlook"
                              ? _bloc.setWebMailType
                                  .add(WebMailType.Outlook.toString())
                              : _bloc.setWebMailType
                                  .add(WebMailType.Gmail.toString());
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuItem<String>>[
                              PopupMenuItem<String>(
                                  value: 'Outlook',
                                  child: const Text('Outlook')),
                              PopupMenuItem<String>(
                                  value: 'Gmail', child: const Text('Gmail')),
                            ],
                        child: ListTile(
                          enabled: true,
                          onTap: null,
                          trailing: Icon(
                            MdiIcons.chevronDown,
                            color: Colors.grey[500],
                          ),
                          leading: Image.asset(
                            'assets/email_ios.png',
                            height: 22.0,
                            color: Colors.grey[500],
                          ),
                          title: StreamBuilder(
                            initialData: 'Outlook',
                            stream: _bloc.webMailType,
                            builder: (context, snapshot) => Text(
                                snapshot.hasData
                                    ? snapshot.data ==
                                            WebMailType.Outlook.toString()
                                        ? "Outlook"
                                        : "Gmail"
                                    : "Outlook"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Material(
              color: Colors.transparent,
              child: CupertinoPageScaffold(
                backgroundColor: backgroundColor,
                // navigationBar: CupertinoNavigationBar(
                //   middle: Text('Settings Page'),
                // ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    CupertinoSliverNavigationBar(
                      automaticallyImplyLeading: false,
                      trailing: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'Close',
                            style:
                                TextStyle(color: accentColor, fontSize: 16.0),
                          ),
                        ),
                      ),
                      largeTitle: Text("Settings"),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(left: 19.0),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Security',
                              style: TextStyle(
                                  color: lightGreyTextColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0),
                            ),
                            StreamBuilder(
                              stream: _bloc.isSecurityOn,
                              initialData: true,
                              builder: (context, snapshot) => CupertinoSwitch(
                                  onChanged: (value) {
                                    _bloc.setSecurityValue.add(value);
                                  },
                                  value:
                                      snapshot.hasData ? snapshot.data : true),
                            ),
                            // SwitchListTile(onChanged: (value) {}, value: true)
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0),
                          child: Column(
                            children: <Widget>[
                              StreamBuilder(
                                stream: _bloc.isSecurityOn,
                                initialData: true,
                                builder: (context, shot) => StreamBuilder(
                                      stream: _bloc.switchtileValue,
                                      builder: (context, snapshot) => ListTile(
                                            enabled:
                                                shot.hasData ? shot.data : true,
                                            onTap: () {
                                              _bloc.setSwitchtileValue
                                                  .add(!_bloc.switchValue);
                                              _bloc.switchValue =
                                                  !_bloc.switchValue;
                                            },
                                            trailing: CupertinoSwitch(
                                              value: shot.data
                                                  ? snapshot.hasData
                                                      ? snapshot.data
                                                      : true
                                                  : false,
                                              // onChanged: null,
                                              onChanged: shot.data
                                                  ? (value) {
                                                      _bloc.setSwitchtileValue
                                                          .add(value);
                                                    }
                                                  : null,
                                            ),
                                            leading: Icon(Icons.fingerprint),
                                            title:
                                                Text('Fingerprint to log in'),
                                          ),
                                    ),
                              ),
                              Divider(
                                height: 0.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                                child: StreamBuilder(
                                  stream: _bloc.isSecurityOn,
                                  initialData: true,
                                  builder: (context, snapshot) => ListTile(
                                        enabled: snapshot.hasData
                                            ? snapshot.data
                                            : true,
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IosPinSetPage(
                                                          pinRequestType:
                                                              IosPinRequestType
                                                                  .ChangePin)));
                                        },
                                        leading: Image.asset(
                                          'assets/key.png',
                                          height: 28.0,
                                        ),
                                        title: Text('Change PIN code'),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Start
                    // SliverPadding(
                    //   padding:
                    //       EdgeInsets.only(left: 19.0, top: 10.0, bottom: 10.0),
                    //   sliver: SliverToBoxAdapter(
                    //     child: Text(
                    //       'Web mail',
                    //       style: TextStyle(
                    //           color: lightGreyTextColor,
                    //           fontWeight: FontWeight.normal,
                    //           fontSize: 16.0),
                    //     ),

                    //     //End
                    //     // SwitchListTile(onChanged: (value) {}, value: true)
                    //   ),
                    // ),
                    // SliverToBoxAdapter(
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 6.0),
                    //       child: StreamBuilder(
                    //         stream: _bloc.webMailType,
                    //         initialData: 'Outlook',
                    //         builder: (context, snapshot) => ListTile(
                    //               enabled: true,
                    //               onTap: () async {
                    //                 await showCupertinoModalPopup<void>(
                    //                     context: context,
                    //                     builder: (BuildContext context) {
                    //                       return _buildBottomPicker(
                    //                         CupertinoPicker(
                    //                           scrollController:
                    //                               _bloc.webMailScrollController,
                    //                           itemExtent: _kPickerItemHeight,
                    //                           backgroundColor:
                    //                               CupertinoColors.white,
                    //                           onSelectedItemChanged:
                    //                               (int index) {
                    //                             index == 0
                    //                                 ? _bloc.setWebMailType.add(
                    //                                     WebMailType.Outlook
                    //                                         .toString())
                    //                                 : _bloc.setWebMailType.add(
                    //                                     WebMailType.Gmail
                    //                                         .toString());
                    //                             _bloc.setIosWebMailPickerIndex
                    //                                 .add(index);
                    //                           },
                    //                           children: List<Widget>.generate(
                    //                               webMailOptionList.length,
                    //                               (int index) {
                    //                             return Center(
                    //                               child: Text(
                    //                                   webMailOptionList[index]),
                    //                             );
                    //                           }),
                    //                         ),
                    //                       );
                    //                     });
                    //               },
                    //               leading: Image.asset(
                    //                 'assets/email_ios.png',
                    //                 height: 22.0,
                    //                 color: Colors.grey[500],
                    //               ),
                    //               title: Text(snapshot.hasData
                    //                   ? snapshot.data ==
                    //                           WebMailType.Outlook.toString()
                    //                       ? "Outlook"
                    //                       : "Gmail"
                    //                   : "Outlook"),
                    //               // trailing: PopupMenuButton<String>(
                    //               //     padding: EdgeInsets.zero,
                    //               //     onSelected: (value) {
                    //               //       _bloc.setWebMailType.add(value);
                    //               //     },
                    //               //     itemBuilder: (BuildContext context) =>
                    //               //         <PopupMenuItem<String>>[
                    //               //           PopupMenuItem<String>(
                    //               //               value: 'Outlook',
                    //               //               child: const Text('Outlook')),
                    //               //           PopupMenuItem<String>(
                    //               //               value: 'Gmail',
                    //               //               child: const Text('Gmail')),
                    //               //         ]),
                    //             ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
