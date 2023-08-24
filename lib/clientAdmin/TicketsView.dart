
import 'package:e_ticket_booking/ClientUser/UpdateTicket.dart';
import 'package:e_ticket_booking/Pages/CreateTicket.dart';
import 'package:e_ticket_booking/Pages/OpenTicket.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/superAdmin/SolveTicket.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
class ClientAdminTicket extends StatefulWidget {
  const ClientAdminTicket({Key? key , required this.userinfo , required this.tickets , required this.Units}) : super(key: key);
  final Map userinfo;
  final Map tickets;
  final Map Units;
  @override
  State<ClientAdminTicket> createState() => _ClientAdminTicketState();
}

class _ClientAdminTicketState extends State<ClientAdminTicket> {
   String selectedOption ='Unsolved Tickets';
   List<dynamic> items = [];
   void assignTickets(){
     try {
       if (selectedOption == 'Unsolved Tickets') {
         setState(() {
           items = widget.tickets['unsolved'];
           items.sort((a,b) {
             var adate = a['created_time'];
             var bdate = b['created_time'];
             return bdate.compareTo(adate);
           });
         });
       }
       else {
         setState(() {
           items = widget.tickets['solved'];
           items.sort((a,b) {
             var adate = a['created_time'];
             var bdate = b['created_time'];
             return bdate.compareTo(adate);
           });
         });
       }
     }catch(e){}
   }
   @override
  void initState() {
    assignTickets();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        // icon: Icon(Icons.add , color: ArgonColors.white,),
        backgroundColor: ArgonColors.darkgreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        onPressed: () {
          if(widget.Units.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Units Found')));
          }
          else {
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) =>
                    CreateTicket(
                      userinfo: widget.userinfo, Units: widget.Units,),
              ), //if you want to disable back feature set to false
            );
          }
        },
        label: Text('Create Ticket' , style: TextStyle(color: ArgonColors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedOption,
                      icon: selectedOption=='Unsolved Tickets'?Transform.rotate(
                          angle: 45 * math.pi / 180,
                          child: Icon(Icons.add_circle , color: ArgonColors.error,)):Icon(Icons.check_circle , color: ArgonColors.success,),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue!;
                          assignTickets();
                        });
                      },
                      items: <String>['Unsolved Tickets', 'Solved Tickets'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: value=='Solved Tickets'?Text(value , style: TextStyle(color: ArgonColors.success),):Text(value , style: TextStyle(color: ArgonColors.error),),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: items.map((e) => makereportstiles(data: e)).toList()

              ),
            ),
          ],
        ),
      ),
    );
  }
   Widget makereportstiles({required Map data}) => InkWell(
     onTap: ()
     {
      print(data['user_id']== widget.userinfo['id']);
       if(data['user_id']== widget.userinfo['id']) {
         Navigator.push<dynamic>(
           context,
           MaterialPageRoute<dynamic>(
             builder: (BuildContext context) => UpdateTicket(data: data, userinfo: widget.userinfo,),
           ),
         );
       }else{

         Navigator.push<dynamic>(
           context,
           MaterialPageRoute<dynamic>(
             builder: (BuildContext context) => OpenTicket(data: data, userinfo: widget.userinfo,),
           ),
         );
       }
     },
     child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 3),
       child: Container(
         height: 90,
         child: Card(

           elevation: 3,

           shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(8),

           ),

           child: Padding(
             padding: const EdgeInsets.only(bottom: 0 , top: 0 , right: 6 , left: 0),
             child: Row(

               crossAxisAlignment: CrossAxisAlignment.center,

               children: [
                 Container(
                   width: 10,
                   height: double.infinity,
                   decoration: BoxDecoration(
                       color: data["ticket_state"]=="closed"?ArgonColors.success:data["ticket_state"]=="pending"?ArgonColors.pending:ArgonColors.pending,
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(8) ,bottomLeft: Radius.circular(8) )
                   ),
                 ),
                 SizedBox(width: 15),



                 Expanded(

                   child: Column(

                     mainAxisAlignment: MainAxisAlignment.center,

                     crossAxisAlignment: CrossAxisAlignment.start,

                     children: [

                       Container(
                         width:MediaQuery.of(context).size.width / 1.9,
                         child: Text(

                           // data['name'].toString() ,
                           data['subject'],
                           style: TextStyle(
                             color: ArgonColors.text,
                             fontSize: 16,
                             overflow: TextOverflow.ellipsis,

                             // fontWeight: FontWeight.bold,

                           ),
                           maxLines: 1,

                         ),
                       ),

                       SizedBox(height: 8),

                       Text(

                         'Ticket No: ' + data['ticket_id'].toString(),

                         style: TextStyle(fontSize: 14 , color: ArgonColors.text , overflow: TextOverflow.ellipsis ,fontWeight: FontWeight.bold),maxLines: 1,

                       ),

                     ],

                   ),

                 ),

                 SizedBox(width: 3),
                 SizedBox(
                   width: MediaQuery.of(context).size.width / 3.5,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(data['units']!=null?data['units']:'' , style: TextStyle(color: ArgonColors.text , fontWeight: FontWeight.bold),),
                       Padding(padding: EdgeInsets.only(top: 4 , bottom: 2),
                           child:Text( data['username'],
                             style: TextStyle( color: ArgonColors.success, fontSize: 14  , fontWeight: FontWeight.w500 , overflow: TextOverflow.ellipsis),maxLines: 1,)
                       ),
                     ],
                   ),
                 ),

               ],

             ),
           ),

         ),
       ),
     ),
   );
}
