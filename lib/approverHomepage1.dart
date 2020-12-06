import 'package:flutter/material.dart';

class ApproverHomepage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff008DFF), Color(0xff083EF6)])
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 99.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0,right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Good Morning,", style: TextStyle(color: Colors
                                  .white, fontSize: width / 16, fontWeight: FontWeight
                                  .bold),),
                              CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(radius: 23,backgroundColor: Colors.lightBlueAccent,))
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text("Prakhar", style: TextStyle(color: Colors
                              .white, fontSize: width / 18, fontWeight: FontWeight
                              .bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Container(
                            height: height / 1.458,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Text("Expenses",style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize: 25),),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage("images/no data.jpg")),
                                      Text("No Data",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey,fontSize: 20),)
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}
