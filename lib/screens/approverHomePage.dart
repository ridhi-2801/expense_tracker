import 'package:expense_tracker/responsiveScreen.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:expense_tracker/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/db.dart';
import '../shared/expenseDetails.dart';

class ApproverHomepage extends StatefulWidget {
  ApproverHomepage({@required this.expense});
  final Expense expense;
  @override
  _ApproverHomepageState createState() => _ApproverHomepageState();
}

class _ApproverHomepageState extends State<ApproverHomepage> {
  final GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  DatabaseService databaseService = new DatabaseService();
  int currTime = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: commonDrawer(context),
      key: key,
      body: FutureBuilder(
        future: databaseService.getUserName(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff008DFF),
                      Color(0xff083EF6),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 99.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Transform.rotate(
                            angle: math.pi / 2,
                            child: IconButton(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.bar_chart_outlined),
                              onPressed: () {
                                key.currentState.openDrawer();
                              },
                              iconSize: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 25),
                          child: Text(
                            "Good ${currTime > 5 && currTime < 15 ? 'Morning' : 'Evening'},",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveWidget.isSmallScreen(context)
                                  ? width / 16
                                  : width / 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            snapshot.data,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveWidget.isSmallScreen(context)
                                  ? width / 16
                                  : width / 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Expenses",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  ExpenseDetails(
                                    expense: widget.expense,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
