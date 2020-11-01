import 'dart:ui';

import '../providers//auth.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_card.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth_screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin=true;

  var loggedIn = false;

//  void initiateSignIn(String type) async {
//    setState(() {
//      loggedIn=true;
//    });
//    bool check=await Provider.of<Auth>(context,listen: false).handleSignIn(type);
//    setState(() {
//      loggedIn=false;
//    });
//    if(check)
//      Navigator.of(context).pushNamed(ViewHostel.routeName);
//  }


  void changeValue(){
    setState(() {
      if(!isLogin)
      isLogin=!isLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    final dSize=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: dSize.height,
              width: dSize.width,
            ),
            Positioned(
              top: 0,
              width: dSize.width,
              height: dSize.height*0.37,
              child: Hero(
                tag: "logo",
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage("assets/up_iamge.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                ),
              ),
            ),
            Positioned(
              top: dSize.height*0.10,
              height: dSize.height*0.10,
              child: Image.asset("assets/logo.png"),
            ),
            Positioned(
              top: dSize.height*0.262,
              width: dSize.width,
              child: AuthCard(isLogin),
            ),
              Positioned(
                bottom: dSize.height*0.02,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(!isLogin? "Already have an account?": "Don't have an account?",style: TextStyle(color: Color(0xFF2554C0),fontSize: dSize.height*0.02)),
                    GestureDetector(
                      //padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                      onTap: (){
                        setState(() {
                          isLogin=!isLogin;
                        });
                      },
                      child: Text(!isLogin? "  Login": "  SignUp",style: TextStyle(color: Color(0xFF2554C0),fontWeight: FontWeight.w700,fontSize: dSize.height*0.02),),
                    ),
                  ],),
              ),
          ],
        ),
      ),
    );
  }
}


Widget _downBlock(dSize,logo){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      boxShadow: [BoxShadow(
        color: Color(0xFF8F94FB).withOpacity(0.20),
        offset: Offset(0,10),
        blurRadius: 30,
      )],
    ),
    child: CircleAvatar(
      backgroundColor: Colors.white,
      radius: dSize.width*0.14/2,
      child: Container(
          padding: EdgeInsets.all(dSize.width*0.04),
          child: Image.asset(logo,fit: BoxFit.contain,)
      ),
    ),
  );
}