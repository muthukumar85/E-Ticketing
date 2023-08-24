

import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../constants/Theme.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
PreferredSizeWidget AppBars({required String name, required bool isreload, required bool islogout, required BuildContext context}){

  final _secureStorage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
    return AppBar(
      title: Text(name , style: TextStyle(color: ArgonColors.text , fontWeight: FontWeight.w500 , fontSize: 16.5),),
      iconTheme: IconThemeData(color: ArgonColors.text),
      backgroundColor: ArgonColors.white,
      actions: [
        islogout?IconButton(onPressed: () async {
          await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              // builder: (BuildContext context) => SuperAdminHome(),
              builder: (BuildContext context) => Loginhome(),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        }, icon: Icon(Icons.logout , color: ArgonColors.text,)):SizedBox(),
        isreload?IconButton(onPressed: (){
          UserService().refresh(context);
        }, icon: Icon(Icons.refresh_outlined , color: ArgonColors.text,)):SizedBox(),
      ],
    );
}
