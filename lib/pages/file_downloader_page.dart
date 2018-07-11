import 'package:flutter/material.dart';
import 'package:student_system_flutter/helpers/app_constants.dart';

class FileDownloaderPage extends StatefulWidget {
  @override
  _FileDownloaderPageState createState() => _FileDownloaderPageState();
}

class _FileDownloaderPageState extends State<FileDownloaderPage> {
  // var dio = new Dio();
  double totalProgress = 0.0;
  double downloadProgress = 0.0;
  // Directory _appDocumentsDirectory;
  // Directory _externalDocumentsDirectory;
  List<String> urls = List();

  // @override
  // initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Future _downloadFile() async {
  //   // dio.options.baseUrl = "http://www.dtworkroom.com/doris/1/2.0.0/";
  //   // dio.options.connectTimeout = 5000; //5s
  //   // dio.options.receiveTimeout = 5000;
  //   // dio.options.headers = {'user-agent': 'dio', 'common-header': 'xx'};

  //   Response response = await dio.download(
  //       "https://images.pexels.com/photos/443446/pexels-photo-443446.jpeg?cs=srgb&dl=daylight-forest-glossy-443446.jpg&fm=jpg",
  //       _externalDocumentsDirectory.path + "/Lecture1.jpg",
  //       onProgress: (received, total) {
  //     setState(() {
  //       downloadProgress = received / total / 100;
  //       totalProgress = totalProgress + downloadProgress;
  //       print('$downloadProgress');
  //     });

  //     print((totalProgress).toStringAsFixed(0) + "%");
  //   });

  //   print(
  //       '${_externalDocumentsDirectory.toString()}/WIUT Mobile/WAD/Lectures/Lecture 1.jpg');

  //   // File file = new File(_requestExternalStorageDirectory());
  // }

  // Widget _buildDirectory(
  //     BuildContext context, AsyncSnapshot<Directory> snapshot) {
  //   List<FileSystemEntity> _files;
  //   Directory dir;
  //   Text text = const Text('');

  //   if (snapshot.connectionState == ConnectionState.done) {
  //     if (snapshot.hasError) {
  //       text = new Text('Error: ${snapshot.error}');
  //     } else if (snapshot.hasData) {
  //       dir = new Directory(snapshot.data.path);
  //       text = new Text('path: ${snapshot.data.path}');
  //       _files = dir.listSync(recursive: true, followLinks: false);
  //       print('path: ${snapshot.data.path}');
  //     } else {
  //       text = const Text('path unavailable');
  //     }
  //   }
  //   if (null != _files) {
  //     return new ListView.builder(
  //         padding: const EdgeInsets.all(16.0),
  //         itemCount: _files.length,
  //         itemBuilder: (context, i) {
  //           return _buildRow(_files.elementAt(i).path);
  //         });
  //   } else {
  //     return new Padding(padding: const EdgeInsets.all(16.0), child: text);
  //   }
  // }

  // Widget _buildRow(String fileName) {

  //   Future<Null> _launched;

  //   final alreadySaved = _saved.contains(fileName);

  //   return new ListTile(

  //     title: new Text(

  //       fileName,

  //       style: _biggerFont,

  //     ),

  //     trailing: new Icon(

  //       alreadySaved ? Icons.favorite : Icons.favorite_border,

  //       color: alreadySaved ? Colors.red : null,

  //     ),

  //     onTap: () {

  //       setState(() {

  //         if (alreadySaved) {

  //           _saved.remove(fileName);

  //         } else {

  //           _saved.add(fileName);

  //         }

  //         File f = new File(fileName);

  //         selectedUrl = fileName; //f.uri.toString();

  //         //Navigator.of(context).pushNamed("/widget");

  //         var args = {'url': fileName};

  //         platform.invokeMethod('viewPdf', args);

  //       });

  //     },

  //   );

  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await SimplePermissions.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  // }

  @override
  Widget build(BuildContext context) {
    // requestPermission(Permission.WriteExternalStorage);

    return Scaffold(
      appBar: AppBar(
        title: Text('Downloading materials'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: new Column(children: <Widget>[
          // new RaisedButton(
          //   child: new Text('${Platform.isIOS ?
          //                           "External directories are unavailable "
          //                           "on iOS":
          //                           "Get External Storage Directory" }'),
          //   onPressed: Platform.isIOS ? null : _requestExternalStorageDirectory,
          // ),
          // SizedBox(height: 15.0),
          // new Expanded(
          //   child: new FutureBuilder<Directory>(
          //       future: _externalDocumentsDirectory, builder: _buildDirectory),
          // ),
          // SizedBox(height: 15.0),
          Center(
            child: LinearProgressIndicator(
              value: totalProgress,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ]),
      ),
    );
  }
}

//  return FutureBuilder(
//       future: _downloadFile(),
//       builder: (BuildContext context, AsyncSnapshot snapshot){
//         if (snapshot.hasData) {
//               if (snapshot.data!=null) {
//                 return new Column (
//                   children: <Widget>[
//                     new Expanded(
//                         child: new ListView(
//                           children: _getData(snapshot),
//                         ))
//                   ],
//                 );
//               } else {
//                 return new CircularProgressIndicator();
//               }
//       }
//     );
