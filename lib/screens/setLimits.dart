import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:expense_tracker/screens/confirmation.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';

import '../responsiveScreen.dart';

class SetLimits extends StatefulWidget {
  final Category category;
  SetLimits({Key key, this.category}) : super(key: key);

  @override
  _SetLimitsState createState() => _SetLimitsState(category: category);
}

class _SetLimitsState extends State<SetLimits> {
  Category category;
  _SetLimitsState({this.category});
  double width, height;
  int totalLimits = 0;
  List<int> limits = new List<int>();
  List<List<String>> users = new List();
  List<DragAndDropList> _contents;
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void generateList() {
    _contents = List.generate(
      totalLimits + 1,
      (index) {
        if (index == 0) {
          return DragAndDropList(
            header: Column(
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        'Limit ${index + 1}: 0 - ${limits[index]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            children: <DragAndDropItem>[
              for (var user in category.users)
                DragAndDropItem(
                  child: Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Text(
                          user,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return DragAndDropList(
            header: Column(
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        'Limit ${index + 1}: ${limits[index - 1]} - ${index == totalLimits ? category.monthlyLimit.toInt() : limits[index]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            children: [],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
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
                        "Set limits",
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
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      hint: Text('Select total number of Limits'),
                      // value: totalLimits,
                      items: List<int>.generate(10, (index) => index + 1)
                          .map((int x) {
                        return new DropdownMenuItem(
                          value: x,
                          child: Text(x.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          totalLimits = value;
                          limits = List.generate(totalLimits, (index) => 0);
                          for (var i = 0; i <= totalLimits; i++) {
                            users.add(new List<String>());
                          }
                          users[0].addAll(List<String>.from(category.users));
                        });
                      },
                      validator: (value) {
                        if (totalLimits == 0) {
                          return 'Select at least 1 limit';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    for (var i = 0; i < totalLimits; i++)
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Limit ${i + 1}: ${limits[i]}',
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.red[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.red.withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.red[700],
                              inactiveTickMarkColor: Colors.red[100],
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.redAccent,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              divisions: (category.monthlyLimit * 0.01).toInt(),
                              value: limits[i].toDouble(),
                              min: 0,
                              label: '${limits[i]}',
                              max: category.monthlyLimit,
                              onChangeEnd: (value) {
                                setState(() {
                                  if (!limits.contains(0)) {
                                    generateList();
                                  }
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  limits[i] = value.toInt();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    _contents != null
                        ? Column(
                            children: [
                              Container(
                                height: height / 2,
                                child: DragAndDropLists(
                                  children: _contents,
                                  onItemReorder: _onItemReorder,
                                  onListReorder: null,
                                  listPadding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  itemDivider: Divider(
                                    thickness: 2,
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  itemDecorationWhileDragging: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  listInnerDecoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  lastItemTargetHeight: 8,
                                  addLastItemTargetHeightToTop: true,
                                  lastListTargetSize: 40,
                                  dragHandle: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.black26,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Color(0xff083EF6),
                                  height:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? 60
                                          : 50,
                                  onPressed: () async {
                                    if (formkey.currentState.validate()) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      );
                                      print(limits.length);
                                      List<String> list = [];
                                      for (var index = 0;
                                          index <= limits.length;
                                          index++) {
                                        String temp;
                                        if (index == 0) {
                                          temp = '0 - ${limits[index]}';
                                        } else {
                                          temp =
                                              '${limits[index - 1]} - ${index == totalLimits ? category.monthlyLimit.toInt() : limits[index]}';
                                        }
                                        list.add(temp);
                                      }
                                      Category cat = new Category(
                                        name: category.name,
                                        monthlyLimit: category.monthlyLimit,
                                        users: category.users,
                                        limitUsers: users,
                                        totalLimits: totalLimits,
                                        limits: limits,
                                        limitNames: list,
                                      );
                                      DatabaseService db =
                                          new DatabaseService();
                                      await db.addCategoryData(cat);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Confirmation(
                                            text: 'Category',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Create",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              ResponsiveWidget.isSmallScreen(
                                                      context)
                                                  ? width / 20
                                                  : width / 60,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: ResponsiveWidget.isSmallScreen(
                                                context)
                                            ? width / 15
                                            : width / 45,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
      var temp = users[oldListIndex].removeAt(oldItemIndex);
      users[newListIndex].insert(newItemIndex, temp);
    });
  }
}
