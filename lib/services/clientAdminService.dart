import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/globals.dart';

class ClientAdmin{

  dynamic GetGraph({required int client_id})async{
    var response = await http.post(
      Uri.parse(globals().url + 'clientadmin/getgraph'),
      headers: globals().headers,
      body: jsonEncode({
        "client_id":client_id
      })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetReports({required int client_id})async{
    var response = await http.post(
        Uri.parse(globals().url + 'clientadmin/getreports'),
        headers: globals().headers,
        body: jsonEncode({
          "client_id":client_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetTickets({required int client_id})async{
    var response = await http.post(
        Uri.parse(globals().url + 'clientadmin/gettickets'),
        headers: globals().headers,
        body: jsonEncode({
          "client_id":client_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetUsers({required int client_id})async{
    var response = await http.post(
        Uri.parse(globals().url + 'clientadmin/getusers'),
        headers: globals().headers,
        body: jsonEncode({
          "client_id":client_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetUnits({required int client_id})async{
    var response = await http.post(
        Uri.parse(globals().url + 'clientadmin/getunits'),
        headers: globals().headers,
        body: jsonEncode({
          "client_id":client_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic CreateUnits({required Map data})async{
    var response = await http.post(
        Uri.parse(globals().url + 'clientadmin/createunits'),
        headers: globals().headers,
        body: jsonEncode({
          "unit_number":data['unit_number'],
          "unit_name":data['unit_name'],
          "unit_address":data['unit_address'],
          "created_by":data['id']
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic UpdateUnits({required Map data})async{
    var response = await http.put(
        Uri.parse(globals().url + 'clientadmin/updateunits'),
        headers: globals().headers,
        body: jsonEncode({
          "unit_number":data['unit_number'],
          "unit_name":data['unit_name'],
          "unit_address":data['unit_address'],
          "unit_id":data['id']
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic DeleteUnits({required Map data})async{
    var response = await http.delete(
        Uri.parse(globals().url + 'clientadmin/deleteunits'),
        headers: globals().headers,
        body: jsonEncode({
          "unit_id":data['id']
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }
}