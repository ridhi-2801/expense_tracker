import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:expense_tracker/screens/confirmation.dart';
import 'package:expense_tracker/screens/createExpense.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:expense_tracker/shared/attachmentDisplay.dart';
import 'package:flutter/material.dart';
import '../services/models.dart';

class ExpenseDetails extends StatefulWidget {
  ExpenseDetails({
    Key key,
    @required this.expense,
  }) : super(key: key);
  final Expense expense;

  @override
  _ExpenseDetailsState createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  double height, width;
  DatabaseService db = DatabaseService();
  bool edit = false;
  TextEditingController comment = new TextEditingController();
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: db.getUserId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (widget.expense.creatorId == snapshot.data) {
              edit = true;
            }
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
                          widget.expense.createdAt.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.expense.category,
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
                            for (String tag in widget.expense.tags)
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
                          "Description: ${widget.expense.description}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        widget.expense.hasImage
                            ? OutlineButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowAttachment(
                                        id: widget.expense.id,
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
                                          width: width / 16,
                                          height: height / 20,
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
                        widget.expense.amount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: formkey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Add comment',
                      hintText: 'Comment',
                      alignLabelWithHint: true,
                    ),
                    controller: comment,
                    validator: (value) {
                      return value.isEmpty ? 'Comment cannot be empty' : null;
                    },
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlineButton(
                          onPressed: edit
                              ? () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateExpense(
                                        description: widget.expense.description,
                                        amount: widget.expense.amount,
                                        tags: List<String>.from(
                                            widget.expense.tags),
                                        category: widget.expense.category,
                                        id: widget.expense.id,
                                        hasImage: widget.expense.hasImage,
                                      ),
                                    ),
                                  );
                                }
                              : () async {
                                  if (formkey.currentState.validate()) {
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
                                    await db.rejectExpense(
                                        widget.expense, comment.text);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Confirmation(),
                                      ),
                                    );
                                  }
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 10),
                            child: Text(
                              edit ? 'Edit' : 'Reject',
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
                            if (formkey.currentState.validate()) {
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
                              await db.approveExpense(
                                  widget.expense, comment.text);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Confirmation(),
                                ),
                              );
                            }
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
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Comments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    Container(
                      child: CommentTreeWidget(
                        Comment(
                            userName: widget.expense.comments[0].keys.first,
                            content: widget.expense.comments[0].values.first),
                        [
                          for (var i = 1;
                              i < widget.expense.comments.length;
                              i++)
                            Comment(
                              // avatar: 'null',
                              userName: widget.expense.comments[i].keys.first,
                              content: widget.expense.comments[i].values.first,
                            ),
                        ],
                        treeThemeData: TreeThemeData(
                            lineColor: Color(0xff083EF6), lineWidth: 3),
                        avatarRoot: (context, Comment data) => PreferredSize(
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xff083EF6),
                            child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white,
                                child: Text(
                                  data.userName.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                foregroundColor: Colors.black),
                          ),
                          preferredSize: Size.fromRadius(18),
                        ),
                        avatarChild: (context, Comment data) => PreferredSize(
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xff083EF6),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Text(
                                data.userName.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              foregroundColor: Colors.black,
                            ),
                          ),
                          preferredSize: Size.fromRadius(12),
                        ),
                        contentChild: (context, data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color(0xff083EF6),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${data.content}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        contentRoot: (context, Comment data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color(0xff083EF6),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${data.content}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff083EF6),
                                            fontSize: 14,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),

                    // TreeView(
                    //   parentList: [
                    //     Parent(
                    //       parent: Text(widget.expense.comments[0]),
                    //       childList: null,
                    //     ),
                    //   ],
                    // ),

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
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    // } else if ((index >= widget.ids.length || snapshot.data == null) &&
    //     snapshot.connectionState == ConnectionState.done &&
    //     isLoaded[index]) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         Image(
    //           image: AssetImage(
    //             "images/no data.jpg",
    //           ),
    //         ),
    //         Text(
    //           "No Data",
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             color: Colors.grey,
    //             fontSize: 20,
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
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
    // ],
    // ),
  }
}
