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
class MessageViewhome extends StatefulWidget {
  const MessageViewhome({Key? key  , required this.userinfo , required this.ticketinfo , required this.solutions}) : super(key: key);
  final Map userinfo;
  final Map ticketinfo;
  final Map solutions;
  @override
  State<MessageViewhome> createState() => _MessageViewhomeState();
}

class _MessageViewhomeState extends State<MessageViewhome> {
  List<dynamic> solutions = [];
  String imgpath = '';
  bool isFileExists = false;
  bool isLoad = false;


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
      print(widget.solutions['result']);
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
      // appBar: AppBars(name: 'Solutions', isreload: false, islogout: false, context: context),
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height/1,
          child: ListView.builder(
            itemCount: solutions.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            itemBuilder: (context, index){
              return Container(

                padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                child: Align(
                  alignment: (solutions[index]['sender_id'] != widget.ticketinfo['user_id']?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: solutions[index]['sender_id'] == 1?Color(0xFFAEDFFB): Color(0xFFF4F4F4),
                    ),
                    width: MediaQuery.of(context).size.width/1.2,
                    child: Card(
                      elevation: 5,
                      color: solutions[index]['sender_id'] != widget.ticketinfo['user_id']?ArgonColors.white: Color(0xFFF4F4F4),
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
        ]
      ),
    );
  }
}
