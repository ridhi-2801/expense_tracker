import 'package:expense_tracker/services/db.dart';
import 'package:flutter/material.dart';

class Confirmation extends StatelessWidget {
  final String text;
  Confirmation({this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 50),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xff083EF6),
            ),
          ),
          child: OutlineButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            color: Color(0xff083EF6),
            onPressed: () async{
              DatabaseService db = DatabaseService();
              var screen = await db.getUserHomepage();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => screen,
                ),
                (route) => false,
              );
            },
            child: Text(
              "Go to home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff32ECEC),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                text == null ? 'Task successfully':
                "New $text successfuly",
                style: TextStyle(
                    color: Color(0xff083EF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                text == null ? ' completed':
                " Created!",
                style: TextStyle(
                  color: Color(0xff083EF6),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
