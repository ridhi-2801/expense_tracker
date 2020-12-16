import 'package:flutter/material.dart';

class ChangePriorities extends StatefulWidget {
  ChangePriorities({Key key}) : super(key: key);

  @override
  _ChangePrioritiesState createState() => _ChangePrioritiesState();
}

class _ChangePrioritiesState extends State<ChangePriorities> {
  double width, height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height / 5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff008DFF), Color(0xff083EF6)])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: width / 4.7,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Change Priorities",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
