import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService authService = AuthService();

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
              controller: email,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Email cannot be empty';
                }
                return null;
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
