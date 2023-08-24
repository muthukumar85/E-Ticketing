
import 'dart:convert';
import 'dart:io';

import 'package:e_ticket_booking/services/ticketService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Components/Appbar.dart';
import '../constants/Theme.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({Key? key , required this.userinfo , required this.Units}) : super(key: key);
  final Map userinfo;
  final Map Units;
  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isTicketSubmit = false;
  String client = '';
  late int clientValue;
  List<dynamic> units = [];
  String unit = '';
  String type = '';
  String priority = '';
  String subject = '';
  String description = '';
  String password = '';
  String CreatedBy = 'You';
  List<String> types = [
    'Question',
    'Incident',
    'Problem',
    'Task'
  ];
  List<String> priorities = [
    'Low',
    'Normal',
    'High',
    'Urgent'
  ];

  File _selectedFile = File('');
  late String file_path;
  var response;
  // PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  void AssignUnit()async{
    setState(() {
      units = widget.Units['result'] ?? [];
      print(widget.Units);
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
        myControllerfile.text = _selectedFile.toString().split('/').last.split("'").first.toString();

      }
    }
  }

  void _uploadFile() async{
    print(await _selectedFile.exists());
    if(myController1.text != '' && myController2.text != '' && unit != '' && priority != '' && type != '' ) {
      if (await _selectedFile.exists()) {
        response =
        await TicketService().UploadTicketFile(selectedFile: _selectedFile,
            data: {
              "user_id": widget.userinfo['id'],
              "client_id": clientValue,
              "status": "unsolved",
              "state": "open",
              "subject": myController1.text,
              "description": myController2.text,
              "priority": priority,
              "type": type,
              "units": unit
            });
        var responsedata = jsonDecode(response);
        if (responsedata['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ticket created successfully')));
          UserService().refresh(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ticket not created')));
          setState(() {
            isTicketSubmit = false;
          });
        }
      }
      else {
        response = await TicketService().CreateTicket(
            data: {
              "user_id": widget.userinfo['id'],
              "client_id": clientValue,
              "status": "unsolved",
              "state": "open",
              "subject": myController1.text,
              "description": myController2.text,
              "priority": priority,
              "type": type,
              "units": unit
            });
        var responsedata2 = jsonDecode(response);
        if (responsedata2['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ticket created successfully')));
          UserService().refresh(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ticket not created')));
          setState(() {
            isTicketSubmit = false;
          });
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all the fields')));
      setState(() {
        isTicketSubmit = false;
      });
    }
  }
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();
  TextEditingController myController5 = TextEditingController();
  TextEditingController myControllerfile = TextEditingController();
  @override
  void initState() {
    AssignUnit();


      client = widget.userinfo['company_name'];
      clientValue = widget.userinfo['company_id'];
      if(widget.userinfo['role']=='user') {
        unit = widget.userinfo['unit_name'] ?? '';
      }
    super.initState();
  }
  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myControllerfile.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars(name:'Create Ticket' ,  islogout: false , isreload: false, context: context ,),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 0,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                            Row(
                              children: [
                                Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                                SizedBox(width: 4),
                                Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.grey.shade50,
                                    fontSize: 16,
                                  ),
                                ),
                          ],
                        ),
                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Ticket' ,
                                  style: TextStyle(color: ArgonColors.text , fontSize: 16 ),
                                  ),
                                )
                              ],
                            ),
                                SizedBox(height: 20,),
                                Card(
                                  elevation: 3,
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: client,
                                    // controller: myController1,
                                    decoration: const InputDecoration(
                                      // filled:true,

                                      contentPadding: EdgeInsets.all(14),
                                        suffixIcon: Icon(Icons.person,
                                          color: ArgonColors.darkgreen,),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.darkgreen,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                        labelText: 'Client',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        client = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                Card(
                                  elevation: 3,
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: CreatedBy,
                                    // controller: myController2,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                      contentPadding: EdgeInsets.all(14),
                                        suffixIcon: Icon(Icons.person,
                                          color: ArgonColors.darkgreen,),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                        labelText: 'Assignee',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        CreatedBy = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty ) {
                                        return 'Invalid user!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20,),

                                widget.userinfo['role']=='user'?Card(
                                  elevation: 3,
                                  child: TextFormField(
                                    readOnly: true,
                                    initialValue: unit,
                                    // controller: myController2,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                        contentPadding: EdgeInsets.all(14),
                                        suffixIcon: Icon(Icons.ad_units_outlined,
                                          color: ArgonColors.darkgreen,),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.darkgreen,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                        labelText: 'Your Unit',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        unit = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty ) {
                                        return 'Invalid user!';
                                      }
                                      return null;
                                    },
                                  ),
                                ):Card(
                                  elevation: 3,
                                  child: DropdownButtonFormField(
                                    icon: Icon(Icons.arrow_drop_down , color: ArgonColors.darkgreen,),
                                    decoration: const InputDecoration(
                                      // filled:true,
                                      contentPadding: EdgeInsets.all(14),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.darkgreen,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                        labelText: 'Select Unit',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    value: unit.isNotEmpty?unit:null,
                                    onChanged: (newValue) {
                                      setState(() {
                                        unit = newValue.toString();
                                      });
                                    },
                                    items: units.map((session) {
                                      return DropdownMenuItem(
                                        value: session['name'].toString(),
                                        child: Text(session['name']),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        elevation: 3,
                                        child: DropdownButtonFormField(
                                          icon: Icon(Icons.arrow_drop_down , color: ArgonColors.darkgreen,),
                                          decoration: const InputDecoration(
                                             // filled:true,
                                            contentPadding: EdgeInsets.all(14),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: ArgonColors.white,
                                                  width: 0.00,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                // borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: ArgonColors.darkgreen,
                                                  width: 1.4,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: ArgonColors.darkgreen,

                                              ),
                                              labelText: 'Type',
                                              hoverColor: ArgonColors.darkgreen
                                          ),
                                          value: type.isNotEmpty?type:null,
                                          onChanged: (newValue) {
                                            setState(() {
                                              type = newValue.toString();
                                            });
                                          },
                                          items: types.map((session) {
                                            return DropdownMenuItem(
                                              value: session,
                                              child: Text(session),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    Expanded(
                                      child: Card(
                                        elevation: 3,
                                        child: DropdownButtonFormField(
                                          icon: Icon(Icons.arrow_drop_down , color: ArgonColors.darkgreen,),
                                          decoration: const InputDecoration(
                                            // filled:true,
                                            contentPadding: EdgeInsets.all(14),

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: ArgonColors.white,
                                                  width: 0.00,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                // borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: ArgonColors.darkgreen,
                                                  width: 1.4,
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: ArgonColors.darkgreen,

                                              ),
                                              labelText: 'Priority',
                                              hoverColor: ArgonColors.darkgreen
                                          ),
                                          value: priority.isNotEmpty?priority:null,
                                          onChanged: (newValue) {
                                            setState(() {
                                              priority = newValue.toString();
                                            });
                                          },
                                          items: priorities.map((session) {
                                            return DropdownMenuItem(
                                              value: session,
                                              child: Text(session),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Card(
                                  elevation: 3,
                                  child: TextFormField(
                                    controller: myController1,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                      contentPadding: EdgeInsets.all(14),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.darkgreen,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                        labelText: 'Subject',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        subject = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Card(
                                  elevation: 3,
                                  child: TextFormField(
                                     controller: myController2,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                      alignLabelWithHint: true,
                                        contentPadding: EdgeInsets.all(14),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: ArgonColors.white,
                                            width: 0.00,
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: ArgonColors.darkgreen,
                                            width: 1.4,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,
                                        ),

                                        labelText: 'Description',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        description = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Card(
                                              elevation:3,
                                              child: TextFormField(
                                                readOnly: true,
                                                 controller: myControllerfile,
                                                decoration: const InputDecoration(
                                                   filled:true,
                                                    contentPadding: EdgeInsets.all(8),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 0.00,
                                                      ),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      // borderRadius: BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.4,
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
                                          ),
                                          SizedBox(width: 16),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 0, right: 0, top: 0),
                                            child: FlatButton(
                                              textColor: ArgonColors.white,
                                              color: ArgonColors.secondaryblue,
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
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.only(left: 0, right: 0, top: 8),
                                    child: RaisedButton(
                                      textColor: ArgonColors.white,
                                      color: ArgonColors.darkgreen,
                                      onPressed: isTicketSubmit?null:()  {
                                        setState(() {
                                          isTicketSubmit = true;
                                        });
                                        _uploadFile();

                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child:  Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.0, right: 16.0, top: 12, bottom: 12),
                                          child:  isTicketSubmit?
                                          Center(
                                            child: SpinKitCircle(
                                              color: ArgonColors.white,
                                              size: 20.0,
                                            ),
                                          )
                                              : Text("SUBMIT",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 16.0))),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),


                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2.2,
                          offset: Offset(2, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
