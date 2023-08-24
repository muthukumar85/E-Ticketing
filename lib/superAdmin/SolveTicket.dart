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
import '../services/superAdminService.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
class Solveticket extends StatefulWidget {
  const Solveticket({Key? key , required this.data , required this.userinfo}) : super(key: key);
  final Map data;
  final Map userinfo;
  @override
  State<Solveticket> createState() => _SolveticketState();
}

class _SolveticketState extends State<Solveticket> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController myControllerfile = TextEditingController();
  late Map ticket_data;
  bool isload = false;
  File _selectedFile=File('');
  Map solutions = {
    "result":[]
  };
  void _pickFile() async {
    await Permission.storage.request();
    if(true) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
        print(_selectedFile.toString().split('/').last.split("'").first);
        myControllerfile.text = _selectedFile.toString().split('/').last.split("'").first.toString();
      }
    }
  }

  dynamic _uploadFile() async {
    print(await _selectedFile.exists());
    setState(() {
      isload = true;
    });
    if (await _selectedFile.exists()) {
      var pathdetails = await TicketService().UploadSolutionFile(selectedFile: _selectedFile);
      var response = await SuperAdmin().PostSolution(solutiondata: {"solution":_textEditingController.text , "ticket_id":widget.data['ticket_id'] , "attachment":pathdetails['path']});
      if(response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        UserService().refresh(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution not uploaded')));
        Navigator.pop(context);
      }
    } else {

      var response = await SuperAdmin().PostSolution(solutiondata: {"solution":_textEditingController.text , "ticket_id":widget.data['ticket_id']});
      if(response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution uploaded successfully')));
        UserService().refresh(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('solution not uploaded')));
        Navigator.pop(context);
      }
    }
    setState(() {
      isload = false;
    });
  }
  void showCommercialPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return showpopup();
      },
    );
  }
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
                Image.network(widget.data['attachment']):Text('No File Found' , style: TextStyle(color: ArgonColors.text , fontSize: 20),),
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
        content: Card(
          elevation: 0,
          borderOnForeground: false,
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
                widget.data['solution_attachment']!=null && widget.data['solution_attachment']!='undefined'?Image.network(widget.data['solution_attachment']):Text('No Solution File Found' , style: TextStyle(color: ArgonColors.warning),),
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
  @override
  void initState() {
    ticket_data = widget.data;
    print(ticket_data);
    _textEditingController.text = ticket_data['solution']!=null?ticket_data['solution']:'';
    myControllerfile.text = (ticket_data['solution_attachment']!=null && ticket_data['solution_attachment']!='undefined' && ticket_data['solution_attachment']!='null')?ticket_data['solution_attachment']:'';
    super.initState();
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    myControllerfile.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold( 
      appBar: AppBars(name: 'Ticket Details' ,  islogout: false , isreload: false, context: context ,),
        body:SingleChildScrollView(
          child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          //   Container(
          //     constraints: BoxConstraints(
          //
          //
          //     maxHeight: MediaQuery.of(context).size.height/2.6,
          // ),
          //     child: SingleChildScrollView(
          //       physics: ScrollPhysics(),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(ticket_data['subject'],
          //           style: TextStyle(
          //             fontSize: 18 , color: ArgonColors.text , fontWeight: FontWeight.bold
          //           ),
          //
          //           ),
          //           SizedBox(height: 8,),
          //           Text(ticket_data['description'],
          //             style: TextStyle(fontSize: 16 , color: ArgonColors.text),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
              Padding(
                padding:
                const EdgeInsets.only(left: 0, right: 0, top: 8 , bottom: 8),
                child: RaisedButton(
                  textColor: ArgonColors.white,
                  color: ArgonColors.primary,
                  onPressed: () async {

                    Map response = await MessageService().GetMsg(id: ticket_data['ticket_id']);


                    Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => Messagehome(ticketinfo: ticket_data, solutions: response, userinfo: widget.userinfo,),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 12, bottom: 12),
                      child: Row(
                        children: [
                          Icon(Icons.chat , color: ArgonColors.white,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("SOLUTION CHAT",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15.0)),
                          ),
                        ],
                      )),
                ),
              ),
            SizedBox(height: 8,),
            Text(
              'Ticket Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              ticket_data['ticket_id'].toString(),
              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
            ),
            SizedBox(height: 16),
            Text(
              'User Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              ticket_data['username'],
              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
            ),
            SizedBox(height: 16),
            Text(
              'Client Name',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              ticket_data['clientname'],
              style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
            ),
            SizedBox(height: 16),

            Text(
              'Ticket Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              ticket_data['ticket_status'],
              style: TextStyle(fontSize: 16 , color: ticket_data['ticket_status']=='solved'?ArgonColors.success:ArgonColors.error , fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ticket State',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              ticket_data['ticket_state'],
              style: TextStyle(fontSize: 16 ,
                  color: ticket_data['ticket_state']=='closed'?ArgonColors.success: ticket_data['ticket_state']=='open'?ArgonColors.pending:ArgonColors.pending ,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Created Date',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,color: ArgonColors.text
              ),
            ),
            SizedBox(height: 8),
            Text(
              DateTime.parse(ticket_data['created_time']).toString(),
              style: TextStyle(fontSize: 16 , color: ArgonColors.text),
            ),
            SizedBox(height: 16),


          ],
      ),
    ),
        ));

  }
  Widget showpopup()=>AlertDialog(
  title: Text('Solution for Ticket'),
  content: isload?
  Center(
    child: SpinKitCircle(
      color: ArgonColors.darkgreen,
      size: 100.0,
    ),
  )
      :Container(
    height: 380,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
          width: double.maxFinite,
          child: TextField(
          controller: _textEditingController,
          maxLines: 10,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ArgonColors.darkgreen,
                width: 1.8,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: ArgonColors.darkgreen,
                width: 2.0,
              ),
            ),
            hintText: 'Enter Your Solution',
            // labelText: 'Solution',
            labelStyle: TextStyle(
              color: ArgonColors.darkgreen,

            ),
          ),
          ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: myControllerfile,
                  onTap: showSolutionAlert,
                  decoration: const InputDecoration(
                      filled:true,
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.8,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),

                      hintText: 'Select a file',
                      hoverColor: Colors.grey
                  ),
                  keyboardType: TextInputType.text,

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Invalid!';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Padding(
                padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0),
                child: FlatButton(
                  textColor: ArgonColors.white,
                  color: Colors.blue,
                  onPressed: _pickFile,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Padding(
                      padding: EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 12, bottom: 12),
                      child: Text("Browse",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16.0))),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
  actions: [
  TextButton(
  onPressed: () async {
    Navigator.of(context).pop();
  },
  child: Text('Cancel' , style: TextStyle(color: ArgonColors.darkgreen),),
  ),
  RaisedButton(
    textColor: ArgonColors.white,
    color: ArgonColors.darkgreen,
  onPressed: _uploadFile,
  child: Text('Submit'),
  ),
  ],
  );
}
