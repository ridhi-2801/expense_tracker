import 'package:expense_tracker/screens/signIn.dart';
import 'package:expense_tracker/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Drawer commonDrawer(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Color(0xff083EF6),),
        child: Container(
            width: width,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Welcome Back,",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),))),),
        SizedBox(height: height/4,),
        FlatButton(
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
          },
          child: Text('Logout',style: TextStyle(color: Colors.white)),
          color: Color(0xff083EF6),
        ),
        FlatButton(
          onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
          },
          child: Text('Register',style: TextStyle(color: Colors.white),),
          color: Color(0xff083EF6),
        ),
      ],
    ),
  );
}
