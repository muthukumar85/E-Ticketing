
import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TicketChart extends StatefulWidget {
  final int openTickets;
  final int closedTickets;
  final String name;

  TicketChart({required this.openTickets, required this.closedTickets , required this.name});
  @override
  State<TicketChart> createState() => _TicketChartState();
}

class _TicketChartState extends State<TicketChart> {
  List<int> calculatePercentage(int total, int num1, int num2) {
    // Calculate the percentages

      double percentage1 = num1!=0?(num1 / (num1 + num2)) * 100:0;

    double percentage2 = num2!=0?(num2 / (num1 + num2)) * 100:0;
    print(percentage1);
    print(percentage2);
    // Calculate the respective portions
    int portion1 = 0;
    int portion2 = 0;

      portion1 = (total * (percentage1 / 100)).round();


      portion2 = (total * (percentage2 / 100)).round();


    print(portion1);
    print(portion2);
    print("hello");
    if(portion1 == 0 && portion2 == 0){
      portion1 = 20;
      portion2 = 20;
    }else {
      if (portion1 == 0) {
        portion2 -= 20;
        portion1 += 20;
      }
      if (portion2 == 0) {
        portion1 -= 20;
        portion2 += 20;
      }
    }

    return [portion1, portion2];
  }
  late List<dynamic> result;
  @override
  void initState() {
     setState(() {
       print(widget.openTickets);
       print(widget.closedTickets);
       result = calculatePercentage(240, widget.openTickets, widget.closedTickets );

     });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 14 , vertical: 4),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       SizedBox(
    //         width: 60,
    //           child: Text( widget.name, style: TextStyle(fontSize: 18 , color: ArgonColors.text ),)),
    //       SizedBox(
    //         width: 260,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Container(
    //               width: double.parse(result[0].toString()),
    //               height: 40,
    //               decoration: BoxDecoration(
    //                 color: ArgonColors.secondarygreen,
    //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(5) , bottomLeft: Radius.circular(5))
    //               ),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(widget.openTickets.toString() , style: TextStyle(color: ArgonColors.white , fontSize: 16),),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               width: double.parse(result[1].toString()),
    //               height: 40,
    //               decoration: BoxDecoration(
    //                   color: ArgonColors.darkgreen,
    //                   borderRadius: BorderRadius.only(topRight: Radius.circular(5) , bottomRight: Radius.circular(5))
    //               ),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(widget.closedTickets.toString() , style: TextStyle(color: ArgonColors.white , fontSize: 16),),
    //                 ],
    //               ),
    //
    //             ),
    //
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14 , vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: 60,
              child: Text( widget.name, style: TextStyle(fontSize: 18 , color: ArgonColors.text ),maxLines: 1,)),
          SizedBox(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.parse(result[0].toString()),
                  height: 30,
                  decoration: BoxDecoration(
                      color: ArgonColors.error,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(5) , bottomLeft: Radius.circular(5))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.openTickets.toString() , style: TextStyle(color: ArgonColors.white , fontSize: 16),),
                    ],
                  ),
                ),
                Container(
                  width: double.parse(result[1].toString()),
                  height: 30,
                  decoration: BoxDecoration(
                      color: ArgonColors.success,
                      // borderRadius: BorderRadius.only(topRight: Radius.circular(5) , bottomRight: Radius.circular(5))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.closedTickets.toString() , style: TextStyle(color: ArgonColors.white , fontSize: 16),),
                    ],
                  ),

                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrdinalSales {
  final String category;
  final int sales;

  OrdinalSales(this.category, this.sales);
}
