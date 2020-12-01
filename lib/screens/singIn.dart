import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/screens/signUp.dart';
import 'package:expense_tracker/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService auth = AuthService();
  // String roll;
  @override
  void initState() {
    super.initState();
    auth.user.listen((user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
  }
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        leading: Container(),
        leadingWidth: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                  await authService.signIn(
                    email.text,
                    password.text,
                    context,
                  );
                  if (authService.user != null) {
                    print('Signed in');
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: Text('Sign in'),
                color: Colors.red[300],
              ),
              SizedBox(height: 400,),
              FlatButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                ),
                child: Text('Register'),
                color: Colors.red[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}
