import 'dart:convert';

import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/OTPService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/Theme.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key , required this.data}) : super(key: key);
  final Map data;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String newPassword = '';
  bool passwordVisible1 = true;
  bool passwordVisible = true;

  String confirmPassword = '';
  bool isCallGoogle = false;
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  Future<void> _submit() async{
    // print('${myController2.value} ${myController1.value}');
    setState(() { isCallGoogle = true; });
    if(myController1.text == myController2.text) {
      var response = await UserService().ChangePassword(data: {
        "email": widget.data['email'],
        "password": myController1.text
      });
      Map res = jsonDecode(response);
      if (res['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['msg'].toString())));
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            // builder: (BuildContext context) => SuperAdminHome(),
            builder: (BuildContext context) =>
                Loginhome(),
          ),
              (
              route) => false, //if you want to disable back feature set to false
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['msg'].toString())));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Does not match')));
    }
    setState(() { isCallGoogle = false; });

  }
  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(isCallGoogle){
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
        backgroundColor: ArgonColors.secondary,
        appBar: AppBars(name: 'Create New Password' ,  islogout: false , isreload: false, context: context ,),
        body:
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(

                      child: SizedBox(
                        // width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              // Padding(padding: EdgeInsets.all(0),
                              //   child: Image.asset('assets/img/gtn-crop.jpg' , width: 200,height: 100,),
                              // ),
                              // Text('E Ticketing Platform - bridge to Solve issues' , style: TextStyle(fontSize:13.8,color: ArgonColors.text),) ,
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Create Password',maxLines: 1,
                                      style: TextStyle(
                                          color: ArgonColors.darkgreen,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                          fontFamily: 'OpenSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      obscureText: passwordVisible1,
                                      controller: myController1,
                                      decoration:  InputDecoration(
                                        // filled:true,
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible1
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                              color: ArgonColors.darkgreen,),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible1 =
                                                !passwordVisible1;
                                              });
                                            },

                                          ),
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
                                          labelStyle: TextStyle(
                                            color: ArgonColors.darkgreen,

                                          ),
                                          labelText: 'New Password',
                                          hoverColor: ArgonColors.darkgreen
                                      ),
                                      keyboardType: TextInputType.visiblePassword,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          newPassword = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ) {
                                          return 'Invalid password!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20,),

                                    TextFormField(

                                      controller: myController2,
                                      decoration:  InputDecoration(
                                        suffixIcon:  IconButton(
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
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                      ),
                                      keyboardType: TextInputType.visiblePassword,
                                      obscureText: passwordVisible,
                                      validator: (value) {
                                        if (value!.isEmpty && value.length < 7) {
                                          return 'Invalid password!';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          confirmPassword = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10,),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 0, right: 0, top: 8),
                                        child: RaisedButton(
                                          textColor: ArgonColors.white,
                                          color: ArgonColors.darkgreen,
                                          onPressed: _submit,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0, right: 16.0, top: 12, bottom: 12),
                                              child: Text("UPDATE",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600, fontSize: 16.0))),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                    )

                  ],
                ),
              ),
            ),

          ),
        ),
      );
    }
  }
}
