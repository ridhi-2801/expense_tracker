import 'package:flutter/material.dart';

class ApproverHomepage2 extends StatelessWidget {
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
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expenses",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 25),),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Image(image: AssetImage("images/carpentort.png")),
                                  Image(image: AssetImage("images/carpentorb.png")),
                                ],
                              ),

                              Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("06/Dec/2020",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black54,fontSize: 15),),
                                  SizedBox(height: 5,),
                                  Text("Electrician",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20),),
                                  SizedBox(height: 5,),
                                  Text("Tags - Office work",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black54,fontSize: 16),),
                                  SizedBox(height: 5,),
                                  Text("Description- via gguguu",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black54,fontSize: 15),),
                                  SizedBox(height: 10,),
                                  Container(
                                    width: width/3,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 2,color: Colors.black54

                                      )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              color: Colors.black,
                                              width: width/16,
                                              height: height/20,
                                            ),
                                          ),
                                          SizedBox(width: 8,),
                                          Text("Bill.jpg",style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text("₹ 2500",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 70),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: height/18,
                                width: width/3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 2,color: Colors.red
                                    )
                                ),
                                child: Center(
                                  child: Text("Reject",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                              Container(
                                height: height/18,
                                width: width/3,
                                decoration: BoxDecoration(
                                  color: Color(0xff083EF6),
                                    borderRadius: BorderRadius.circular(10),

                                ),
                                child: Center(
                                  child: Text("Approve",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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
