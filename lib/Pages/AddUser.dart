import 'dart:convert';

import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../Components/Appbar.dart';
import '../constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../superAdmin/HomeSAdmin.dart';


class AddUser extends StatefulWidget {
  const AddUser({Key? key , required this.userinfo , required this.Company , required this.units}) : super(key: key);
  final Map userinfo;
  final Map Company;
  final Map units;
  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Map userinfo;
  bool isLoad = false;
  String fullname = '';
  String email = '';
  String Username = '';
  String mobile = '';
  String password = '';
  String Role = '';
  String Company = '';
  int CompanyID = 0;
  String Unit = '';
  int UnitID = 0;
  List<dynamic> units = [];
  List<dynamic> companies = [];
  bool passwordVisible = true;
   List<Map> roles =[];
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();
  TextEditingController myController5 = TextEditingController();
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
          if (Role == 'client_admin') {
            if (myController2.text != '' && myController3.text != '' &&
                myController4.text != '' && myController5.text != '' &&
                Role != '' && Company != '') {
              Map<dynamic, dynamic> list = companies.firstWhere((element) {
                return element['company_name'] == Company;
              });

              Map userdata = {
                'username': myController2.text,
                'password': myController3.text,
                'mobile': myController4.text,
                'email': myController5.text,
                'role': Role,
                'created_by': userinfo['id'],
                'created_by_role': userinfo['role'],
                'company_id': list['company_id'],
                'unit_id': 0
              };
              await UserService().CreateUser(
                  userdata: userdata, context: context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fill all the fields')));
            }
          } else {
            if (Role == 'user') {
              if (myController2.text != '' && myController3.text != '' &&
                  myController4.text != '' && myController5.text != '' &&
                  Role != '' && Unit != '') {
                Map<dynamic, dynamic> list = units.firstWhere((element) {
                  return element['name'] == Unit;
                });

                Map userdata = {
                  'username': myController2.text,
                  'password': myController3.text,
                  'mobile': myController4.text,
                  'email': myController5.text,
                  'role': Role,
                  'created_by': userinfo['id'],
                  'created_by_role': userinfo['role'],
                  'company_id': userinfo['company_id'],
                  'unit_id': list['unit_id']
                };
                await UserService().CreateUser(
                    userdata: userdata, context: context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fill all the fields')));
              }
            } else {
              if (Role == 'client_hod') {
                if (myController2.text != '' && myController3.text != '' &&
                    myController4.text != '' && myController5.text != '' &&
                    Role != '') {
                  Map userdata = {
                    'username': myController2.text,
                    'password': myController3.text,
                    'mobile': myController4.text,
                    'email': myController5.text,
                    'role': Role,
                    'created_by': userinfo['id'],
                    'created_by_role': userinfo['role'],
                    'company_id': userinfo['company_id'],
                    'unit_id': 0
                  };

                  await UserService().CreateUser(
                      userdata: userdata, context: context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fill all the fields')));
                }
              }
              else {
                if (myController2.text != '' && myController3.text != '' &&
                    myController4.text != '' && myController5.text != '' &&
                    Role != '') {
                  Map userdata = {
                    'username': myController2.text,
                    'password': myController3.text,
                    'mobile': myController4.text,
                    'email': myController5.text,
                    'role': Role,
                    'created_by': userinfo['id'],
                    'created_by_role': userinfo['role'],
                    'company_id': 0,
                    'unit_id': 0
                  };

                  await UserService().CreateUser(
                      userdata: userdata, context: context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fill all the fields')));
                }
              }
            }
          }
        }
      } else {
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
        companies = widget.Company['result'];
      }else{
        roles=[
          { 'show':'ClientHOD' , 'value':'client_hod' },
          { 'show':'User' , 'value':'user' },
        ];
        units = widget.units['result'];
      }
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
          appBar: AppBars(name: 'Add User' ,  islogout: false , isreload: false, context: context ,),
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
                                                width: 1.2,
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
                                        controller: myController3,
                                        obscureText: passwordVisible,
                                        decoration: InputDecoration(
                                          // filled:true,
                                            suffixIcon: IconButton(
                                              icon: Icon(passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                                color: ArgonColors.darkgreen,),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisible =
                                                  !passwordVisible;
                                                });
                                              },

                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ArgonColors.white,
                                                width: 1.2,
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
                                            labelText: 'Password',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        keyboardType: TextInputType
                                            .visiblePassword,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid pass!';
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
                                                width: 1.2,
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
                                              width: 1.2,
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
                                    Card(
                                      elevation: 3,
                                      child: DropdownButtonFormField(
                                        icon: Icon(Icons.arrow_drop_down,
                                          color: ArgonColors.darkgreen,),
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: ArgonColors.white,
                                                width: 1.2,
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
                                            labelText: 'Select Role',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        value: Role.isNotEmpty ? Role : null,
                                        onChanged: (newValue) {
                                          setState(() {
                                            Role = newValue.toString();
                                          });
                                        },
                                        items: roles.map((session) {
                                          return DropdownMenuItem(
                                            value: session['value'],
                                            child: Text(session['show']),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Role == 'client_admin'?DropdownButtonFormField(
                                      icon: Icon(Icons.arrow_drop_down,
                                        color: ArgonColors.darkgreen,),
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ArgonColors.darkgreen,
                                              width: 1.2,
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
                                          labelText: 'Select Company',
                                          hoverColor: ArgonColors.darkgreen
                                      ),
                                      value: Company.isNotEmpty ? Company : null,
                                      onChanged: (newValue) {
                                        setState(() {
                                          print(newValue);

                                          Company = newValue.toString();
                                        });
                                      },
                                      items: companies.map((session) {
                                        return DropdownMenuItem(
                                          value: session['company_name'],
                                          child: Text(session['company_name']),
                                        );
                                      }).toList(),
                                    ):SizedBox(),

                                    Role == 'user'?DropdownButtonFormField(
                                      icon: Icon(Icons.arrow_drop_down,
                                        color: ArgonColors.darkgreen,),
                                      decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: ArgonColors.darkgreen,
                                              width: 1.2,
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
                                      value: Unit.isNotEmpty ? Unit : null,
                                      onChanged: (newValue) {
                                        setState(() {
                                          print(newValue);

                                          Unit = newValue.toString();
                                        });
                                      },
                                      items: units.map((session) {
                                        return DropdownMenuItem(
                                          value: session['name'],
                                          child: Text(session['name']),
                                        );
                                      }).toList(),
                                    ):SizedBox(),
                                    SizedBox(height: 20,),
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
                                                  child: Text("CREATE USER",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 16.0))),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                left: 0, right: 0, top: 8),
                                            child: RaisedButton(
                                              textColor: ArgonColors.darkgreen,
                                              color: ArgonColors.white,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
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
                                                  child: Text("CANCEL",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          fontSize: 16.0))),
                                            ),
                                          ),
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
