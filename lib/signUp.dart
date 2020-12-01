import 'package:expense_tracker/signIn.dart';
import 'package:flutter/material.dart';
import 'services/db.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewPortConstraints) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff008DFF), Color(0xff083EF6)])),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
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
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width / 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    height: height / 1.475,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 26.0, right: 16, top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Employeee Name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: width / 25,
                                fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff083EF6))),
                                hintText: "Enter Employee Name"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Employeee id",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: width / 25,
                                fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff083EF6))),
                                hintText: "Enter Employee id"),
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
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                ),
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff083EF6))),
                                hintText: "Enter Password"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                         /* Text(
                            "Confirm Password",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: width / 25,
                                fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.grey,
                                ),
                                border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xff083EF6))),
                                hintText: "Enter Password"),
                          ),*/
                          Text(
                            "User Category",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: width / 25,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton(
                            value: "Admin",
                            hint: Text("User Catergory"),
                            style: TextStyle(
                              color: Color.fromRGBO(38, 50, 56, 0.30),
                              fontSize: 15.0,
                              fontFamily: "Gilroy",
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.black45,
                            ),
                            onChanged: (value) {
                              setState(() {
                                //itemCategory = value == "Veg" ? true : false;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: "Admin",
                                child: Text(
                                  "Admin",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "checker",
                                child: Text(
                                  "checker",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "User",
                                child: Text(
                                  "User",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
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
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:16.0,left: 16,right: 16,bottom: 8),
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
                                      "Sign Up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width / 25),
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
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sign_In()));
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: "Already have Account?",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: width / 27),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: " Sign In",
                                          style: TextStyle(
                                              color: Color(0xff083EF6),
                                              fontSize: width / 27,
                                              fontWeight: FontWeight.bold))
                                    ]),
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
    }));
  }
}
