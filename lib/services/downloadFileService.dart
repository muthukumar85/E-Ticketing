import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ClientHOD/HomeCHOD.dart';
import '../ClientUser/TicketsView.dart';
import '../clientAdmin/HomeCAdmin.dart';
import '../global/globals.dart';
import '../superAdmin/HomeSAdmin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
class DownloadService{
    File file = File('');


   static void callback(String id , DownloadTaskStatus status , int progress)  {


    print("id: $id");
    print("status : $status");
    print("progress : $progress");
    if(progress == 100){
    }
  }
  dynamic downloadFile({required String username , required List data , required String id,  required BuildContext context}) async {
    await Permission.storage.request();
    file = File('/storage/emulated/0/Download/' + username + id + '.xlsx');

    if (await file.exists()) {
      final response = await http.post(
          Uri.parse(globals().url + 'excel/createreportexcel'),
          headers: globals().headers,
          body: jsonEncode({
            "name": username + id.toString(),
            "data": data
          })
      );
      if (response.statusCode == 200) {
        Map res = jsonDecode(response.body);

        await FlutterDownloader.enqueue(
            url: res['path'],
            savedDir: '/storage/emulated/0/Download/',
            showNotification: false,
            openFileFromNotification: false,
            saveInPublicStorage: true
        );



        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('File downloaded successfully in Downloads')));

        // await FlutterDownloader.registerCallback(()=>{});

        // Open the downloaded file using the default app for its type
        // await OpenFile.open(filePath);
      } else {
        // Handle error, e.g., file not found or server error
        print('Error downloading file: ${response.statusCode}');
      }
    }
    else {
      for (var i = 0; i < 10000; i++) {
        file = File(
            '/storage/emulated/0/Download/' + username + id + "("+i.toString() + ")"+
                '.xlsx');

        globals().deletepath = file.path.toString();
        if (!await file.exists()) {
          final response = await http.post(
              Uri.parse(globals().url + 'excel/createreportexcel'),
              headers: globals().headers,
              body: jsonEncode({
                "name": username + id.toString() + "("+i.toString() + ")",
                "data": data
              })
          );
          if (response.statusCode == 200) {
            Map res = jsonDecode(response.body);

            await FlutterDownloader.enqueue(
                url: res['path'],
                savedDir: '/storage/emulated/0/Download/',
                showNotification: false,
                openFileFromNotification: false,
                saveInPublicStorage: true
            );




            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('File downloaded successfully in Downloads')));
            break;
            // await FlutterDownloader.registerCallback(()=>{});

            // Open the downloaded file using the default app for its type
            // await OpenFile.open(filePath);
          } else {
            // Handle error, e.g., file not found or server error
            print('Error downloading file: ${response.statusCode}');
          }
        } else {
          continue;
        }
      }
    }
  }
  dynamic deleteFile({required String username , required String id,  required BuildContext context}) async {
      await Permission.storage.request();
      file = File('/storage/emulated/0/Download/' + username + id + '.xlsx');

      if (await file.exists()) {
        final response = await http.delete(
            Uri.parse(globals().url + 'excel/deleteexcel'),
            headers: globals().headers,
            body: jsonEncode({
              "name": username + id.toString()
            })
        );

      }
      else {
        for (var i = 0; i < 10000; i++) {
          file = File(
              '/storage/emulated/0/Download/' + username + id + "("+i.toString() + ")"+
                  '.xlsx');


          if (!await file.exists()) {
            final response = await http.delete(
                Uri.parse(globals().url + 'excel/deleteexcel'),
                headers: globals().headers,
                body: jsonEncode({
                  "name": username + id.toString() + "("+i.toString() + ")"
                })
            );
            if (response.statusCode == 200) {
              Map res = jsonDecode(response.body);

              break;
              // await FlutterDownloader.registerCallback(()=>{});

              // Open the downloaded file using the default app for its type
              // await OpenFile.open(filePath);
            } else {
              // Handle error, e.g., file not found or server error
              print('Error deleting file: ${response.statusCode}');
            }
          } else {
            continue;
          }
        }
      }
    }

}