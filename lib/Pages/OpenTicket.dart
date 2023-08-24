import 'package:e_ticket_booking/Components/Appbar.dart';
import 'package:e_ticket_booking/Pages/TicketMessage.dart';
import 'package:e_ticket_booking/Pages/TicketViewMessage.dart';
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:e_ticket_booking/services/MessageService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OpenTicket extends StatefulWidget {
  const OpenTicket({Key? key , required this.data  , required this.userinfo}) : super(key: key);
  final Map data;
  final Map userinfo;
  @override
  State<OpenTicket> createState() => _OpenTicketState();
}

class _OpenTicketState extends State<OpenTicket> with TickerProviderStateMixin{
  TextEditingController _textEditingController = TextEditingController();
  late TabController _tabController = TabController(length: 2, vsync:this);
  late Map data;
  Map response = {};
  List<dynamic> solutions = [];
  String imgpath = '';
  List<dynamic> senders = [];
  void showImageAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Attachment File" , style: TextStyle(color: ArgonColors.text),),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data['attachment']!=null && data['attachment']!='undefined' && data['attachment']!='null'?Image.network(data['attachment']):Text('No File Found'),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void showSolutionAlert(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Ticket Solution" , style: TextStyle(color: ArgonColors.text , fontWeight: FontWeight.bold),),
        content: Card(
          elevation: 0,
          borderOnForeground: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                data['solution']!=null?Text(data['solution'] , style: TextStyle(
                  color: ArgonColors.text,
                  fontSize: 20
                ),):Text('Solution Not Yet Updated'),
                SizedBox(height: 20,),
                data['solution_attachment']!=null && data['solution_attachment']!='undefined'?Image.network(data['solution_attachment']):Text('No Solution File Found' , style: TextStyle(color: ArgonColors.warning),),
              ],
            ),
          ),
        ),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void getdata() async{
    // response = {};
    try {
      response = await MessageService().GetMsg(id: data['ticket_id']);
      print(response);
      solutions = response['result'];
      solutions.forEach((element) =>
      {
        senders.add(element['sender'])
      });
      senders = senders.toSet().toList();
      AssignInitial();
      solutions.sort((a, b) { //sorting in ascending order
        return DateTime.parse(a['timestamp']).compareTo(
            DateTime.parse(b['timestamp']));
      });
    }catch(e){}
    setState(() {

    });

  }



  void AssignInitial() {
    solutions.add({
      "ticket_id": widget.data['ticket_id'],
      "sender_id": widget.data['user_id'],
      "subject": widget.data['subject'],
      "content": widget.data['description'],
      "attachment": widget.data['attachment'],
      "timestamp": widget.data['created_time'],
      "sender":widget.data["username"]
    });
  }
  @override
  void initState() {
    setState(() {

      data = widget.data;
      print(data);
      getdata();

    });

    super.initState();
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBars(name: 'Ticket Details',  islogout: false , isreload: false, context: context ,),
        body:Column(
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
                  text: 'Details',
                ),
                Tab(
                  text: 'Solution Chat',
                ),
              ]
          ),
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [
                  SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container(
                //   constraints: BoxConstraints(
                //
                //
                //     maxHeight: MediaQuery.of(context).size.height/2.6,
                //   ),
                //   child: SingleChildScrollView(
                //     physics: ScrollPhysics(),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(data['subject'],softWrap: true,
                //           style: TextStyle(
                //               fontSize: 18 , color: ArgonColors.text , fontWeight: FontWeight.bold
                //           ),
                //
                //         ),
                //         SizedBox(height: 8,),
                //         Text(data['description'],softWrap: true,
                //           style: TextStyle(fontSize: 16 , color: ArgonColors.text),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // Padding(
                    //   padding:
                    //   const EdgeInsets.only(left: 0, right: 0, top: 8),
                    //   child: RaisedButton(
                    //     textColor: ArgonColors.white,
                    //     color: ArgonColors.info,
                    //     onPressed: () async {
                    //       Map response = await MessageService().GetMsg(id: data['ticket_id']);
                    //
                    //
                    //       // Navigator.push<dynamic>(
                    //       //   context,
                    //       //   MaterialPageRoute<dynamic>(
                    //       //     builder: (BuildContext context) => MessageViewhome(ticketinfo: data, solutions: response, userinfo: widget.userinfo,),
                    //       //   ),
                    //       // );
                    //     },
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(4.0),
                    //     ),
                    //     child: Padding(
                    //         padding: EdgeInsets.only(
                    //             left: 5.0, right: 5.0, top: 12, bottom: 12),
                    //         child: Row(
                    //           children: [
                    //             Icon(Icons.chat , color: ArgonColors.white,),
                    //             Padding(
                    //               padding: const EdgeInsets.only(left: 8.0),
                    //               child: Text("SOLUTION CHAT",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w600, fontSize: 15.0)),
                    //             ),
                    //           ],
                    //         )),
                    //   ),
                    // ),

                  ],
                ),

                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Number',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['ticket_id'].toString(),
                            style: TextStyle(fontSize: 16 , color: ArgonColors.text , ),
                          ),
                        ],
                      ),

                      SizedBox(height: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Name',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['clientname'],
                            style: TextStyle(fontSize: 16 , color: ArgonColors.text ,),
                          ),
                        ],
                      ),
                    ]),


                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Status',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['ticket_status'].toString().replaceFirst(data['ticket_status'][0],data['ticket_status'][0].toString().toUpperCase() ),
                            style: TextStyle(fontSize: 16 , color: data['ticket_status']=='unsolved'?ArgonColors.error:ArgonColors.success , fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      SizedBox(height: 0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket State',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['ticket_state'],
                            style: TextStyle(fontSize: 16 , color: data['ticket_state']=='closed'?ArgonColors.success:ArgonColors.pending , fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
                SizedBox(height: 16),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[


                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unit Name',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['units'],
                            style: TextStyle(fontSize: 16 , color: ArgonColors.text ,overflow: TextOverflow.ellipsis),maxLines: 1,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,color: ArgonColors.text
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            data['username'],
                            style: TextStyle(fontSize: 16 , color: ArgonColors.text ,overflow: TextOverflow.ellipsis),maxLines: 1,
                          ),
                        ],
                      ),
                    ]),

                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Created Date',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,color: ArgonColors.text
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(data['created_time']).toLocal()),
                          style: TextStyle(fontSize: 16 , color: ArgonColors.text),maxLines: 1,
                        ),
                      ],
                    ),
                    senders.isNotEmpty?Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Solved By',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,color: ArgonColors.text
                          ),
                        ),
                        SizedBox(height: 8),
                        // Text(
                        //   senders.toString().replaceFirst(senders.toString()[0], "").replaceFirst(senders.toString()[senders.toString().length - 1], "").replaceAll(",", "\n"),
                        //   style: TextStyle(fontSize: 16 , color: ArgonColors.text),
                        // ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:senders.map((e)=>Text(e , style: TextStyle(fontSize: 16 , color: ArgonColors.text),)).toList()
                        )
                      ],
                    ):SizedBox()
                  ],
                )




              ],
            ),
          ),
    ),
                    Stack(
                        children: [Container(
                          height: MediaQuery.of(context).size.height/1,
                          child: ListView.builder(
                            itemCount: solutions.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            itemBuilder: (context, index){
                              return Container(

                                padding: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
                                child: Align(
                                  alignment: (solutions[index]['sender_id'] != widget.data['user_id']?Alignment.topLeft:Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: solutions[index]['sender_id'] == 1?Color(0xFFAEDFFB): Color(0xFFF4F4F4),
                                    ),
                                    width: MediaQuery.of(context).size.width/1.2,
                                    child: Card(
                                      elevation: 5,
                                      color: solutions[index]['sender_id'] != widget.data['user_id']?ArgonColors.white: Color(0xFFF4F4F4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 0.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(solutions[index]['sender'] , style: TextStyle(color: ArgonColors.darkgreen ),)
                                                ],
                                              ),
                                            ),
                                            solutions[index]['subject']!=null?ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text(solutions[index]['subject']!=null?solutions[index]['subject']:'' , style: TextStyle(color: ArgonColors.text , fontSize: 18),),
                                              subtitle: Text(solutions[index]['content'].toString() ,
                                                style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                              ),
                                              dense: true,
                                              // leading: Text('32-33-2032 84:34'),
                                            ):ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Text(solutions[index]['content'].toString() ,
                                                style: TextStyle(color: ArgonColors.text , fontSize: 16),
                                              ),
                                              dense:true,
                                              // leading: Text('32-33-2032 84:34'),
                                            ),
                                            (solutions[index]['attachment']!=null && solutions[index]['attachment']!='undefined')?Image.network(solutions[index]['attachment']):SizedBox(),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(solutions[index]['timestamp']).toLocal()) , style: TextStyle(color: Colors.grey[600]),)
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
                            },
                          ),
                        ),
                          // SizedBox(height: 250,),
                        ]
                    )



                  ]
              ))
        ]
    ));

  }
  // Widget showpopup()=>AlertDialog(
  //   title: Text('Solution for Ticket'),
  //   content: Container(
  //     width: double.maxFinite,
  //     child: TextField(
  //       controller: _textEditingController,
  //       maxLines: 10,
  //       decoration: InputDecoration(
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: ArgonColors.darkgreen,
  //             width: 1.8,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           // borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(
  //             color: ArgonColors.darkgreen,
  //             width: 2.0,
  //           ),
  //         ),
  //         hintText: 'Enter Your Solution',
  //         // labelText: 'Solution',
  //         labelStyle: TextStyle(
  //           color: ArgonColors.darkgreen,
  //
  //         ),
  //       ),
  //     ),
  //   ),
  //   actions: [
  //     TextButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Cancel' , style: TextStyle(color: ArgonColors.darkgreen),),
  //     ),
  //     RaisedButton(
  //       textColor: ArgonColors.white,
  //       color: ArgonColors.darkgreen,
  //       onPressed: () {
  //         String message = _textEditingController.text;
  //
  //         Navigator.of(context).pop();
  //       },
  //       child: Text('Submit'),
  //     ),
  //   ],
  // );
}
