import 'package:connectivity/connectivity.dart';
import 'package:student_system_flutter/bloc/backdrop/backdrop_bloc.dart';
import 'package:student_system_flutter/bloc/timetable_page/timetable_bloc.dart';

class MainBloc {
  TimetableBloc timetableBloc;
  BackdropBloc backdropBloc;
  var subscription;

  MainBloc() {
    backdropBloc = BackdropBloc();
    createTimetableBloc();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        timetableBloc.setAsLoaded.add(false);
        timetableBloc.offlineMode = true;
        timetableBloc.getTimetableJsonFromPhoneStorage();
      } else {
        backdropBloc.getDeadlineInfoValue();

        timetableBloc.setAsLoaded.add(true);
        timetableBloc.offlineMode = false;
        timetableBloc.getTimetable();
      }

      if (timetableBloc.cleared) {
        createTimetableBloc();
      }
    });
  }

  TimetableBloc createTimetableBloc() {
    timetableBloc = TimetableBloc();
    timetableBloc.getTimetable();
    return timetableBloc;
  }

  void dispose() {
    subscription.cancel();
  }
}
