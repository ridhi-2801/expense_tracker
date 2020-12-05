import 'package:expense_tracker/services/db.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'confirmation.dart';

class AssignUsers extends StatefulWidget {
  AssignUsers({Key key}) : super(key: key);

  @override
  _AssignUsersState createState() => _AssignUsersState();
}

class _AssignUsersState extends State<AssignUsers> {
  List<String> users = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  List<String> chosenUsers = new List<String>();
  String category;
  int size = 1;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  double height, width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder(
        future: users.isEmpty
            ? Future.wait([
                databaseService.getAllCategories(),
                databaseService.getAllIds(),
              ])
            : null,
        builder: (context, AsyncSnapshot<List<List<String>>> snap) {
          if (snap.hasData) {
            if (users.isEmpty) {
              users = snap.data.elementAt(1);
            }
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      height: height / 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff008DFF), Color(0xff083EF6)])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Text(
                              "Assign users",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Category",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width / 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (chosenUsers.isEmpty) {
                                return 'Select category';
                              }
                              return null;
                            },
                            hint: Text('Select Category'),
                            items: snap.data.first.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            // value: 'Select',
                            onChanged: (value) {
                              setState(() {
                                category = value;
                              });
                            },
                          ),
                          // FlatButton(onPressed: null, child: null)
                        ],
                      ),
                    ),
                    for (var i = 0; i < size; i++) Padding(
                      padding: const EdgeInsets.only(left:18.0, right:18.0, ),
                      child: userWidget(),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: FlatButton(
                        padding: EdgeInsets.only(left: 18),
                        onPressed: () {
                          setState(() {
                            size++;
                          });
                        },
                        child: Text(
                          'Add new user +',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        minWidth: width / 1.5,
                        height: 60,
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );
                            await databaseService.addUsersToCategory(
                                chosenUsers, category);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Confirmation(),
                              ),
                            );
                          }
                        },
                        color: Color(0xff083EF6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Assign users",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width / 20,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  Column userWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          "User",
          style: TextStyle(
            color: Colors.black,
            fontSize: width / 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField(
          validator: (value) {
            if (chosenUsers.isEmpty) {
              return 'Select atlease 1 user';
            }
            return null;
          },
          hint: Text('Select User'),
          items: users.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          // value: 'Select',
          onChanged: (value) {
            setState(() {
              if (!chosenUsers.contains(value)) {
                chosenUsers.add(value);
                // categories.remove(value);
              }
            });
          },
        ),
        // FlatButton(onPressed: null, child: null)
      ],
    );
  }
}
