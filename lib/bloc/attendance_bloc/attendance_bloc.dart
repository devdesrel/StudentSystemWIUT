import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:student_system_flutter/helpers/app_constants.dart'
    as constantants;
import 'package:student_system_flutter/models/Attendance/attendance_model.dart';

class AttendanceBloc {
  AttendanceBloc();

  Stream<AttendanceModel> get qrResult => _qrResultSubject.stream;

  final _qrResultSubject = BehaviorSubject<AttendanceModel>();

  Future scan() async {
    try {
      String qrCode = await BarcodeScanner.scan();

      if (qrCode != null && qrCode.isNotEmpty) {
        var model = await sendQRcode(qrCode);

        if (model != null) {
          _qrResultSubject.add(model);
        }
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _qrResultSubject.add(AttendanceModel(
            message: 'The user did not grant the camera permission!'));
      } else {
        _qrResultSubject.add(AttendanceModel(message: 'Unknown error: $e'));
      }
    } on FormatException {
      _qrResultSubject.add(AttendanceModel(message: 'Try again'));
    } catch (e) {
      _qrResultSubject.add(AttendanceModel(message: 'Unknown error: $e'));
    }
  }

  Future<AttendanceModel> sendQRcode(String qrCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var _token = pref.getString(constantants.token);
    var _userID = pref.getString(constantants.userID);
    print(_userID);

    try {
      // http.Response _response = await http.post(
      //     "${constantants.apiQrAttendance}?qrCodeID=25",
      http.Response _response = await http.post(qrCode,
          // http.Response _response = await http.post(
          //     "http://newintranetapi.wiut.uz/api/Attendance/CheckIn?qrCodeID=15&studentID=00004467",
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $_token"
          });

      if (_response.statusCode == 200) {
        return _parseData(_response.body, true);
      } else if (_response.statusCode == 400) {
        return _parseData(_response.body, false);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  AttendanceModel _parseData(String responseBody, bool isSuccess) {
    final parsedData = json.decode(responseBody);

    AttendanceModel model = AttendanceModel.fromJson(parsedData);
    model.isSuccess = isSuccess;

    return model;
  }

  dispose() {
    _qrResultSubject.close();
  }
}
