import 'package:e_ticket_booking/services/clientAdminService.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:flutter/material.dart';

import '../Components/Appbar.dart';
import '../constants/Theme.dart';

class AddUnit extends StatefulWidget {
  const AddUnit({Key? key , required this.userinfo}) : super(key: key);
  final Map userinfo;
  @override
  State<AddUnit> createState() => _AddUnitState();
}

class _AddUnitState extends State<AddUnit> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String Unitname = '';
  String Unitnumber = '';
  String Unitaddress='';

  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();

  void _createUnit()async{
    if(myController1.text != '' && myController2.text != '' && myController3.text != '') {
      var response = await ClientAdmin().CreateUnits(data: {
        "unit_number": myController2.text,
        "unit_name": myController1.text,
        "unit_address": myController3.text,
        "id": widget.userinfo['id']
      });
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unit Created Successfully')));
        UserService().refresh(context);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fill all the fields')));
    }
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
                                  Card(
                                    elevation:3,
                                    child: TextFormField(
                                      controller: myController1,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.ad_units,
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
                                  ),
                                  const SizedBox(height: 20,),
                                  Card(
                                    elevation: 3,
                                    child: TextFormField(
                                      controller: myController2,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.numbers_outlined,
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
                                  ),
                                  const SizedBox(height: 20,),

                                  Card(
                                    elevation: 3,
                                    child: TextFormField(
                                      controller: myController3,
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
                                  ),
                                  const SizedBox(height: 20,),


                                  SizedBox(height: 20,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 0, right: 0, top: 8),
                                          child: RaisedButton(
                                            textColor: ArgonColors.white,
                                            color: ArgonColors.darkgreen,
                                            onPressed: _createUnit,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16.0, top: 12, bottom: 12),
                                                child: Text("CREATE UNIT",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600, fontSize: 16.0))),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 0, right: 0, top: 8),
                                          child: RaisedButton(
                                            textColor: ArgonColors.darkgreen,
                                            color: ArgonColors.white,
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                            child: const Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0, right: 16.0, top: 12, bottom: 12),
                                                child: Text("CANCEL",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600, fontSize: 16.0))),
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
