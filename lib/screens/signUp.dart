import 'package:expense_tracker/services/auth.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';
import '../responsiveScreen.dart';
import 'signIn.dart';
import '../services/db.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<String> allIds = new List<String>();
  TextEditingController name = new TextEditingController();
  TextEditingController id = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  String role = 'Approver';

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool obsecure = true;
  Future<void> fetchIds() async {
    allIds = await DatabaseService().getAllIds();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff008DFF), Color(0xff083EF6)])),
          child: Padding(
            padding:ResponsiveWidget.isSmallScreen(context)? const EdgeInsets.only(top: 100.0):const EdgeInsets.only(top: 30,left: 300,right: 300,bottom: 80),
            child: Column(
              mainAxisAlignment: ResponsiveWidget.isSmallScreen(context)?MainAxisAlignment.start:MainAxisAlignment.center,
              crossAxisAlignment: ResponsiveWidget.isSmallScreen(context)?CrossAxisAlignment.start:CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveWidget.isSmallScreen(context)?width / 20:width/60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height:10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveWidget.isSmallScreen(context)?width / 17:width/56,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: ResponsiveWidget.isSmallScreen(context)?const EdgeInsets.only(top: 60):const EdgeInsets.only(top: 20),
                  child: Container(
                    height: height / 1.475,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:ResponsiveWidget.isSmallScreen(context)? BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)):BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding:ResponsiveWidget.isSmallScreen(context)?
                          const EdgeInsets.only(left: 26.0, right: 16, top: 50):const EdgeInsets.only(left: 26,right: 16,top: 40),
                      child: FutureBuilder(
                          future: allIds.isEmpty ? fetchIds() : null,
                          builder: (context, snapshot) {
                            return SingleChildScrollView(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Employeee Name",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: name,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Name cannot be empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        ),
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Color(0xff083EF6),
                                          ),
                                        ),
                                        hintText: "Enter Employee Name",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Employeee id",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: id,
                                      validator: (value) {
                                        if (allIds.contains(value)) {
                                          return 'Id already exists';
                                        } else
                                          return null;
                                      },
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
                                      "Employeee email",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: email,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Email cannot be empty';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          Icons.check,
                                          color: Colors.grey,
                                        ),
                                        border: new UnderlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Color(0xff083EF6),
                                          ),
                                        ),
                                        hintText: "Enter Employee email",
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: pass,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Password cannot be empty';
                                        }
                                        return null;
                                      },
                                      obscureText: obsecure,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obsecure =
                                                      obsecure ? false : true;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.grey,
                                              )),
                                          border: new UnderlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xff083EF6))),
                                          hintText: "Enter Password"),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "User Category",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButton(
                                      hint: Text("User Catergory"),
                                      value: role,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontFamily: "Gilroy",
                                      ),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.black45,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          role = value;
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem(
                                          value: "Expense creator",
                                          child: Text(
                                            "Expense creator",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Checker",
                                          child: Text(
                                            "Checker",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "Approver",
                                          child: Text(
                                            "Approver",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0,

                                          right: 16,
                                          bottom: 8),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (formKey.currentState.validate()) {
                                            DatabaseService databaseService =
                                                new DatabaseService();
                                            Employee employee = new Employee(
                                              id: id.text,
                                              name: name.text,
                                              role: role,
                                              email: email.text,
                                            );
                                            AuthService auth =
                                                new AuthService();
                                            await auth.signUp(
                                                email.text, pass.text, context);
                                            await databaseService
                                                .updateUserData(employee);
                                            var home = await databaseService
                                                .getUserHomepage();

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => home,
                                              ),
                                            );
                                          }
                                        },
                                        child: Align(
                                          alignment: ResponsiveWidget.isSmallScreen(context)?Alignment.center:Alignment.centerLeft,
                                          child: Container(
                                            height: 60,
                                            width: width/3,
                                            decoration: BoxDecoration(
                                                color: Color(0xff083EF6),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0, right: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
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
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignIn(),
                                          ),
                                        );
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Already have Account?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/85,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: " Sign In",
                                              style: TextStyle(
                                                color: Color(0xff083EF6),
                                                fontSize: ResponsiveWidget.isSmallScreen(context)?width / 25:width/83,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
