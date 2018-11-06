import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_system_flutter/enums/ApplicationEnums.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/function_helpers.dart';
import 'package:student_system_flutter/models/ccm_roles_model.dart';
import 'package:http/http.dart' as http;

class CCMRoleSelectBloc {
  final context;

  Stream<CCMRolesModel> get ccmRoles => _ccmRolesSubject.stream;

  final _ccmRolesSubject = BehaviorSubject<CCMRolesModel>();

  Sink<CCMRolesModel> get setCCMRoles => _setCCMRolesController.sink;

  final _setCCMRolesController = StreamController<CCMRolesModel>();

  Future<CCMRolesModel> getRoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _token = prefs.getString(token);
    try {
      final res = await http.get("$apiGetCCMRoles", headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $_token"
      });

      if (res.statusCode == 200) {
        final parsed = json.decode(res.body);
        print(res.body);
        CCMRolesModel data =
            parsed.map<CCMRolesModel>((item) => CCMRolesModel.fromJson(item));
        print(data);
        // _ccmRolesSubject.add(data);
        return data;
      }
    } catch (e) {
      print('Error');
      showFlushBar(connectionFailure, checkInternetConnection,
          MessageTypes.ERROR, context, 2);
    }
  }

  CCMRoleSelectBloc(this.context) {
    getRoles().then<CCMRolesModel>((val) {
      // model = val;
      _ccmRolesSubject.add(val);
    });
  }
  void dispose() {
    _setCCMRolesController.close();
    _ccmRolesSubject.close();
  }
}
