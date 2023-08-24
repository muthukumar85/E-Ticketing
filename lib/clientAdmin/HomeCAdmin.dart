import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/clientAdmin/Dashboard.dart';
import 'package:e_ticket_booking/clientAdmin/Master.dart';
import 'package:e_ticket_booking/clientAdmin/TicketsView.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:flutter/material.dart';




class ClientAdminHome extends StatefulWidget {
  const ClientAdminHome({Key? key , required this.userinfo , required this.Graphdata , required this.Reports , required this.Users , required this.Tickets , required this.Units }) : super(key: key);
  final Map userinfo;
  final Map Graphdata;
  final Map Units;
  final Map Reports;
  final Map Tickets;
  final Map Users;
  @override
  State<ClientAdminHome> createState() => _ClientAdminHomeState();
}

class _ClientAdminHomeState extends State<ClientAdminHome> {
  int _currentIndex = 0;
  late List<Widget> _pages ;
  @override
  void initState() {
    setState(() {
      _pages = [
        ClientAdminDashboard(graph: widget.Graphdata, userinfo: widget.userinfo, reports: widget.Reports,),
        ClientAdminTicket(userinfo: widget.userinfo, tickets: widget.Tickets, Units: widget.Units, ),
        ClientAdminMaster(userinfo: widget.userinfo, units: widget.Units, users: widget.Users,),
      ];
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(name:'(ClientAdmin) ${widget.userinfo['name'].toString().replaceFirst(widget.userinfo['name'][0], widget.userinfo['name'][0].toString().toUpperCase())}' , islogout: true , isreload: true, context: context ,),
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
