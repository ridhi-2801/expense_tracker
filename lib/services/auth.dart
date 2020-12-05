// import 'package:AttendanceApp/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import '../services/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final DatabaseService databaseService = DatabaseService();

  Stream<User> get user => auth.authStateChanges();

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('Users')
          .where('Employee email', isEqualTo: email)
          .get();
      Map map = snap.docs.first.data();
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('Id', map['Employee Id']);
      await pref.setString('Role', map['Employee role']);
      await pref.setString('Name', map['Employee name']);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Retry'),
                color: Colors.blue,
              )
            ],
          );
        },
      );
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(e.code),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Retry'),
                color: Colors.blue,
              )
            ],
          );
        },
      );
    }
  }
}
