import 'package:expense_tracker/screens/signIn.dart';
import 'package:expense_tracker/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Drawer commonDrawer(BuildContext context) {
  return Drawer(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
            child: Text('Logout'),
            color: Colors.red[300],
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
            child: Text('Register'),
            color: Colors.red[300],
          ),
        ],
      ),
    ),
  );
}
