import 'package:flutter/material.dart';

class CreateTagFrontend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height / 5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff008DFF), Color(0xff083EF6)])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 10),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: width / 4.7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Create Category",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 56.0, left: 16, right: 16),
              child: Text(
                "Tag Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width / 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Color(0xff083EF6))),
                    hintText: "Enter Tag Name"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(42.0),
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xff083EF6),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add Tag",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width / 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ]),
    );
  }
}
