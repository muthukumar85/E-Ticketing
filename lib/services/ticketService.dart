
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../global/globals.dart';

class TicketService{
  dynamic CreateTicket({required Map data})async{
    print(data);
    var response = await http.post(
      Uri.parse(globals().url + 'ticket/create'),
      headers: globals().headers,
      body: jsonEncode(data)
    );
    print(response);
    var ress = response.body;
    return ress;
  }
  dynamic UploadTicketFile({required File selectedFile , required Map data})async{
    var client = http.Client();
    try {
      // Create a new FormData object
      var formData = http.MultipartRequest('POST', Uri.parse(globals().url + 's3bucket/uploadticket'));

      // Add the file to the FormData
      formData.files.add(await http.MultipartFile.fromPath('file', selectedFile.path));

      // Send the request
      var response = await client.send(formData);

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful, handle the response
        print(response);
        var responseBody = await response.stream.bytesToString();
        var parsedResponse = jsonDecode(responseBody);
        data['attachment'] = parsedResponse['path'].toString();
        var res = await CreateTicket(data: data);
        return res;
        print(parsedResponse);
      } else {
        // Request failed, handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the process
      print('Exception: $e');
    } finally {
      // Close the client when done
      client.close();
    }
  }
  dynamic UploadTicketFileOnly({required File selectedFile})async{
    var client = http.Client();
    try {
      // Create a new FormData object
      var formData = http.MultipartRequest('POST', Uri.parse(globals().url + 's3bucket/uploadticket'));

      // Add the file to the FormData
      formData.files.add(await http.MultipartFile.fromPath('file', selectedFile.path));

      // Send the request
      var response = await client.send(formData);

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful, handle the response
        print(response);
        var responseBody = await response.stream.bytesToString();
        var parsedResponse = jsonDecode(responseBody);

        return parsedResponse;
        print(parsedResponse);
      } else {
        // Request failed, handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the process
      print('Exception: $e');
    } finally {
      // Close the client when done
      client.close();
    }
  }
  dynamic UploadSolutionFile({required File selectedFile})async{
    var client = http.Client();
    try {
      // Create a new FormData object
      var formData = http.MultipartRequest('POST', Uri.parse(globals().url + 's3bucket/uploadsolution'));

      // Add the file to the FormData
      formData.files.add(await http.MultipartFile.fromPath('file', selectedFile.path));

      // Send the request
      var response = await client.send(formData);

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful, handle the response
        print(response);
        var responseBody = await response.stream.bytesToString();
        var parsedResponse = jsonDecode(responseBody);
        print(parsedResponse);
        return parsedResponse;
      } else {
        // Request failed, handle the error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occurred during the process
      print('Exception: $e');
    } finally {
      // Close the client when done
      client.close();
    }
  }
  dynamic UPdateTicketData({required Map data})async{

    var response = await http.put(
        Uri.parse(globals().url + 'ticket/editticket'),
        headers: globals().headers,
        body: jsonEncode(data)
    );
    var res = response.body;
    return res;
  }
  dynamic CloseTicket({required int ticket_id})async{

    var response = await http.put(
        Uri.parse(globals().url + 'ticket/closeticket'),
        headers: globals().headers,
        body: jsonEncode({
          "ticket_id":ticket_id
        })
    );
    var res = jsonDecode(response.body);
    return res;
  }
}