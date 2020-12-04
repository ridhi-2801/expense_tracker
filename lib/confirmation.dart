import 'package:expense_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Confirmation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 50),
        child: FlatButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false,
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xff083EF6),
                )),
            child: Center(
              child: Text(
                "Confirm",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
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
                "New Expenses successfuly",
                style: TextStyle(
                    color: Color(0xff083EF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                " Created!",
                style: TextStyle(
                    color: Color(0xff083EF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          )),
        ],
      ),
    );
  }
}
