import 'dart:convert';
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

class MessageService{
  dynamic SentMsg({required Map data})async{

    var response = await http.post(
        Uri.parse(globals().url + 'msg/sendticketmessage'),
        headers: globals().headers,
        body: jsonEncode(data)
    );
    var res = jsonDecode(response.body);
    return res;
  }
  dynamic GetMsg({required int id})async{

    var response = await http.put(
        Uri.parse(globals().url + 'msg/getticketmessage'),
        headers: globals().headers,
        body: jsonEncode({
          "ticket_id":id
        })
    );
    var res = jsonDecode(response.body);
    return res;
  }
}