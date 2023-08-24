import 'dart:convert';
import 'dart:io';
import 'package:e_ticket_booking/Pages/PasswordChange.dart';
import 'package:e_ticket_booking/services/clientAdminService.dart';
import 'package:e_ticket_booking/services/superAdminService.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
late Map mainresponse;
class UserService {
  final _secureStorage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  void refresh(BuildContext context) async {
    if (mainresponse['success'] == true) {
      if (mainresponse['result']['role'] == 'super_admin') {
        mainresponse['Graphdata'] =
        await SuperAdmin().GetGraph(created_id: mainresponse['result']['id']);
        mainresponse['ClientWiseDetails'] =
        await SuperAdmin().GetClientWiseDashboard(
            created_id: mainresponse['result']['id']);
        mainresponse['Reports'] =
        await SuperAdmin().GetReports(created_id: mainresponse['result']['id']);
        mainresponse['Tickets'] =
        await SuperAdmin().GetTickets(created_id: mainresponse['result']['id']);
        mainresponse['Users'] =
        await SuperAdmin().GetUsers(created_id: mainresponse['result']['id']);
        mainresponse['Company'] =
        await SuperAdmin().GetCompany(created_id: mainresponse['result']['id']);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            // builder: (BuildContext context) => SuperAdminHome(),
            builder: (BuildContext context) =>
                SuperAdminHome(
                  userinfo: mainresponse['result'],
                  Users: mainresponse['Users'],
                  Reports: mainresponse['Reports'],
                  Tickets: mainresponse['Tickets'],
                  Graphdata: mainresponse['Graphdata'],
                  ClientWiseDetails: mainresponse['ClientWiseDetails'],
                  Company: mainresponse['Company'],

                ),
          ),
              (
              route) => false, //if you want to disable back feature set to false
        );
      } else {
        if (mainresponse['result']['role'] == 'client_admin') {
          mainresponse['Graphdata'] =
          await ClientAdmin().GetGraph(client_id: mainresponse['result']['company_id']);

          mainresponse['Reports'] =
          await ClientAdmin().GetReports(client_id: mainresponse['result']['company_id']);
          mainresponse['Tickets'] =
          await ClientAdmin().GetTickets(client_id: mainresponse['result']['company_id']);
          mainresponse['Users'] =
          await ClientAdmin().GetUsers(client_id: mainresponse['result']['company_id']);
          mainresponse['Users'] =
          await ClientAdmin().GetUsers(client_id: mainresponse['result']['id']);
          mainresponse['Units'] =
          await ClientAdmin().GetUnits(client_id: mainresponse['result']['id']);
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              // builder: (BuildContext context) => SuperAdminHome(),
              builder: (BuildContext context) => ClientAdminHome(
                Units: mainresponse['Units'],
                Graphdata: mainresponse['Graphdata'],
                Tickets: mainresponse['Tickets'],
                Reports: mainresponse['Reports'],
                Users: mainresponse['Users'],
                userinfo: mainresponse['result'],
              ),
            ),
                (
                route) => false, //if you want to disable back feature set to false
          );
        } else {
          if (mainresponse['result']['role'] == 'client_hod') {
            mainresponse['Graphdata'] =
            await ClientAdmin().GetGraph(client_id: mainresponse['result']['company_id']);
            mainresponse['Reports'] =
            await ClientAdmin().GetReports(client_id: mainresponse['result']['company_id']);
            mainresponse['Tickets'] =
            await ClientAdmin().GetTickets(client_id: mainresponse['result']['company_id']);

            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                // builder: (BuildContext context) => SuperAdminHome(),
                builder: (BuildContext context) => ClientHODHome(
                  Tickets: mainresponse['Tickets'],
                  Graphdata: mainresponse['Graphdata'],
                  userinfo: mainresponse['result'],
                  Reports: mainresponse['Reports'],


                ),
              ),
                  (
                  route) => false, //if you want to disable back feature set to false
            );
          }
          else {
            if (mainresponse['result']['role'] == 'user') {
              mainresponse['Tickets'] = await GetUserTickets(user_id: mainresponse['result']['id']);
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  // builder: (BuildContext context) => SuperAdminHome(),
                  builder: (BuildContext context) => ClientUserTicket(
                     tickets: mainresponse['Tickets'], userinfo: mainresponse['result'],

                  ),
                ),
                    (
                    route) => false, //if you want to disable back feature set to false
              );
            }
          }
        }
      }
    }
  }

  dynamic loginWithCredentials(
      {required String mobile, required String password, required BuildContext context}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'users/login'),
        headers: globals().headers,
        body: jsonEncode({
          "mobile": mobile,
          "password": password
        })
    );
    print(
        "************************************************************************");
    print(response.body);
    Map res = jsonDecode(response.body);

    if (res['success'] == true) {
      await _secureStorage.write(
          key: 'mobile', value: mobile, aOptions: _getAndroidOptions());
      await _secureStorage.write(
          key: 'password', value: password, aOptions: _getAndroidOptions());

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successfull')));
      if (res['result']['role'] == 'super_admin') {
        res['Graphdata'] =
        await SuperAdmin().GetGraph(created_id: res['result']['id']);
        res['ClientWiseDetails'] = await SuperAdmin().GetClientWiseDashboard(
            created_id: res['result']['id']);
        res['Reports'] =
        await SuperAdmin().GetReports(created_id: res['result']['id']);
        res['Tickets'] =
        await SuperAdmin().GetTickets(created_id: res['result']['id']);
        res['Users'] =
        await SuperAdmin().GetUsers(created_id: res['result']['id']);
        res['Company'] =
        await SuperAdmin().GetCompany(created_id: res['result']['id']);
        mainresponse = res;
        return res;
      } else {
        if (res['result']['role'] == 'client_admin') {
          res['Graphdata'] =
          await ClientAdmin().GetGraph(client_id: res['result']['company_id']);

          res['Reports'] =
          await ClientAdmin().GetReports(client_id: res['result']['company_id']);
          res['Tickets'] =
          await ClientAdmin().GetTickets(client_id: res['result']['company_id']);
          res['Users'] =
          await ClientAdmin().GetUsers(client_id: res['result']['id']);
          res['Units'] =
          await ClientAdmin().GetUnits(client_id: res['result']['id']);
          mainresponse = res;
          print(res);
          return res;
        }
        else{
          if(res['result']['role'] == 'client_hod'){
            res['Graphdata'] =
            await ClientAdmin().GetGraph(client_id: res['result']['company_id']);
            res['Reports'] =
            await ClientAdmin().GetReports(client_id: res['result']['company_id']);
            res['Tickets'] =
            await ClientAdmin().GetTickets(client_id: res['result']['company_id']);

            mainresponse = res;
            return res;
          }
          else{
            res['Tickets'] = await GetUserTickets(user_id: res['result']['id']);
            mainresponse = res;
            return res;
          }
        }
      }
    }
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['msg'].toString())));
      return res;
    }
  }

  dynamic CreateUser(
      {required Map userdata, required BuildContext context}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'users/signup'),
        headers: globals().headers,
        body: jsonEncode(userdata)
    );
    Map res = jsonDecode(response.body);
    if (res['success'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User Created Successfully')));
      refresh(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User Not  Created')));
    }
  }

  dynamic UpdateUserDetails({required Map userdata, required BuildContext context}) async {
    var response = await http.put(
        Uri.parse(globals().url + 'users/updateuser'),
        headers: globals().headers,
        body: jsonEncode(userdata)
    );
    print(response);
    Map res = jsonDecode(response.body);
    if (res['success'] == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User Updated Successfully')));
      refresh(context);

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User Not  Updated')));
    }
  }

  dynamic GetUserTickets({required int user_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'users/gettickets'),
        headers: globals().headers,
        body: jsonEncode({
          'user_id': user_id
        })
    );

    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic GetUserUnits()async{
    var response = await http.get(
        Uri.parse(globals().url + 'users/getrandomunits'),
        headers: globals().headers,
    );
    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic ChangePassword({required Map data})async{

    var response = await http.put(
        Uri.parse(globals().url + 'users/changepassword'),
        headers: globals().headers,
        body: jsonEncode(data)
    );
    var res = response.body;
    return res;
  }
  dynamic GetMobile({required String mobile , required String email})async{

    var response = await http.put(
        Uri.parse(globals().url + 'users/getmobile'),
        headers: globals().headers,
        body: jsonEncode({
          "mobile":mobile,
          "email":email
        })
    );
    var res = response.body;
    return res;
  }


}