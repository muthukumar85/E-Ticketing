

import 'package:e_ticket_booking/ClientHOD/HomeCHOD.dart';
import 'package:e_ticket_booking/ClientUser/TicketsView.dart';
import 'package:e_ticket_booking/Pages/ForgotPassword.dart';
import 'package:e_ticket_booking/clientAdmin/HomeCAdmin.dart';
import 'package:e_ticket_booking/services/userService.dart';
import 'package:e_ticket_booking/superAdmin/HomeSAdmin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/Theme.dart';
import '../global/globals.dart';
// import '../services/loginWithCredentials.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class Loginhome extends StatefulWidget {

   Loginhome({Key? key}) : super(key: key);

  @override
  State<Loginhome> createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {

  bool isCallGoogle = true;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String mobile = "";
  String password = "";
  Map mainresponse = {};

  //submit form ------------------
  Future<void> _submit() async{
    // print('${myController2.value} ${myController1.value}');

    setState(() { isCallGoogle = true; });

    Map response = await UserService().loginWithCredentials(
       mobile: myController1.text, password: myController2.text, context: context);
    print(response);
    if(response['success'] == true){
      setState(() {
        mainresponse = response;
      });
      if(response['result']['role'] == 'super_admin'){
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            // builder: (BuildContext context) => SuperAdminHome(),
            builder: (BuildContext context) => SuperAdminHome(
              userinfo: response['result'],
              Users: response['Users'],
              Reports: response['Reports'],
              Tickets: response['Tickets'],
              Graphdata: response['Graphdata'],
              ClientWiseDetails: response['ClientWiseDetails'],
              Company: response['Company'],

            ),
          ),
              (route) => false,//if you want to disable back feature set to false
        );
         }else{
        if(response['result']['role'] == 'client_admin'){
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              // builder: (BuildContext context) => SuperAdminHome(),
              builder: (BuildContext context) => ClientAdminHome(
                Units: response['Units'],
                Graphdata: response['Graphdata'],
                Tickets: response['Tickets'],
                Reports: response['Reports'],
                Users: response['Users'],
                userinfo: response['result'],
              ),
            ),
                (route) => false,//if you want to disable back feature set to false
          );
        }else{
          if(response['result']['role'] == 'client_hod'){
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                // builder: (BuildContext context) => SuperAdminHome(),
                builder: (BuildContext context) => ClientHODHome(
                  Tickets: response['Tickets'],
                  Graphdata: response['Graphdata'],
                  userinfo: response['result'],
                  Reports: response['Reports'],


                ),
              ),
                  (route) => false,//if you want to disable back feature set to false
            );
          }
          else{
            if(response['result']['role'] == 'user'){
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  // builder: (BuildContext context) => SuperAdminHome(),
                  builder: (BuildContext context) => ClientUserTicket(
                    tickets: response['Tickets'], userinfo: response['result'],
                  ),
                ),
                    (route) => false,//if you want to disable back feature set to false
              );
            }
          }
        }
      }
    }
    else{
      setState(() { isCallGoogle = false; });
    }


  }
  //google login ---------------------
  Future<void> loginCredential() async {

    setState(() { isCallGoogle = true; });
    // dynamic users= await LoginWithCredentials.signInWithGoogle(context: context);
    setState(() { isCallGoogle = false; });


    // print(users);

  }
  Future<void> InitialCall() async {
    setState(() { isCallGoogle = true; });
    final _secureStorage = const FlutterSecureStorage();
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var mobileRead =
        await _secureStorage.read(key: 'mobile', aOptions: _getAndroidOptions());
    var passwordRead =
    await _secureStorage.read(key: 'password', aOptions: _getAndroidOptions());
    if(mobileRead != null && passwordRead != null){
      setState(() { isCallGoogle = true; });
      myController1.text = mobileRead;
      myController2.text = passwordRead;
      _submit();


    }else{
      setState(() { isCallGoogle = false; });
    }
  }
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  bool passwordVisible = true;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }
  @override
  void initState() {
    InitialCall();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isCallGoogle){
      return Scaffold(
          body:Center(
            child: SpinKitCircle(
              color: ArgonColors.darkgreen,
              size: 100.0,
            ),
          ));
    }
    else {
      return Scaffold(
        backgroundColor: ArgonColors.secondary,
        appBar: AppBar(

          title: Text('E Ticketing' , style: TextStyle(color: ArgonColors.text),),
          backgroundColor: ArgonColors.white,


        ),
        body:
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(

                      child: SizedBox(
                        // width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              Padding(padding: EdgeInsets.all(0),
                              child: Image.asset('assets/img/gtn-crop.jpg' , width: 200,height: 100,),
                              ),
                              Text('E Ticketing Platform - bridge to Solve issues' , style: TextStyle(fontSize:13.8,color: ArgonColors.text),) ,
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                     Text('Login',
                                      style: TextStyle(
                                          color: ArgonColors.darkgreen,
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0,
                                          fontFamily: 'OpenSans'
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20,),
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
                                            suffixIcon: Icon(Icons.person,
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
                                            labelText: 'Mobile',
                                            hoverColor: ArgonColors.darkgreen
                                        ),
                                        keyboardType: TextInputType.number,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            mobile = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty || !value.contains('@')) {
                                            return 'Invalid email!';
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
                                        obscureText: passwordVisible,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                              color: ArgonColors.darkgreen,),
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                !passwordVisible;
                                              });
                                            },

                                          ),
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
                                          labelText: 'password',
                                          labelStyle: TextStyle(
                                            color: ArgonColors.darkgreen,

                                          ),
                                        ),
                                        keyboardType: TextInputType.visiblePassword,

                                        validator: (value) {
                                          if (value!.isEmpty && value.length < 7) {
                                            return 'Invalid password!';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            password = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20,),
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
                                              onPressed: _submit,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4.0),
                                              ),
                                              child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                                                  child: Text("SUBMIT",
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
                                              onPressed: (){},
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 11.4),
                                      child: TextButton(

                                          onPressed: () {
                                            Navigator.push<dynamic>(
                                                  context,
                                                  MaterialPageRoute<dynamic>(
                                                    // builder: (BuildContext context) => SuperAdminHome(),
                                                    builder: (BuildContext context) => ForgotPassword(),
                                                  ),
                                                      //if you want to disable back feature set to false
                                                );
                                          },
                                          child: Text('Forgot Password' ,
                                          style: TextStyle(
                                            color: ArgonColors.text ,
                                            fontSize: 18,


                                          ),
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Column(
                                        children: [
                                          Text('Powered by ' ,
                                          style: TextStyle(color: ArgonColors.text , fontSize: 17),
                                          ),
                                          SizedBox(height: 6,),
                                          InkWell(
                                            onTap: ()=> launch('https://bhadraz.com/'),
                                            child: Text('Bhadraz – One Stop Digital Solutions' , style: TextStyle(color: ArgonColors.text , fontSize: 15),),
                                          )
                                        ],
                                      ),
                                    )
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 0),
                                    //   child: TextButton(
                                    //
                                    //       onPressed: () {  },
                                    //       child: Text('Help' ,
                                    //         style: TextStyle(
                                    //           color: ArgonColors.text ,
                                    //           fontSize: 18,
                                    //
                                    //         ),
                                    //       )),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
        ),
      );
    }



  }
}
