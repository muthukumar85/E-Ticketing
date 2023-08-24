import 'dart:convert';

import 'package:e_ticket_booking/Pages/AddCompany.dart';
import 'package:e_ticket_booking/Pages/UpdateUser.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/Pages/AddUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuperAdminMaster extends StatefulWidget {
  const SuperAdminMaster({Key? key , required this.userinfo , required this.users , required this.Company}) : super(key: key);
  final Map userinfo;
  final Map users;
  final Map Company;
  @override
  State<SuperAdminMaster> createState() => _SuperAdminMasterState();
}

class _SuperAdminMasterState extends State<SuperAdminMaster> with TickerProviderStateMixin{
  late TabController _tabController = TabController(length: 2, vsync:this);
  late Map userinfo;
  List<dynamic> items = [];
  void assignValue(){
    try{
    setState(() {
      items = jsonDecode(jsonEncode(widget.users['result']));
    });}
        catch(e){}
  }
  @override
  void initState() {
    assignValue();
    print(widget.Company);
    setState(() {
      userinfo = widget.userinfo;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
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
                    text: 'Companies',
                  ),
                ]
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                    Scaffold(
                    floatingActionButton: FloatingActionButton.extended(
    // icon: Icon(Icons.add , color: ArgonColors.white,),
    backgroundColor: ArgonColors.darkgreen,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8)
    ),
    onPressed: () {
      if(widget.Company['result'].toString()!='[]') {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                AddUser(userinfo: userinfo,
                  Company: widget.Company,
                  units: {},),
          ), //if you want to disable back feature set to false
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Company')));
      }
    },
    label: Text('Add User' , style: TextStyle(color: ArgonColors.white),),
    ),
    body: SingleChildScrollView(
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
                      ),),
    Scaffold(
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
    builder: (BuildContext context) => AddCompany(userinfo: userinfo,data:{}),
    ),//if you want to disable back feature set to false
    );
    },
    label: Text('Add Company' , style: TextStyle(color: ArgonColors.white),),
    ),
    body:
    SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height/1.35,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: widget.Company['result'].length,
                                  itemBuilder: (context, index) {
                                    return makecompanytile(data: widget.Company['result'][index]);
                                  },
                                ),
                              ),

                            ],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            data['role']!='super_admin'?data['deactivate']==1 ?Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: ArgonColors.error,
                borderRadius: BorderRadius.circular(4)
              ),
              child: Text(
                'Inactive',
                style: TextStyle(color: Colors.white),
              ),
            ):Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                  color: ArgonColors.success,
                  borderRadius: BorderRadius.circular(4)
              ),
              child: Text(
                'Active',
                style: TextStyle(color: Colors.white),
              ),
            ):SizedBox()  ,
            Text( data['role'].toString().replaceAll('_', ' ').replaceFirst(data['role'].toString().replaceAll('_', ' ')[0], data['role'].toString().replaceAll('_', ' ')[0].toUpperCase()) ,
              style: TextStyle(color: data['role'] == 'super_admin'?Colors.orange : data['role'] == 'client_admin'?ArgonColors.indico:data['role']=='client_hod'?Colors.green:Colors.red ,
            fontWeight: FontWeight.bold
            ),

            ),
          ],
        ),
      ),
    ),
  ),
);
Widget makecompanytile({required Map data}) =>Padding(
    padding: const EdgeInsets.only(left:8.0 , top: 8 , right: 8),
    child: InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (
                BuildContext context) => AddCompany(userinfo: userinfo , data:data))
        );
      },
      child: Card(
        child: ListTile(
          title: Text(data['company_name'] , style: TextStyle(color: ArgonColors.text , fontFamily: 'OpenSans'),),

          // trailing: Icon(Icons.delete)
        ),
      ),
    ),
  );
}
