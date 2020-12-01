import 'package:expense_tracker/services/db.dart';
import 'package:flutter/material.dart';

class CreateExpense extends StatefulWidget {
  CreateExpense({Key key}) : super(key: key);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  List<String> categories = new List<String>();
  List<String> tags = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  String category, tag;

  @override
  void initState() {
    getCategories();
    getTags();
    super.initState();
  }

  void getCategories() async {
    categories = await databaseService.getAllCategories();
  }

  void getTags() async {
    tags = await databaseService.getAllTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create expense'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            DropdownButtonFormField(
              hint: Text('Select tag'),
              items: tags.map((String tag) {
                return new DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  tag = value;
                });
              },
            ),
            DropdownButtonFormField(
              hint: Text('Select category'),
              items: categories.map((String category) {
                return new DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
            ),
            TextFormField(
              // controller: password,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              // controller: password,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),

            // FlatButton(
            //   onPressed: () async {
            //     await authService.signUp(
            //       email.text,
            //       password.text,
            //       context,
            //     );
            //     Employee employee = new Employee(
            //       id: id.text,
            //       name: name.text,
            //       email: email.text,
            //       role: role,
            //     );
            //     databaseService.updateUserData(employee);
            //     if (authService.user != null) {
            //       print('Registered');
            //       Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => HomeScreen(),
            //         ),
            //         (route) => false,
            //       );
            //     }
            //   },
            //   child: Text('Register'),
            //   color: Colors.red[300],
            // ),
          ],
        ),
      ),
    );
  }
}
