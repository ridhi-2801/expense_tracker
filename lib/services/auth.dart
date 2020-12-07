import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      String id = map['Employee Id'];
      String role = map['Employee role'];
      String name = map['Employee name'];
      await pref.setString('Id', id);
      await pref.setString('Role', role);
      await pref.setString('Name', name);
    } on FirebaseAuthException catch (e) {
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                    (route) => false,
                  );
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                    (route) => false,
                  );
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
