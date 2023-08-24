import 'dart:convert';

import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/Pages/PasswordChange.dart';
import 'package:e_ticket_booking/services/OTPService.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants/Theme.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String mobile = '';
  String OTP = '';
  bool isCallGoogle = false;
  bool isMailSubmit = false;
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  Future<void> _getotp() async {
    var response = await otpService().GenerateOTP(data: {
      "email":myController1.text
    });
    Map res = jsonDecode(response);
    if(res['success']){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP send successfully')));
      setState(() {
        isMailSubmit = false;
      });

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['msg'].toString())));
      setState(() {
        isMailSubmit = false;
      });
    }
  }
  Future<void> _submit() async{
    // print('${myController2.value} ${myController1.value}');
    setState(() { isCallGoogle = true; });
    var response = await otpService().VerifyOTP(data: {
      "email":myController1.text,
      "otp":int.parse(myController2.text.toString())
    });
    Map res = jsonDecode(response);
    if(res['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['msg'].toString())));
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          // builder: (BuildContext context) => SuperAdminHome(),
          builder: (BuildContext context) => ChangePassword(data: {"email":myController1.text},),
        ),
            (route) => false, //if you want to disable back feature set to false
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['msg'].toString())));
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
        appBar: AppBars(name: 'Forgot Password' ,  islogout: false , isreload: false, context: context ,),
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
                                    Text('Forgot Password',
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
                                      controller: myController1,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.person,
                                            color: ArgonColors.darkgreen,),
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
                                          labelText: 'Email',
                                          hoverColor: ArgonColors.darkgreen
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          mobile = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return 'Invalid email!';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 0, right: 0, top: 8),
                                        child: RaisedButton(
                                          textColor: ArgonColors.white,
                                          color: ArgonColors.indico,
                                          onPressed: isMailSubmit?null:()  {
                                            setState(() {
                                              isMailSubmit = true;
                                            });
                                            _getotp();

                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16.0, right: 16.0, top: 12, bottom: 12),
                                              child: isMailSubmit?
                                              Center(
                                                child: SpinKitCircle(
                                                  color: ArgonColors.white,
                                                  size: 20.0,
                                                ),
                                              )
                                                  : Text("GENERATE OTP",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600, fontSize: 16.0))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25,),
                                    TextFormField(
                                      controller: myController2,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.wifi_password,
                                          color: ArgonColors.darkgreen,),
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
                                        labelText: 'OTP',
                                        labelStyle: TextStyle(
                                          color: ArgonColors.darkgreen,

                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty && value.length < 7) {
                                          return 'Invalid OTP!';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          OTP = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 0,),
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
                                              child: Text("VALIDATE OTP",
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
