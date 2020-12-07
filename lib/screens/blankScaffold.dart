import 'package:expense_tracker/services/db.dart';
import 'package:flutter/material.dart';

class BlankScaffold extends StatefulWidget {
  BlankScaffold({Key key}) : super(key: key);

  @override
  _BlankScaffoldState createState() => _BlankScaffoldState();
}

class _BlankScaffoldState extends State<BlankScaffold> {
  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: db.getUserHomepage(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => snapshot.data,
                ),
                (route) => false,
              );
            });
            return FlatButton(
              onPressed: () {},
              child: null,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
