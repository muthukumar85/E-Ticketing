import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../global/globals.dart';
class otpService{
  dynamic GenerateOTP({required Map data})async{

    var response = await http.post(
        Uri.parse(globals().url + 'otp/generateotp'),
        headers: globals().headers,
        body: jsonEncode(data)
    );
    var res = response.body;
    return res;
  }
  dynamic VerifyOTP({required Map data})async{

    var response = await http.post(
        Uri.parse(globals().url + 'otp/verifyotp'),
        headers: globals().headers,
        body: jsonEncode(data)
    );
    var res = response.body;
    return res;
  }

}