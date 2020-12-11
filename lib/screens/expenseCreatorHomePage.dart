import 'package:expense_tracker/screens/createExpense.dart';
import 'package:expense_tracker/screens/viewExpenses.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:expense_tracker/shared/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../responsiveScreen.dart';
import '../services/db.dart';

class ExpenseCreatorHomePage extends StatefulWidget {
  final bool isApprover;
  ExpenseCreatorHomePage({@required this.isApprover});
  @override
  _ExpenseCreatorHomePageState createState() => _ExpenseCreatorHomePageState();
}

class _ExpenseCreatorHomePageState extends State<ExpenseCreatorHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseService databaseService = new DatabaseService();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController amountController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  int currTime = DateTime.now().hour;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: commonDrawer(context),
      body: FutureBuilder(
          future: databaseService.getUserName(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (isLoaded == false) {
                isLoaded = true;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          height: height / 2.3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Color(0xff008DFF),
                            Color(0xff083EF6)
                          ])),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, top: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.rotate(
                                  angle: math.pi / 2,
                                  child: IconButton(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.bar_chart_outlined),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    },
                                    iconSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Good ${currTime > 5 && currTime < 15 ? 'Morning' : 'Evening'},",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ResponsiveWidget.isSmallScreen(context)?width/16:width/50,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 25,
                                        foregroundColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveWidget.isSmallScreen(context)?width/16:width/60,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(12, 50, 12, 12),
                              width: width / 1.05,
                              height: height / 2.3,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 36.0,
                                  left: 26,
                                  right: 26,
                                  bottom: 16,
                                ),
                                child: Form(
                                  key: formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Create Expenses",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          width: width / 2,
                                          child: TextFormField(
                                            controller: descController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Description cannot be empty';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Description",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Expenses Amount",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          width: width / 2,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: amountController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Amount cannot be empty';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Enter Amount",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Center(
                                          child: FlatButton(
                                            height: 45,
                                            minWidth: width / 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState
                                                  .validate()) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateExpense(
                                                      description:
                                                          descController.text,
                                                      amount: double.parse(
                                                          amountController.text),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            color: Color(0xff083EF6),
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    widget.isApprover
                                        ? 'Expenses'
                                        : "Rejected Expenses",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FutureBuilder<Employee>(
                                    future: databaseService.getUserData(),
                                    initialData: Employee(expensesAssigned: []),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data.expensesAssigned
                                                  .length ==
                                              0) {
                                        return Center(
                                          child: Text('No expenses'),
                                        );
                                      } else if (snapshot.hasData) {
                                        return Container(
                                          height: height / 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  'You have ${snapshot.data.expensesAssigned.length} ${widget.isApprover ? '' : 'rejected '}expenses'),
                                              FlatButton(
                                                height: 45,
                                                minWidth: width / 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         ApproverHomepage(
                                                  //       edit: true,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewExpenses(expIds: List<String>.from(snapshot.data.expensesAssigned), isApprover: widget.isApprover,)
                                                    ),
                                                  );
                                                },
                                                color: Color(0xff083EF6),
                                                child: Text(
                                                  'View ${widget.isApprover ? '' : 'rejected '} expenses',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
