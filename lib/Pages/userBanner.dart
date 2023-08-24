import 'package:e_ticket_booking/constants/Theme.dart';
import 'package:flutter/material.dart';

class UserBanner extends StatefulWidget {
  const UserBanner({Key? key , required this.userinfo}) : super(key: key);
  final Map userinfo;
  @override
  State<UserBanner> createState() => _UserBannerState();
}

class _UserBannerState extends State<UserBanner> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0 , horizontal: 15),
        child: Card(
          elevation: 4,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ArgonColors.white, // Customize the banner background color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/img/nulldp.jpg'), // Replace with the user's profile picture URL
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userinfo['name'].toString().replaceFirst(widget.userinfo['name'][0], widget.userinfo['name'][0].toString().toUpperCase()), // Replace with the user's name
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:ArgonColors.text,
                        // Customize the user name color
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: ArgonColors.darkgreen,
                          borderRadius: BorderRadius.circular(5)

                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          widget.userinfo['role'] == 'super_admin'?'Super Admin':widget.userinfo['role']== 'client_admin'?'Admin':widget.userinfo['role']=='client_hod'?'HOD':'User', // Replace with the user's profession or role
                          style: TextStyle(
                            fontSize: 16,
                            color: ArgonColors.white, // Customize the profession/role color
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // SizedBox(height: 16),
                // Text(
                //   'Email: johndoe@example.com', // Replace with the user's email address
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.white, // Customize the email color
                //   ),
                // ),
                // SizedBox(height: 8),
                // Text(
                //   'Phone: +1 (123) 456-7890', // Replace with the user's phone number
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: Colors.white, // Customize the phone number color
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
