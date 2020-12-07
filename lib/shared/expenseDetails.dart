import 'package:expense_tracker/screens/confirmation.dart';
import 'package:expense_tracker/screens/createExpense.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:expense_tracker/shared/attachmentDisplay.dart';
import 'package:flutter/material.dart';

class ExpenseDetails extends StatefulWidget {
  ExpenseDetails(
      {Key key,
      @required this.width,
      @required this.height,
      @required this.withDecision,
      @required this.ids,
      this.edit})
      : super(key: key);
  final bool edit;
  final double width;
  final double height;
  final bool withDecision;
  final List<String> ids;

  @override
  _ExpenseDetailsState createState() =>
      _ExpenseDetailsState(length: this.ids.length);
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final int length;
  _ExpenseDetailsState({this.length});
  final DatabaseService db = DatabaseService();

  List<bool> isDecided;
  List<bool> isLoaded;
  int index;
  @override
  void initState() {
    isDecided = new List<bool>(length);
    isLoaded = new List<bool>(length);
    for (var i = 0; i < widget.ids.length ?? 0; i++) {
      // print(widget.expenseIds[i]);
      isDecided[i] = false;
      isLoaded[i] = false;
    }
    index = 0;
    super.initState();
  }

  Future<Expense> fetchExpense() async {
    try {
      String id = widget.ids[index];
      print(id);
      Expense temp = await db.getExpense(id);
      isLoaded[index] = true;
      return temp;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          !isLoaded[index] && index < widget.ids.length ? fetchExpense() : null,
      builder: (context, AsyncSnapshot<Expense> snapshot) {
        // print(snapshot.data);
        if (snapshot.data is Expense) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Image(image: AssetImage("images/carpentort.png")),
                      // Image(image: AssetImage("images/carpentorb.png")),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data.createdAt.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        snapshot.data.category,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "Tags: ",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                          ),
                          for (String tag in snapshot.data.tags)
                            Text(
                              '$tag, ',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Description: ${snapshot.data.description}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      snapshot.data.hasImage
                          ? OutlineButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShowAttachment(
                                      id: snapshot.data.id,
                                    ),
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        color: Colors.black,
                                        width: widget.width / 16,
                                        height: widget.height / 20,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Attachment",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      snapshot.data.amount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              widget.withDecision
                  ? Column(
                      children: [
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlineButton(
                              onPressed: widget.edit
                                  ? () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateExpense(
                                            description: snapshot.data.description,
                                            amount: snapshot.data.amount,
                                            tags: List<String>.from(snapshot.data.tags),
                                            category: snapshot.data.category,
                                            id: snapshot.data.id,
                                            hasImage: snapshot.data.hasImage,
                                          ),
                                        ),
                                      );
                                    }
                                  : () async {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          );
                                        },
                                      );
                                      await db.rejectExpense(snapshot.data);
                                      setState(() {
                                        isDecided[index] = true;
                                        index++;
                                      });
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Confirmation(),
                                        ),
                                      );
                                    },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 10),
                                child: Text(
                                  widget.edit ? 'Edit' : 'Reject',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.red[300],
                            ),
                            FlatButton(
                              onPressed: () async {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                );
                                await db.approveExpense(snapshot.data);
                                setState(() {
                                  isDecided[index] = true;
                                  index++;
                                });
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Confirmation(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 10),
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              color: Color(0xff083EF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                          ],
                        )
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Container(
                        //       height: widget.height / 18,
                        //       width: widget.width / 3,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           border:
                        //               Border.all(width: 2, color: Colors.red)),
                        //       child: Center(
                        //         child: Text(
                        //           "Reject",
                        //           style: TextStyle(
                        //             color: Colors.red,
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     Container(
                        //       height: widget.height / 18,
                        //       width: widget.width / 3,
                        //       decoration: BoxDecoration(
                        //         color: Color(0xff083EF6),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: Center(
                        //         child: Text(
                        //           "Approve",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 20,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    )
                  : Container(),
            ],
          );
        } else if ((index >= widget.ids.length || snapshot.data == null) &&
            snapshot.connectionState == ConnectionState.done &&
            isLoaded[index]) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    "images/no data.jpg",
                  ),
                ),
                Text(
                  "No Data",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // OutlineButton(
                //   color: Colors.red,
                //   borderSide: BorderSide(
                //     color: Colors.red,
                //     width: 1,
                //     style: BorderStyle.solid,
                //   ),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: new BorderRadius.circular(10.0),
                //   ),
                //   onPressed: () {
                //     initState();
                //   },
                //   child: Center(
                //     child: Text(
                //       "Refresh",
                //       style: TextStyle(
                //         color: Colors.red,
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
