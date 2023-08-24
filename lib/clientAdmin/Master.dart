import 'dart:convert';

import 'package:e_ticket_booking/Pages/UpdateUser.dart';
import 'package:e_ticket_booking/clientAdmin/AddUnits.dart';
import 'package:e_ticket_booking/clientAdmin/UpdateUnits.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/Pages/AddUser.dart';
import 'package:flutter/material.dart';

class ClientAdminMaster extends StatefulWidget {
  const ClientAdminMaster({Key? key , required this.userinfo , required this.users , required this.units}) : super(key: key);
  final Map userinfo;
  final Map users;
  final Map units;
  @override
  State<ClientAdminMaster> createState() => _ClientAdminMasterState();
}

class _ClientAdminMasterState extends State<ClientAdminMaster> with TickerProviderStateMixin{
  late TabController _tabController = TabController(length: 2, vsync:this);
  late Map userinfo;
  List<dynamic> items = [];

  List<dynamic> units =[];
    // {
    //   'UnitName':"Unit 1",
    //   'UnitNumber':"56877",
    //   'UnitAddress':'678.888.56.77'
    // },
    // {
    //   'UnitName':"Unit 2",
    //   'UnitNumber':"56811",
    //   'UnitAddress':'678.088.51.77'
    // },
    // {
    //   'UnitName':"Unit 3",
    //   'UnitNumber':"56977",
    //   'UnitAddress':'678.688.46.74'
    // },
    // {
    //   'UnitName':"Unit 4",
    //   'UnitNumber':"36877",
    //   'UnitAddress':'678.868.56.17'
    // },

  // ];
  void assignValue(){
    try {
      setState(() {
        items = jsonDecode(jsonEncode(widget.users['result']));
        units = jsonDecode(jsonEncode(widget.units['result']));
        print(units);
        print(items);
      });
    }
    catch(e){}
  }
  @override
  void initState() {
    userinfo = widget.userinfo;
    assignValue();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
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
      text: 'Users',
    ),
        Tab(
          text: 'Units',
        ),
]
    ),
    Expanded(
    child: TabBarView(
    controller: _tabController,
    children: [
    Center(
    child:  Scaffold(
    floatingActionButton: FloatingActionButton.extended(
    // icon: Icon(Icons.add , color: ArgonColors.white,),
    backgroundColor: ArgonColors.darkgreen,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8)
    ),
    onPressed: () {
      print(widget.units['result'].toString() != '[]');
    if(widget.units['result'].toString() != '[]') {
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              AddUser(userinfo: userinfo, Company: {}, units: widget.units,),
        ), //if you want to disable back feature set to false
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar( content: Text('Create some units'),));
    }
    },
    label: Text('Add User' , style: TextStyle(color: ArgonColors.white),),
    ),
    body:  SingleChildScrollView(
    child: Container(
    child: Column(
    children: [
    SizedBox(
    height: MediaQuery.of(context).size.height/1.35,
    child: ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: items.length,
    itemBuilder: (context, index) {
      if(index == items.length - 1){
        return Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: makeusertile(data: items[index]),
        );
      }
    return makeusertile(data: items[index]);
    },
    ),
    ),

    ],
    ),
    ),
    ),
    ),
    ),
      Center(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            // icon: Icon(Icons.add , color: ArgonColors.white,),
            backgroundColor: ArgonColors.darkgreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
            ),
            onPressed: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AddUnit(userinfo: userinfo,),
                ),//if you want to disable back feature set to false
              );
            },
            label: Text('Add Units' , style: TextStyle(color: ArgonColors.white),),
          ),
          body:  SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/1.35,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: units.length,
                      itemBuilder: (context, index) {
                        return makeunitstile(data: units[index]);
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
  ]
    ))]
    );

  }
Widget makeusertile({required Map data}) =>Padding(
  padding: const EdgeInsets.only(left:8.0 , top: 8 , right: 8),
  child: InkWell(
    onTap: (){
      Navigator.push(context,
          MaterialPageRoute(builder: (
              BuildContext context) => UpdateUser(userinfo: userinfo , userdata:data))
      );
    },
    child: Card(
      child: ListTile(
        title: Text(data['name'] , style: TextStyle(color: ArgonColors.text , fontFamily: 'OpenSans'),),
        subtitle: Text(data['email'] , style: TextStyle(color: ArgonColors.text , fontFamily: 'OpenSans'
        ),maxLines: 1,),
        trailing: Column(
          children: [
            Text(data['unit_name']!=null ? data['unit_name']:'', style: TextStyle(color: ArgonColors.text),),
            Text(data['role'] , style: TextStyle(color: data['role'] == 'super_admin'?Colors.amber : data['role'] == 'client_admin'?ArgonColors.indico:data['role']=='client_hod'?Colors.green:Colors.red ,
            fontWeight: FontWeight.bold
            ),

            ),
          ],
        ),
      ),
    ),
  ),
);
  Widget makeunitstile({required Map data}) =>Padding(
    padding: const EdgeInsets.only(left:8.0 , top: 8 , right: 8),
    child: InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (
                BuildContext context) => UpdateUnit(userinfo: userinfo , unitdata:data))
        );

      },
      child: Card(
        child: ListTile(
          title: Text(data['name'] , style: TextStyle(color: ArgonColors.text , fontFamily: 'OpenSans'),),
          subtitle: Text(data['address'].toString() , style: TextStyle(color: ArgonColors.text , fontFamily: 'OpenSans'
          ),maxLines: 1,),
          trailing: Text(data['unit_number'].toString() , style: TextStyle(color: Colors.green ,
              fontWeight: FontWeight.bold
          ),
          ),
        ),
      ),
    ),
  );
}
