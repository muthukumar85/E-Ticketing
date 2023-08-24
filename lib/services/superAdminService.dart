import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global/globals.dart';
class SuperAdmin {
  dynamic GetGraph({required int created_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'superadmin/getgraph'),
        headers: globals().headers,
        body: jsonEncode({
          'created_id': created_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetClientWiseDashboard({required int created_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'superadmin/getclientwisedashboard'),
        headers: globals().headers,
        body: jsonEncode({
          'created_id': created_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetReports({required int created_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'superadmin/getreports'),
        headers: globals().headers,
        body: jsonEncode({
          'created_id': created_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetUsers({required int created_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'superadmin/getusers'),
        headers: globals().headers,
        body: jsonEncode({
          'created_id': created_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }

  dynamic GetTickets({required int created_id}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'superadmin/gettickets'),
        headers: globals().headers,
        body: jsonEncode({
          'created_id': created_id
        })
    );
    Map res = jsonDecode(response.body);
    return res;
  }





  dynamic PostSolution({required Map solutiondata}) async {
    var response = await http.put(
        Uri.parse(globals().url + 'superadmin/postsolution'),
        headers: globals().headers,
        body: jsonEncode({
          'solution': solutiondata['solution'],
          'ticket_id': solutiondata['ticket_id'],
          'attachment':solutiondata['attachment']
        })
    );
    print(response.body);
    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic DeactivateUser({required int userid}) async {
    var response = await http.delete(
        Uri.parse(globals().url + 'superadmin/deactivate'),
        headers: globals().headers,
        body: jsonEncode({
          "user_id": userid,
          "deactivate":true
        })
    );

    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic ActivateUser({required int userid}) async {
    var response = await http.delete(
        Uri.parse(globals().url + 'superadmin/deactivate'),
        headers: globals().headers,
        body: jsonEncode({
          "user_id": userid,
          "deactivate":false
        })
    );

    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic GetCompany({required int created_id}) async {
    var response = await http.put(
        Uri.parse(globals().url + 'company/getcompany'),
        headers: globals().headers,
        body: jsonEncode({
          "id": created_id
        })
    );

    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic PostCompany({required Map data}) async {
    var response = await http.post(
        Uri.parse(globals().url + 'company/postcompany'),
        headers: globals().headers,
        body: jsonEncode(data)
    );

    Map res = jsonDecode(response.body);
    return res;
  }
  dynamic PutCompany({required Map data}) async {
    var response = await http.put(
        Uri.parse(globals().url + 'company/putcompany'),
        headers: globals().headers,
        body: jsonEncode(data)
    );

    Map res = jsonDecode(response.body);
    return res;
  }

}