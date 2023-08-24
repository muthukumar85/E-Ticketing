import 'dart:convert';
import 'dart:io';

import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/Pages/TicketMessage.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/services/MessageService.dart';
import 'package:e_ticket_booking/services/ticketService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class UpdateTicket extends StatefulWidget {
  const UpdateTicket({Key? key , required this.data , required this.userinfo}) : super(key: key);
  final Map data;
  final Map userinfo;
  @override
  State<UpdateTicket> createState() => _UpdateTicketState();
}

class _UpdateTicketState extends State<UpdateTicket> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late TabController _tabController = TabController(length: 2, vsync:this);
  File _selectedFile = File('');
  bool isTicketSubmit = false;
  TextEditingController _textEditingController = TextEditingController();

  TextEditingController myControllerfile = TextEditingController();
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  String subject = '';
  String description = '';
  late Map response;
  bool isType = false;
  var resdata;
  List<dynamic> solutions = [];
  String imgpath = '';
  bool isFileExists = false;
  bool isLoad = false;
  List<dynamic> senders = [];
  void showImageAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Attachment File" , style: TextStyle(color: ArgonColors.text),),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.data['attachment']!=null && widget.data['attachment']!='undefined' && widget.data['attachment']!='null'?
                Image.network(widget.data['attachment']):Text('No File Found'),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void showSolutionAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Ticket Solution" , style: TextStyle(color: ArgonColors.text , fontWeight: FontWeight.bold),),
        contentTextStyle: TextStyle(fontSize: 20),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          // height: MediaQuery.of(context).size.height/1.8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.data['solution']!=null?Text(widget.data['solution'] , style: TextStyle(
                    color: ArgonColors.text,
                  fontSize: 20
                ),):Text('Solution Not Yet Updated'),
                SizedBox(height: 20,),
                widget.data['solution_attachment']!=null && widget.data['solution_attachment']!='undefined' && widget.data['solution_attachment']!='null'?Image.network(widget.data['solution_attachment']):Text('No Solution File Found' , style: TextStyle(color: ArgonColors.warning),),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

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
        "ticket_id":widget.data['ticket_id'],
        "sender":widget.userinfo['id'],
        "content": myController.text,
        "attachment":pathdetails['path']
      });
      if(response['success']) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        setState(() {
          solutions.add({
            "ticket_id":widget.data['ticket_id'],
            "sender_id":widget.userinfo['id'],
            "content": myController.text,
            "attachment":pathdetails['path'],
            "timestamp":DateTime.now().toString(),
            "sender":widget.userinfo['name']
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
        "ticket_id":widget.data['ticket_id'],
        "sender":widget.userinfo['id'],
        "content": myController.text,
        "attachment":'undefined'
      });
      if(response['success']) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        setState(() {

          solutions.add({
            "ticket_id":widget.data['ticket_id'],
            "sender_id":widget.userinfo['id'],
            "content": myController.text,
            "attachment":'undefined',
            "timestamp":DateTime.now().toString(),
            "sender":widget.userinfo['name']
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
      "ticket_id":widget.data['ticket_id'],
      "sender_id":widget.data['user_id'],
      "subject":widget.data['subject'],
      "content":widget.data['description'],
      "attachment":widget.data['attachment'],
      "timestamp":widget.data['created_time'],
      "sender":widget.data["username"]
    });
    print(DateTime.parse(widget.data['created_time']).toLocal());
    print(solutions);
  }
  void getdata() async{
    // response = {};
    try {
      response = await MessageService().GetMsg(id: widget.data['ticket_id']);
      print(response);
      solutions = response['result'];

      solutions.forEach((element) =>
      {
        senders.add(element['sender'])
      });
      senders = senders.toSet().toList();
      AssignInitial();
      solutions.sort((a, b) { //sorting in ascending order
        return DateTime.parse(a['timestamp']).compareTo(
            DateTime.parse(b['timestamp']));
      });
    }catch(e){}
    setState(() {

    });

  }
  TextEditingController myController = TextEditingController();
  @override
  void initState() {
    setState(() {
      getdata();
      print(solutions);
    });
    super.initState();
    myController1.text = widget.data['subject'];
    myController2.text = widget.data['description'];
    myControllerfile.text = widget.data['attachment'] ?? '';

    myController.addListener(() {
      if(myController.text.isEmpty || myController.text.trim().isEmpty){
        setState(() {

          isType = false;
        });
      }else{
        setState(() {

          isType = true;
        });
      }
    });
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    myController1.dispose();
    myController2.dispose();
    myControllerfile.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBars(name: 'Ticket Details' ,  islogout: true , isreload: false, context: context ,),
        body:Column(
          children: [
            TabBar(
                controller: _tabController,
                indicatorColor: ArgonColors.darkgreen,
                labelColor: ArgonColors.text,
                labelStyle: TextStyle(
                    color: ArgonColors.text
                ),
                tabs: [
                  Tab(
                    text: 'Details',
                  ),
                  Tab(
                    text: 'Solution Chat',
                  ),
                ]
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                  SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [


                  SizedBox(height: 8,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ticket Number',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['ticket_id'].toString(),
                              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
                            ),
                          ],
                        ),

                        SizedBox(height: 0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Client Name',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['clientname'],
                              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(height: 16,),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Name',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['username'].toString(),
                              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
                            ),
                          ],
                        ),

                        SizedBox(height: 0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Unit Name',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['units'],
                              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ticket Status',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['ticket_status'].toString().replaceFirst(widget.data['ticket_status'][0], widget.data['ticket_status'][0].toString().toUpperCase()),
                              style: TextStyle(fontSize: 16 , color: widget.data['ticket_status']=='solved'?ArgonColors.success:ArgonColors.error , fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(height: 0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Ticket State',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,color: ArgonColors.text
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.data['ticket_state'].toString().replaceFirst(widget.data['ticket_state'][0], widget.data['ticket_state'][0].toString().toUpperCase()),
                              style: TextStyle(fontSize: 16 , color: widget.data['ticket_state']=='open'?ArgonColors.pending:ArgonColors.success , fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ]),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Created Date',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(widget.data['created_time']).toLocal()),
                            style: TextStyle(fontSize: 16 , color: ArgonColors.text),
                          ),
                        ],
                      ),
                      senders.isNotEmpty?Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Solved By',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          // Text(
                          //   senders.toString().replaceFirst(senders.toString()[0], "").replaceFirst(senders.toString()[senders.toString().length - 1], "").replaceAll(",", "\n"),
                          //   style: TextStyle(fontSize: 16 , color: ArgonColors.text),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:senders.map((e)=>Text(e , style: TextStyle(fontSize: 16 , color: ArgonColors.text),)).toList()
                          )

                        ],
                      ):SizedBox(),
                    ],
                  ),

                  SizedBox(height: 16),
                  Container(

                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 20,),

                          widget.userinfo['role']!='super_admin'?Padding(
                            padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 8),
                            child: RaisedButton(
                              textColor: ArgonColors.white,
                              color: ArgonColors.grey,
                              // onPressed: showSolutionAlert,
                              onPressed: () async {
                                if(widget.data['ticket_state'] !='closed'){
                                  Map response = await TicketService().CloseTicket(ticket_id: widget.data['ticket_id']);
                                  if(response['success']){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['msg'].toString())));
                                    UserService().refresh(context);
                                  }
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket Already Closed')));

                                }

                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5.0, right: 5.0, top: 12, bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(widget.data['ticket_state']=='open'?Icons.check_circle:Icons.clear , color: ArgonColors.white,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text( widget.data['ticket_state']=='open'?"CLOSE TICKET":"TICKET CLOSED",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 15.0)),
                                      ),
                                    ],
                                  )),
                            ),
                          ):SizedBox(),
                          // SizedBox(
                          //   width: double.infinity,
                          //   child: Padding(
                          //     padding:
                          //     const EdgeInsets.only(left: 0, right: 0, top: 8),
                          //     child: RaisedButton(
                          //       textColor: ArgonColors.white,
                          //       color: ArgonColors.darkgreen,
                          //       onPressed: isTicketSubmit?null:()  {
                          //         setState(() {
                          //           isTicketSubmit = true;
                          //         });
                          //         _uploadFile();
                          //
                          //       },
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(4.0),
                          //       ),
                          //       child: Padding(
                          //           padding: EdgeInsets.only(
                          //               left: 16.0, right: 16.0, top: 12, bottom: 12),
                          //           child: isTicketSubmit?
                          //           Center(
                          //             child: SpinKitCircle(
                          //               color: ArgonColors.white,
                          //               size: 20.0,
                          //             ),
                          //           )
                          //               : Text("UPDATE",
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w600, fontSize: 16.0))),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(width: 20,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
    ),
                      Stack(
                          children: [
                            Container(
                            height: MediaQuery.of(context).size.height/1.35,
                            child: ListView.builder(
                              itemCount: solutions.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              itemBuilder: (context, index){
                                if(index == solutions.length -1 ){
                                  return widget.userinfo['role']!='super_admin'?Column(
                                    children: [
                                      Container(

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
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(solutions[index]['sender'] , style: TextStyle(color: ArgonColors.darkgreen ),)
                                                        ],
                                                      ),
                                                    ),
                                                    solutions[index]['subject']!=null?ListTile(
                                                      contentPadding: EdgeInsets.all(0),
                                                      title: Text(solutions[index]['subject']!=null?solutions[index]['subject']:'' , style: TextStyle(color: ArgonColors.text , fontSize: 18),),
                                                      subtitle: Text(solutions[index]['content'].toString() ,
                                                        style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                                      ),
                                                      dense: true,
                                                      // leading: Text('32-33-2032 84:34'),
                                                    ):ListTile(
                                                      contentPadding: EdgeInsets.all(0),
                                                      title: Text(solutions[index]['content'].toString() ,
                                                        style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                                      ),
                                                      dense:true,
                                                      // leading: Text('32-33-2032 84:34'),
                                                    ),
                                                    (solutions[index]['attachment']!=null && solutions[index]['attachment']!='undefined')?Image.network(solutions[index]['attachment']):SizedBox(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0.0),
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
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 0, right: 0, top: 8 , bottom: 8),
                                        child: RaisedButton(
                                          textColor: ArgonColors.white,
                                          color: ArgonColors.darkgreen,
                                          // onPressed: showSolutionAlert,
                                          onPressed: () async {
                                            if(widget.data['ticket_state'] !='closed'){
                                              Map response = await TicketService().CloseTicket(ticket_id: widget.data['ticket_id']);
                                              if(response['success']){
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['msg'].toString())));
                                                UserService().refresh(context);
                                              }
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket Already Closed')));

                                            }

                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.0, right: 5.0, top: 12, bottom: 12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(widget.data['ticket_state']=='open'?Icons.check_circle:Icons.clear , color: ArgonColors.white,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text( widget.data['ticket_state']=='open'?"CLOSE TICKET":"TICKET CLOSED",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600, fontSize: 15.0)),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ):Column(
                                    children: [
                                      Container(

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
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(solutions[index]['sender'] , style: TextStyle(color: ArgonColors.darkgreen ),)
                                                        ],
                                                      ),
                                                    ),
                                                        solutions[index]['subject']!=null?ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(solutions[index]['subject']!=null?solutions[index]['subject']:'' , style: TextStyle(color: ArgonColors.text , fontSize: 18),),
                                subtitle: Text(solutions[index]['content'].toString() ,
                                style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                ),
                                dense: true,
                                // leading: Text('32-33-2032 84:34'),
                                ):ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(solutions[index]['content'].toString() ,
                                style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                ),
                                dense:true,
                                // leading: Text('32-33-2032 84:34'),
                                ),
                                                    (solutions[index]['attachment']!=null && solutions[index]['attachment']!='undefined')?Image.network(solutions[index]['attachment']):SizedBox(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 0.0),
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
                                      ),
                                    ],
                                  );
                                }
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
                                              Padding(
                                                padding: const EdgeInsets.only(top: 0.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(solutions[index]['sender'] , style: TextStyle(color: ArgonColors.darkgreen),)
                                                  ],
                                                ),
                                              ),
                                              solutions[index]['subject']!=null?ListTile(
                                                contentPadding: EdgeInsets.all(0),
                                                title: Text(solutions[index]['subject']!=null?solutions[index]['subject']:'' , style: TextStyle(color: ArgonColors.text , fontSize: 18),),
                                                subtitle: Text(solutions[index]['content'].toString() ,
                                                  style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                                ),
                                                dense: true,
                                                // leading: Text('32-33-2032 84:34'),
                                              ):ListTile(
                                                contentPadding: EdgeInsets.all(0),
                                                title: Text(solutions[index]['content'].toString() ,
                                                  style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                                ),
                                                dense:true,
                                                // leading: Text('32-33-2032 84:34'),
                                              ),
                                              (solutions[index]['attachment']!=null && solutions[index]['attachment']!='undefined')?Image.network(solutions[index]['attachment']):SizedBox(),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 0.0),
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
                                      child: widget.data['ticket_state']!='closed'?(isLoad?SpinKitCircle(
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
                                              isType?Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: FloatingActionButton(
                                                  onPressed: (){
                                                    _uploadFile();
                                                  },
                                                  child: Icon(Icons.send,color: Colors.white,size: 18,),
                                                  backgroundColor: ArgonColors.darkgreen,
                                                  elevation: 0,
                                                ),
                                              ):SizedBox(),
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
                      )


                    ]
                ))
          ],
        ));



  }
  // Widget showpopup()=>AlertDialog(
  //   title: Text('Solution for Ticket'),
  //   content: Container(
  //     width: double.maxFinite,
  //     child: TextField(
  //       controller: _textEditingController,
  //       maxLines: 10,
  //       decoration: InputDecoration(
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: ArgonColors.darkgreen,
  //             width: 1.8,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           // borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(
  //             color: ArgonColors.darkgreen,
  //             width: 2.0,
  //           ),
  //         ),
  //         hintText: 'Enter Your Solution',
  //         // labelText: 'Solution',
  //         labelStyle: TextStyle(
  //           color: ArgonColors.darkgreen,
  //
  //         ),
  //       ),
  //     ),
  //   ),
  //   actions: [
  //     TextButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Cancel' , style: TextStyle(color: ArgonColors.darkgreen),),
  //     ),
  //     RaisedButton(
  //       textColor: ArgonColors.white,
  //       color: ArgonColors.darkgreen,
  //       onPressed: () {
  //         String message = _textEditingController.text;
  //
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Submit'),
  //     ),
  //   ],
  // );
}
