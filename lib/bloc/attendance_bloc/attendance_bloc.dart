import 'package:barcode_scan/barcode_scan.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:student_system_flutter/helpers/app_constants.dart'
    as constantants;

class AttendanceBloc {
  AttendanceBloc();

  Stream<String> get qrResult => _qrResultSubject.stream;

  final _qrResultSubject = BehaviorSubject<String>();

  Future<void> result(bool isSuccess) async {
    isSuccess
        ? _qrResultSubject.add("Successfully completed")
        : _qrResultSubject.add("Problem occured");
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      var _isSuccess = await apiRequest(barcode);

      await result(_isSuccess);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _qrResultSubject.add('The user did not grant the camera permission!');
      } else {
        _qrResultSubject.add('Unknown error: $e');
      }
    } on FormatException {
      _qrResultSubject.add('Try again');
    } catch (e) {
      _qrResultSubject.add('Unknown error: $e');
    }
  }

  Future<bool> apiRequest(String qrCode) async {
    bool _isSuccess = false;
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
        print("Success");
        _isSuccess = true;
      }
    } catch (e) {
      print(e);
    }
    return _isSuccess;
  }

  dispose() {
    _qrResultSubject.close();
  }
}
