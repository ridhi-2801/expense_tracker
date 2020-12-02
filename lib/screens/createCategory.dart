import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';

class CreateCategory extends StatefulWidget {
  CreateCategory({Key key}) : super(key: key);

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  List<String> users = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  List<String> chosenUsers = new List<String>();
  int size = 1;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchUsers() async {
    users = await databaseService.getUnassinedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (users.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Category name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: amountController,
                      decoration: InputDecoration(labelText: 'Monthly limit'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Amount cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    for (var i = 0; i < size; i++) categoryWidget(),
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
                          Category category = new Category(
                            name: nameController.text,
                            monthlyLimit: double.parse(amountController.text),
                            users: chosenUsers,
                          );
                          await databaseService.addCategoryData(category);
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
                        'Add category',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.purple[400],
                    ),
                  ],
                ),
              ),
            );
          } else if (users.isEmpty &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text('No user has any unassinged category'),
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

  Column categoryWidget() {
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
              return 'Select atlease 1 category';
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
