import 'package:expense_tracker/homePage.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  AuthService auth = AuthService();
  @override
  void initState() {
    super.initState();
    auth.user.listen((user) {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff008DFF), Color(0xff083EF6)])),
        child: Padding(
          padding: const EdgeInsets.only(top: 108.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: width / 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: width / 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  height: height / 1.53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 26.0, right: 16, top: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.check,
                                color: Colors.grey,
                              ),
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0xff083EF6))),
                              hintText: "Enter Email"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              ),
                              border: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Color(0xff083EF6))),
                              hintText: "Enter Password"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: Color(0xff083EF6),
                              fontWeight: FontWeight.bold,
                              fontSize: width / 25),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () async {
                              await auth.signIn(
                                email.text,
                                password.text,
                                context,
                              );
                              if (auth.user != null) {
                                print('Signed in');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Color(0xff083EF6),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: width / 25,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have Account?",
                              style: TextStyle(
                                  color: Colors.black, fontSize: width / 27),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " Sign Up",
                                  style: TextStyle(
                                    color: Color(0xff083EF6),
                                    fontSize: width / 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
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
    );
  }
}
