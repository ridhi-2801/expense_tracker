import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AdminHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: Container(
          height: height/4.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CategoryCards(height: height, width: width,color: Colors.redAccent,date: "28/Nov/2020",category: "Carpentry",name: "Arunava Sandhu",price: "₹ 12500",),
                SizedBox(height: 20,),
                CategoryCards(height: height, width: width,color: Colors.green,date: "28/Nov/2020",category: "Carpentry",name: "Arunava Sandhu",price: "₹ 12500",)
              ],
            ),
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      Stack(overflow: Overflow.visible, children: [
        Container(
          height: height / 2.3,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff008DFF), Color(0xff083EF6)])),
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
                  //    SizedBox(height: height/5,)
                ],
              ),
            ),
          ),
        ),
        PositionedCards(height: height, width: width,top: height/2.8,left: width/9,text1: "Create",text2: "Category",iconData: Icons.create,),
        PositionedCards(height: height, width: width,top: height/2.8,left: width/1.9,text1: "Create",text2: "Tag",iconData: FlutterIcons.tag_mco),
        PositionedCards(height: height, width: width,top: height/1.86,left: width/9,text1: "Assign",text2: "Users",iconData: FlutterIcons.people_mdi),
        Positioned(
            top: height/1.35,
            left: width/12,
            child: Text("Categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),))
      ]),

    ]));
  }
}

class PositionedCards extends StatelessWidget {
 PositionedCards({this.height,this.width,this.text1,this.text2,this.iconData,this.top,this.left});

  final double height;
  final double width;
  final String text1;
  final String text2;
  final IconData iconData;
  final double top;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: top,
        left: left,
        child:Container(
      height: 120,
      width: 150,
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(10),
         boxShadow: [new BoxShadow(
           color: Colors.blueGrey,
           blurRadius: 5.0,
         ),]
     ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData,color: Color(0xff083EF6),size: 40,),
              SizedBox(height: 8,),
              Text(text1,style: TextStyle(color: Color(0xff083EF6),fontSize: 20,fontWeight: FontWeight.w500),),
              SizedBox(height: 5,),
              Text(text2,style: TextStyle(color: Color(0xff083EF6),fontSize: 20,fontWeight: FontWeight.w500),)
            ],
          ),
    ) );
  }
}
class CategoryCards extends StatelessWidget {
   CategoryCards({this.height,this.width,this.color,this.date,this.category,this.name,this.price});

  final String date;
  final String category;
   final String name;
  final String price;
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height/7,
      width: width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide( //                   <--- left side
            color: color,
            width: 10.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(date,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
              Text(category,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              Text(name,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
            ],
          ),
          Text(price,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23 ),),
        ],
      ),
    );
  }
}
