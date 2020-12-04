import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Users'),
      ),
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
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      validator: (value) {
                        if (category == null) {
                          return 'Select atlease 1 category';
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
                    for (var i = 0; i < size; i++) userWidget(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
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
                    FlatButton(
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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        'Assign users',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.purple[400],
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
          height: 36,
        ),

        Text('User'),
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
