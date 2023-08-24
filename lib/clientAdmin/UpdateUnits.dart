import 'package:e_ticket_booking/services/clientAdminService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../Components/Appbar.dart';
import '../constants/Theme.dart';

class UpdateUnit extends StatefulWidget {
  const UpdateUnit({Key? key , required this.userinfo , required this.unitdata}) : super(key: key);
  final Map userinfo;
  final Map unitdata;
  @override
  State<UpdateUnit> createState() => _UpdateUnitState();
}

class _UpdateUnitState extends State<UpdateUnit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String Unitname = '';
  String Unitnumber = '';
  String Unitaddress='';

  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  void showDisableAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Delete Units"),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: Text('Do you Want to Delete Units?' , style: TextStyle(color: ArgonColors.text ,fontSize: 16),),
        ),
        actions: [
          RaisedButton(
            child: Text("YES" , style: TextStyle(color: ArgonColors.white),),
            color: ArgonColors.error,
            onPressed: () async {
              _deleteUnits();
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
  void _updateUnit()async{
    var response = await ClientAdmin().UpdateUnits(data: {
      "unit_number":myController2.text,
      "unit_name":myController1.text,
      "unit_address":myController3.text,
      "id":widget.unitdata['unit_id']
    });
    if(response['success'] == true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['msg'].toString())));
      UserService().refresh(context);
    }
  }
  void _deleteUnits()async{
    var response = await ClientAdmin().DeleteUnits(data: {
      "id":widget.unitdata['unit_id']
    });
    if(response['success'] == true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['msg'].toString())));
      UserService().refresh(context);
    }
  }
  @override
  void initState() {
    myController1.text = widget.unitdata['name'];
    myController2.text = widget.unitdata['unit_number'].toString();
    myController3.text = widget.unitdata['address'].toString();
    super.initState();
  }
  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars(name: 'Add Units', islogout: false , isreload: false, context: context , ),
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
                                  TextFormField(
                                    controller: myController1,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                        suffixIcon: Icon(Icons.ad_units,
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
                                        labelText: 'UnitName',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        Unitname = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Invalid!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller: myController2,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                        suffixIcon: Icon(Icons.numbers_outlined,
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
                                        labelText: 'UnitNumber',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        Unitnumber = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty ) {
                                        return 'Invalid user!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20,),

                                  TextFormField(
                                    controller: myController3,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                        suffixIcon: Icon(Icons.keyboard,
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
                                        labelText: 'UnitAdress',
                                        hoverColor: ArgonColors.darkgreen
                                    ),
                                    keyboardType: TextInputType.text,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        Unitaddress = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty ) {
                                        return 'Invalid mobile!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20,),


                                  SizedBox(height: 20,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 0, right: 0, top: 8),
                                      child: RaisedButton(
                                        textColor: ArgonColors.white,
                                        color: ArgonColors.darkgreen,
                                        onPressed: _updateUnit,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.0),
                                        ),
                                        child: const Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.0, right: 16.0, top: 12, bottom: 12),
                                            child: Text("UPDATE UNIT",
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
