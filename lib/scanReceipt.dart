import 'package:flutter/material.dart';

class ScanReceipt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff000000),
      bottomNavigationBar: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
            height: 100,
            color: Color.fromRGBO(31, 31, 31, 0.8),
            child: Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8),
              child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(color: Colors.white,child: SizedBox(height: 80,width: 50,),),
                ],
              ),
            ),
          ),
          Positioned(
              top: -30,
              left: 160,
              child: CircleAvatar(radius: 30,backgroundColor: Color(0xff083EF6),
              child: Image(image: AssetImage("images/scan.png"),),))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:78.0,right: 16,left: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(radius: 15,backgroundColor: Colors.white,child: Icon(Icons.arrow_back,color: Colors.grey,),),
                Text("Scan",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                Icon(Icons.flash_on,size: 30,color: Colors.white,)
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:48.0),
              child: Container(
                height: height/1.7,
                width: width/1.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
