import 'package:flutter/material.dart';
import 'package:student_system_flutter/bloc/file_download/file_download_bloc.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';
import 'package:student_system_flutter/helpers/ui_helpers.dart';

class ItemFileDownloading extends StatelessWidget {
  final FileDownloadBloc bloc;

  ItemFileDownloading({@required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // FlatButton(
              //     child: Text('Download'),
              //     onPressed: () => _requestPermission(_bloc)),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                  stream: bloc.fileName,
                  initialData: '',
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text('File name: ${snapshot.data}')
                      : Text('')),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                  stream: bloc.downloadProgress,
                  initialData: 0.0,
                  builder: (context, snapshot) => snapshot.hasData
                      ? LinearProgressIndicator(
                          value: snapshot.data,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accentColor))
                      : Container()),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                  stream: bloc.downloadingFileInformation,
                  initialData: '',
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(
                          snapshot.data,
                          textAlign: TextAlign.end,
                        )
                      : Text('')),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
