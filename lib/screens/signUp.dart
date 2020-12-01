import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController id = new TextEditingController();
  TextEditingController name = new TextEditingController();
  AuthService authService = AuthService();

  List<String> allIds = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  List<String> roles = new List<String>();
  String role;

  @override
  void initState() {
    getIds();
    roles = [
      'Admin',
      'Approval users',
      'Checker',
      'Expense creator',
    ];
    super.initState();
  }

  void getIds() async {
    allIds = await databaseService.getAllIds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextFormField(
              controller: id,
              decoration: InputDecoration(labelText: 'Id'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Id cannot be empty';
                } else if (allIds.contains(value)) {
                  return 'Id already in use';
                }
                return null;
              },
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email cannot be empty';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              hint: Text('Select role'),
              items: roles.map((String role) {
                return new DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  role = value;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: password,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              onPressed: () async {
                await authService.signUp(
                  email.text,
                  password.text,
                  context,
                );
                Employee employee = new Employee(
                  id: id.text,
                  name: name.text,
                  email: email.text,
                  role: role,
                );
                databaseService.updateUserData(employee);
                if (authService.user != null) {
                  print('Registered');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text('Register'),
              color: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }
}
