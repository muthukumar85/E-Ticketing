import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/downloadFileService.dart';
import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: true , ignoreSsl: true);
  FlutterDownloader.registerCallback(DownloadService.callback);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E ticketing',
      theme: ThemeData(
        fontFamily: 'StevieSans'
      ),
      initialRoute: '/register',
      debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/register": (BuildContext context) =>  Loginhome(),
        });

  }
}
