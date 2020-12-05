import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/db.dart';

class ExpenseCreatorHomePage extends StatefulWidget {
  @override
  _ExpenseCreatorHomePageState createState() => _ExpenseCreatorHomePageState();
}

class _ExpenseCreatorHomePageState extends State<ExpenseCreatorHomePage> {
  List<String> categories = new List<String>();
  List<String> tags = new List<String>();
  List<String> chosenTags = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  String category;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  int size = 1;
  bool hasImage = false;
  TextEditingController amountController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  File _image;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  height: height / 2.3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff008DFF), Color(0xff083EF6)])),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 16, left: 16, top: 80),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Good Morning,",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width / 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 25,
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Aman",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: width / 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      width: width / 1.05,
                      height: height / 2,
                      decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 36.0,
                          left: 26,
                          bottom: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Expenses",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            DropdownButton(
                              value: "Carpentry",
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
                                  value: "Carpentry",
                                  child: Text(
                                    "Carpentry",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Technician",
                                  child: Text(
                                    "Technician",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Painter",
                                  child: Text(
                                    "Painter",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Expenses Amount",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: width / 2,
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: "Enter Amount"),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Upload Receipt",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "+ upload image",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff083EF6)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                height: 45,
                                width: width / 1.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xff083EF6),
                                ),
                                child: Center(
                                  child: Text(
                                    "Create",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Rejected Expenses",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ExpenseCards(height: height, width: width),
                          SizedBox(
                            height: 20,
                          ),
                          ExpenseCards(height: height, width: width)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseCards extends StatelessWidget {
  const ExpenseCards({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 7,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            //                   <--- left side
            color: Colors.redAccent,
            width: 10.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "28/Nov/2020",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Text(
                  "Carpentry",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "₹ 2500",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Text(
            "Rejected",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xfff60808),
            ),
          ),
        ],
      ),
    );
  }
}
