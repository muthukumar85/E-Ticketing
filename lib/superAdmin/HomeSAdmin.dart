import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/services/superAdminService.dart';
import 'package:e_ticket_booking/superAdmin/Dashboard.dart';
import 'package:e_ticket_booking/superAdmin/Master.dart';
import 'package:e_ticket_booking/superAdmin/TicketsView.dart';
import 'package:flutter/material.dart';




class SuperAdminHome extends StatefulWidget {
  const SuperAdminHome({Key? key ,required this.userinfo , required this.Graphdata , required this.ClientWiseDetails , required this.Reports , required this.Tickets , required this.Users , required this.Company}) : super(key: key);
  final Map userinfo;
  final Map Graphdata;
  final Map ClientWiseDetails;
  final Map Reports;
  final Map Tickets;
  final Map Users;
  final Map Company;
  @override
  State<SuperAdminHome> createState() => _SuperAdminHomeState();
}

class _SuperAdminHomeState extends State<SuperAdminHome> {
  int _currentIndex = 0;
  late List<Widget> _pages ;


  @override
  void initState() {
      setState(() {
        _pages = [
          SuperAdminDashboard(userinfo: widget.userinfo,
            reports: widget.Reports,
            graph: widget.Graphdata,
            clientwisedetail: widget.ClientWiseDetails, tickets: widget.Tickets,),
          SuperAdminTicket(userinfo: widget.userinfo, tickets: widget.Tickets,),
          SuperAdminMaster(userinfo: widget.userinfo, users: widget.Users, Company: widget.Company,),
        ];
      });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(name: '(SuperAdmin) ${widget.userinfo['name'].toString().replaceFirst(widget.userinfo['name'][0], widget.userinfo['name'][0].toString().toUpperCase())}'  ,  islogout: true , isreload: true, context: context ,),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: ArgonColors.darkgreen,
        unselectedItemColor: ArgonColors.text,
        selectedItemColor: ArgonColors.darkgreen,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold
        ),
        selectedIconTheme: IconThemeData(
          size: 28
        ),
        unselectedIconTheme: IconThemeData(
          size: 26
        ),
        selectedFontSize: 17,
        unselectedFontSize: 15,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.line_axis_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Master',
          ),
        ],

      ),
    );
  }
}
