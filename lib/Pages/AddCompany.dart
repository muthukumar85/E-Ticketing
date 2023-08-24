import 'package:e_ticket_booking/Pages/Register.dart';
import 'package:e_ticket_booking/services/superAdminService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../Components/Appbar.dart';
import '../constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../superAdmin/HomeSAdmin.dart';


class AddCompany extends StatefulWidget {
  const AddCompany({Key? key , required this.userinfo , required this.data}) : super(key: key);
  final Map userinfo;
  final Map data;
  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late Map userinfo;
  bool isLoad = false;
  String CompanyName = '';
  bool passwordVisible = true;
  List<Map> roles =[];
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();

  void _createUser() async{
    setState(() {
      isLoad = true;
    });
    if(myController2.text != ''  ) {
      Map comdata = {
        "name":myController2.text,
        "created_id":widget.userinfo['id']
      };
      var res = await SuperAdmin().PostCompany(data: comdata);
      if(res['success']){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['msg'])));
        UserService().refresh(context);

      }else{
        setState(() {
          isLoad = false;
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all the fields')));
      setState(() {
        isLoad = false;
      });
    }

  }
  void _updateUser() async{
    setState(() {
      isLoad = true;
    });
    if(myController2.text != ''  ) {
      Map comdata = {
        "name":myController2.text,
        "id":widget.data['company_id']
      };
      var res = await SuperAdmin().PutCompany(data: comdata);
      if(res['success']){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['msg'])));
        UserService().refresh(context);
      }else{
        setState(() {
          isLoad = false;
        });
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all the fields')));
      setState(() {
        isLoad = false;
      });
    }

  }

  @override
  void initState() {
    userinfo = widget.userinfo;
    setState(() {
      if(widget.data.isNotEmpty){
        myController2.text = widget.data['company_name'];
      }
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
    });
    super.initState();
  }
  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();

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
                                            labelText: 'Enter Company',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        keyboardType: TextInputType.text,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            CompanyName = value;
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
                                    SizedBox(height: 20,),
                                    widget.data.isNotEmpty?SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            left: 0, right: 0, top: 8),
                                        child: RaisedButton(
                                          textColor: ArgonColors.white,
                                          color: ArgonColors.darkgreen,
                                          onPressed: _updateUser,
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
                                              child: Text("UPDATE COMPANY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 16.0))),
                                        ),
                                      ),
                                    ):SizedBox(
                                      width: double.infinity,
                                      child: Padding(
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
                                              child: Text("CREATE COMPANY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 16.0))),
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
