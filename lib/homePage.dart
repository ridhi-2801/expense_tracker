import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height / 2.3,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff008DFF), Color(0xff083EF6)])),
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 80),
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
                //    SizedBox(height: height/5,),
                Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      SizedBox(
                        height: height / 5,
                      ),
                      Positioned(
                        bottom: -120,
                        child: Card(
                          child: SizedBox(
                            height: height / 3,
                            width: width,
                          ),
                        ),
                      ),
                    ],
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
/* bottom: PreferredSize(
          preferredSize: Size.fromHeight(height/3),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Good Morning,",style: TextStyle(color: Colors.white,fontSize: width/14 ,fontWeight: FontWeight.bold),),
                    CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(radius: 25,foregroundColor: Colors.blue,)),
                  ],
                ),
                Text("Aman",style: TextStyle(color: Colors.white,fontSize: width/14 ,fontWeight: FontWeight.bold),),
         //    SizedBox(height: height/5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      SizedBox(height: height/5,),
                      Positioned(
                        child: Card(
                          child: SizedBox(height: height/3,width: width,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),*/
