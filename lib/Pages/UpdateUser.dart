import 'dart:convert';

import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/superAdminService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../Components/Appbar.dart';
import '../constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../superAdmin/HomeSAdmin.dart';


class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key , required this.userinfo , required this.userdata}) : super(key: key);
  final Map userinfo;
  final Map userdata;
  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Map userinfo;
  bool isLoad = false;
  String fullname = '';
  String email = '';
  String Username = '';
  String mobile = '';

  String Role = '';
  List<Map> roles = [];
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();
  TextEditingController myController5 = TextEditingController();
  void showDisableAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Deactivate User"),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: Text('Do you Want to Deactivate user ?' , style: TextStyle(color: ArgonColors.text ,fontSize: 16),),
        ),
        actions: [
          RaisedButton(
            child: Text("YES" , style: TextStyle(color: ArgonColors.white),),
            color: ArgonColors.error,
            onPressed: () async {

                Map response = await SuperAdmin().DeactivateUser(
                    userid: widget.userdata['id']);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Deactivated')));

                 UserService().refresh(context);



            },
          ),
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void showDisableAlert2(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Activate User"),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: Text('Do you Want to Activate user ?' , style: TextStyle(color: ArgonColors.text ,fontSize: 16),),
        ),
        actions: [
          RaisedButton(
            child: Text("YES" , style: TextStyle(color: ArgonColors.white),),
            color: ArgonColors.error,
            onPressed: () async {

              Map response = await SuperAdmin().ActivateUser(
                  userid: widget.userdata['id']);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Activated')));
              UserService().refresh(context);

            },
          ),
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  bool isValidGmail(String email) {
    // Gmail pattern: [a-zA-Z0-9._%+-]+@gmail\.com
    final gmailPattern = RegExp(r"[a-zA-Z0-9._%+-]+@gmail\.com$", caseSensitive: false);
    return gmailPattern.hasMatch(email);
  }
  void _createUser() async{
    setState(() {
      isLoad = true;
    });
    if(isValidGmail(myController5.text)) {
      if (int.parse(myController4.text[0]) > 6 && myController4.text.length>=6 && myController4.text.length<=15) {
        var res = await UserService().GetMobile(
            mobile: myController4.text, email: myController5.text);
        Map response = jsonDecode(res);
        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User Already Exists')));
          setState(() {
            isLoad = false;
          });
        } else {
          Map userupdata = {
            'username': myController2.text.toString(),
            'mobile': myController4.text.toString(),
            'email': myController5.text.toString(),
            'role': widget.userdata['role'],
            'user_id': widget.userdata['id']
          };
          await UserService().UpdateUserDetails(
              userdata: userupdata, context: context);
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Enter valid mobile number')));
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email Address not valid')));
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    userinfo = widget.userinfo;
    setState(() {
      if(userinfo['role']=='super_admin'){
        roles = [
          { 'show':'SuperAdmin' , 'value':'super_admin' },
          { 'show':'ClientAdmin' , 'value':'client_admin' }
        ];
      }else{
        roles=[
          { 'show':'ClientHOD' , 'value':'client_hod' },
          { 'show':'User' , 'value':'user' },
        ];
      }
      myController2.text = widget.userdata['name'];
      myController4.text = widget.userdata['mobile'];
      myController5.text = widget.userdata['email'];
      Role = widget.userdata['role'];
    });

    super.initState();
  }
  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(isLoad){
      return Scaffold(
          body:Center(
            child: SpinKitCircle(
              color: ArgonColors.darkgreen,
              size: 100.0,
            ),
          ));
    }
    else {
      return Scaffold(
          appBar: AppBars(name: 'Update User' ,  islogout: false , isreload: false, context: context ,),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[

                                    Card(
                                      elevation:3,
                                      child: TextFormField(
                                        controller: myController2,
                                        decoration: const InputDecoration(
                                          // filled:true,
                                            suffixIcon: Icon(Icons.person,
                                              color: ArgonColors.darkgreen,),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ArgonColors.white,
                                                width: 1.8,
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
                                            labelText: 'Username',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        keyboardType: TextInputType.text,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            Username = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid user!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20,),

                                    Card(
                                      elevation: 3,
                                      child: TextFormField(
                                        controller: myController4,
                                        decoration: const InputDecoration(
                                          // filled:true,
                                            suffixIcon: Icon(Icons.keyboard,
                                              color: ArgonColors.darkgreen,),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ArgonColors.white,
                                                width: 1.8,
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
                                            labelText: 'Mobile',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        keyboardType: TextInputType.number,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            mobile = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid mobile!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    Card(
                                      elevation: 3,
                                      child: TextFormField(
                                        controller: myController5,
                                        decoration: const InputDecoration(
                                          suffixIcon: Icon(Icons.email,
                                            color: ArgonColors.darkgreen,),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ArgonColors.white,
                                              width: 1.8,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            // borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color: ArgonColors.darkgreen,
                                              width: 1.4,
                                            ),
                                          ),
                                          labelText: 'email',
                                          labelStyle: TextStyle(
                                            color: ArgonColors.darkgreen,

                                          ),
                                        ),
                                        keyboardType: TextInputType
                                            .emailAddress,

                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid email!';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
                                    // Card(
                                    //   elevation: 3,
                                    //   child: DropdownButtonFormField(
                                    //     icon: Icon(Icons.arrow_drop_down,
                                    //       color: ArgonColors.darkgreen,),
                                    //     decoration: const InputDecoration(
                                    //         enabledBorder: OutlineInputBorder(
                                    //           borderSide: BorderSide(
                                    //             color: ArgonColors.white,
                                    //             width: 1.8,
                                    //           ),
                                    //         ),
                                    //         focusedBorder: OutlineInputBorder(
                                    //           // borderRadius: BorderRadius.circular(10),
                                    //           borderSide: BorderSide(
                                    //             color: ArgonColors.darkgreen,
                                    //             width: 1.4,
                                    //           ),
                                    //         ),
                                    //         labelStyle: TextStyle(
                                    //           color: ArgonColors.darkgreen,
                                    //         ),
                                    //         labelText: 'Select Role',
                                    //         hoverColor: ArgonColors.darkgreen
                                    //     ),
                                    //     value: Role.isNotEmpty ? Role : null,
                                    //     onChanged: (newValue) {
                                    //       setState(() {
                                    //         Role = newValue.toString();
                                    //       });
                                    //     },
                                    //     items: roles.map((session) {
                                    //       return DropdownMenuItem(
                                    //         value: session['value'],
                                    //         child: Text(session['show']),
                                    //       );
                                    //     }).toList(),
                                    //   ),
                                    // ),
                                    // SizedBox(height: 20,),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 0, right: 0, top: 8),
                                            child: RaisedButton(
                                              textColor: ArgonColors.white,
                                              color: ArgonColors.darkgreen,
                                              onPressed: _createUser,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16.0,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Text("UPDATE USER",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 16.0))),
                                            ),
                                          ),
                                          (widget.userdata['role']!='super_admin' || widget.userdata['role'] != widget.userdata['role'])?Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 0, right: 0, top: 8),
                                            child: RaisedButton(
                                              textColor: ArgonColors.white,
                                              color: ArgonColors.error,
                                              onPressed: (){
                                                if(widget.userdata['deactivate']==1){
                                                  showDisableAlert2();
                                                }else {
                                                  showDisableAlert();
                                                }
                                                },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(4.0),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0,
                                                      right: 16.0,
                                                      top: 12,
                                                      bottom: 12),
                                                  child: Text(widget.userdata['deactivate'] == 1?"ENABLE":"DISABLE",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 16.0))),
                                            ),
                                          ):SizedBox(),
                                        ],
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
                              offset: Offset(
                                  2, 3), // changes the position of the shadow
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
      );
    }
  }
}
