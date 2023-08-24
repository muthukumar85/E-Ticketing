import 'dart:io';

import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/services/MessageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/ticketService.dart';
class Messagehome extends StatefulWidget {
  const Messagehome({Key? key  , required this.userinfo , required this.ticketinfo , required this.solutions}) : super(key: key);
  final Map userinfo;
  final Map ticketinfo;
  final Map solutions;
  @override
  State<Messagehome> createState() => _MessagehomeState();
}

class _MessagehomeState extends State<Messagehome> {
  List<dynamic> solutions = [];
  File _selectedFile=File('');
  String imgpath = '';
  bool isFileExists = false;
  bool isLoad = false;
  void _pickFile() async {
    await Permission.storage.request();
    if(true) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
        print(_selectedFile.toString().split('/').last.split("'").first);
        imgpath = _selectedFile.toString().split('/').last.split("'").first.toString();
        setState(() {
          isFileExists = true;
        });
      }
    }
  }

  dynamic _uploadFile() async {
    setState(() {
      isLoad = true;
    });
    if (await _selectedFile.exists()) {
      var pathdetails;
      if(widget.userinfo['role']=='super_admin') {
        pathdetails = await TicketService().UploadSolutionFile(
            selectedFile: _selectedFile);
      }else{
        pathdetails = await TicketService().UploadTicketFileOnly(
            selectedFile: _selectedFile);
      }
      var response = await MessageService().SentMsg(data: {
        "ticket_id":widget.ticketinfo['ticket_id'],
        "sender":widget.userinfo['id'],
        "content": myController.text,
        "attachment":pathdetails['path']
      });
      if(response['success']) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        setState(() {
          solutions.add({
            "ticket_id":widget.ticketinfo['ticket_id'],
            "sender_id":widget.userinfo['id'],
            "content": myController.text,
            "attachment":pathdetails['path'],
            "timestamp":DateTime.now().toString()
          });
          _selectedFile = File('');
          isFileExists = false;
          imgpath = '';
          myController.text = '';
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(' Not uploaded')));

      }
    } else {
      var response = await MessageService().SentMsg(data: {
        "ticket_id":widget.ticketinfo['ticket_id'],
        "sender":widget.userinfo['id'],
        "content": myController.text,
        "attachment":'undefined'
      });
      if(response['success']) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        setState(() {

          solutions.add({
            "ticket_id":widget.ticketinfo['ticket_id'],
            "sender_id":widget.userinfo['id'],
            "content": myController.text,
            "attachment":'undefined',
            "timestamp":DateTime.now().toString()

          });
          _selectedFile = File('');
          isFileExists = false;
          imgpath = '';
          myController.text = '';
        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(' Not uploaded')));

      }

    }
    setState(() {
      isLoad = false;
    });

  }

  void AssignInitial(){
    solutions.add({
      "ticket_id":widget.ticketinfo['ticket_id'],
      "sender_id":widget.ticketinfo['user_id'],
      "subject":widget.ticketinfo['subject'],
      "content":widget.ticketinfo['description'],
      "attachment":widget.ticketinfo['attachment'],
      "timestamp":widget.ticketinfo['created_time']
    });
    print(DateTime.parse(widget.ticketinfo['created_time']).toLocal());
  }
  TextEditingController myController = TextEditingController();
  @override
  void initState() {
setState(() {
  solutions = widget.solutions['result'];
  AssignInitial();
  solutions.sort((a, b){ //sorting in ascending order
    return DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp']));
  });
  print(solutions);
});

    super.initState();
  }
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(name: 'Solutions', isreload: false, islogout: false, context: context),
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height/1.3,
          child: ListView.builder(
            itemCount: solutions.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            itemBuilder: (context, index){
              return Container(

                padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                child: Align(
                  alignment: (solutions[index]['sender_id'] != widget.userinfo['id']?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: solutions[index]['sender_id'] == 1?Color(0xFFAEDFFB): Color(0xFFF4F4F4),
                    ),
                    width: MediaQuery.of(context).size.width/1.2,
                    child: Card(
                      elevation: 5,
                      color: solutions[index]['sender_id'] != widget.userinfo['id']?ArgonColors.white: Color(0xFFF4F4F4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(solutions[index]['subject']!=null?solutions[index]['subject']:'' , style: TextStyle(color: ArgonColors.text , fontSize: 18),),
                              subtitle: Text(solutions[index]['content'].toString() ,
                                style: TextStyle(color: ArgonColors.text , fontSize: 16),
                              ),
                              // leading: Text('32-33-2032 84:34'),
                            ),
                            (solutions[index]['attachment']!=null && solutions[index]['attachment']!='undefined')?Image.network(solutions[index]['attachment']):SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(solutions[index]['timestamp']).toLocal()) , style: TextStyle(color: Colors.grey[600]),)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
          // SizedBox(height: 250,),
          Align(
            alignment: Alignment.bottomLeft,
            child: Card(
              elevation: 0,
              borderOnForeground: false,
              child:Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                // height: 200,
                width: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: widget.ticketinfo['ticket_state']!='closed'?(isLoad?SpinKitCircle(
                    color: ArgonColors.darkgreen,
                    size: 80.0,
                  ):Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              _pickFile();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ArgonColors.darkgreen,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(Icons.add, color: Colors.white, size: 20, ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: TextField(
                              controller: myController,
                              maxLines: 2,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                  hintText: "Write Content...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FloatingActionButton(
                              onPressed: (){
                                _uploadFile();
                              },
                              child: Icon(Icons.send,color: Colors.white,size: 18,),
                              backgroundColor: ArgonColors.darkgreen,
                              elevation: 0,
                            ),
                          ),
                        ],

                      ),
                      // Divider(),
                      isFileExists?Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: [Card(
                            elevation: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300]
                              ),
                              child:  Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        width: MediaQuery.of(context).size.width/2.5,
                                        child: Text(imgpath , style: TextStyle(color: ArgonColors.text ,fontSize: 16, overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        _selectedFile = File('');
                                        isFileExists = false;
                                        imgpath = '';
                                      });

                                    },
                                      child: Icon(Icons.clear , color: ArgonColors.text,)
                                  )
                                ],
                              ),
                            ),
                          )],
                        ),
                      ):SizedBox(),
                    ],
                  )):Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: Text('Ticket Closed' , style: TextStyle(color: ArgonColors.text , fontSize: 20),)),
                  ),
                )
                ,
              )
            ),
          ),
        ]
      ),
    );
  }
}
