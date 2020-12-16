import 'package:expense_tracker/responsiveScreen.dart';
import 'package:expense_tracker/screens/assignUsers.dart';
import 'package:expense_tracker/screens/createCategory.dart';
import 'package:expense_tracker/screens/createTag.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/shared/drawer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_icons/flutter_icons.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final DatabaseService dbService = new DatabaseService();

  bool isLoaded = false;
  int currTime = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: commonDrawer(context),
      body: FutureBuilder<String>(
          future: isLoaded ? null : dbService.getUserName(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (isLoaded == false) {
                isLoaded = true;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      // alignment: Alignment.center,
                      children: [
                        Container(
                          height: height / 2.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff008DFF), Color(0xff083EF6)],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, top: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.rotate(
                                  angle: math.pi / 2,
                                  child: IconButton(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.bar_chart_outlined),
                                    onPressed: () {
                                      _scaffoldKey.currentState.openDrawer();
                                    },
                                    iconSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Good ${currTime > 5 && currTime < 15 ? 'Morning' : 'Evening'},",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            ResponsiveWidget.isSmallScreen(
                                                    context)
                                                ? width / 14
                                                : width / 50,
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
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ResponsiveWidget.isSmallScreen(context)
                                            ? width / 14
                                            : width / 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                //    SizedBox(height: height/5,)
                              ],
                            ),
                          ),
                        ),
                        ResponsiveWidget.isSmallScreen(context)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 158.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: ResponsiveWidget.isSmallScreen(
                                                context)
                                            ? height / 6
                                            : height / 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        PositionedCards(
                                          text1: "Create",
                                          text2: "Category",
                                          iconData: Icons.create,
                                          nextScreen: CreateCategory(),
                                        ),
                                        PositionedCards(
                                          text1: "Create",
                                          text2: "Tag",
                                          iconData: FlutterIcons.tag_mco,
                                          nextScreen: CreateTag(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ResponsiveWidget.isSmallScreen(
                                              context)
                                          ? (width - 300) / 10
                                          : width / 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        PositionedCards(
                                          text1: "Assign",
                                          text2: "Users",
                                          iconData: FlutterIcons.people_mdi,
                                          nextScreen: AssignUsers(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 250.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    PositionedCards(
                                      text1: "Create",
                                      text2: "Category",
                                      iconData: Icons.create,
                                      nextScreen: CreateCategory(),
                                    ),
                                    PositionedCards(
                                      text1: "Create",
                                      text2: "Tag",
                                      iconData: FlutterIcons.tag_mco,
                                      nextScreen: CreateTag(),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class PositionedCards extends StatelessWidget {
  PositionedCards({
    this.text1,
    this.text2,
    this.iconData,
    this.nextScreen,
  });

  final String text1;
  final String text2;
  final dynamic nextScreen;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen,
          ),
        );
      },
      child: Container(
        height: 120,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Color(0xff083EF6),
              size: 40,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              text1,
              style: TextStyle(
                color: Color(0xff083EF6),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              text2,
              style: TextStyle(
                color: Color(0xff083EF6),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class CategoryCards extends StatelessWidget {
//   CategoryCards(
//       {this.height,
//       this.width,
//       this.color,
//       this.date,
//       this.category,
//       this.name,
//       this.price});

//   final String date;
//   final String category;
//   final String name;
//   final String price;
//   final double height;
//   final double width;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height / 7,
//       width: width,
//       decoration: BoxDecoration(
//         border: Border(
//           left: BorderSide(
//             //                   <--- left side
//             color: color,
//             width: 10.0,
//           ),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 date,
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//               ),
//               Text(
//                 category,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//               ),
//               Text(
//                 name,
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
//               ),
//             ],
//           ),
//           Text(
//             price,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
//           ),
//         ],
//       ),
//     );
//   }
// }
