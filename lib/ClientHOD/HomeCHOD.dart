import 'package:e_ticket_booking/ClientHOD/Dashboard.dart';
import 'package:e_ticket_booking/ClientHOD/TicketsView.dart';
import 'package:e_ticket_booking/Components/Appbar.dart';

import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:flutter/material.dart';





class ClientHODHome extends StatefulWidget {
  const ClientHODHome({Key? key , required this.userinfo, required this.Graphdata , required this.Reports , required this.Tickets}) : super(key: key);
  final Map userinfo;
  final Map Graphdata;
  final Map Reports;
  final Map Tickets;
  @override
  State<ClientHODHome> createState() => _ClientHODHomeState();
}

class _ClientHODHomeState extends State<ClientHODHome> {
  int _currentIndex = 0;
  late List<Widget> _pages ;
  @override
  void initState() {
    setState(() {
      _pages = [
        ClientHODDashboard(graph: widget.Graphdata, userinfo: widget.userinfo, reports: widget.Reports,),
        ClientHODTicket(userinfo: widget.userinfo, tickets: widget.Tickets,),

      ];
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(name: '(Client HOD) ${widget.userinfo['name'].toString().replaceFirst(widget.userinfo['name'][0], widget.userinfo['name'][0].toString().toUpperCase())}', islogout: true , isreload: true, context: context ,),
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
        ],

      ),
    );
  }
}
