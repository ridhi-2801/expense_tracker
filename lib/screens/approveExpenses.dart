import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ApproveExpenses extends StatefulWidget {
  final List<String> expenseIds;
  ApproveExpenses({Key key, this.expenseIds}) : super(key: key);

  @override
  _ApproveExpensesState createState() =>
      _ApproveExpensesState(length: expenseIds.length);
}

class _ApproveExpensesState extends State<ApproveExpenses> {
  final int length;
  _ApproveExpensesState({this.length});

  List<bool> isDecided;
  List<bool> isLoaded;
  DatabaseService databaseService = new DatabaseService();

  @override
  void initState() {
    isDecided = new List<bool>(length);
    isLoaded = new List<bool>(length);
    for (var i = 0; i < widget.expenseIds.length ?? 0; i++) {
      // print(widget.expenseIds[i]);
      isDecided[i] = false;
      isLoaded[i] = false;
    }
    index = 0;
    super.initState();
  }

  int index;

  Future<Expense> fetchExpense() async {
    try {
      String id = widget.expenseIds[index];
      print(id);
      isLoaded[index] = true;
      return await databaseService.getExpense(id);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: isLoaded.isNotEmpty &&
                        index < widget.expenseIds.length
            ? FutureBuilder(
                future: !isLoaded[index] &&
                        index < widget.expenseIds.length
                    ? fetchExpense()
                    : null,
                builder: (context, AsyncSnapshot<Expense> snapshot) {
                  if (snapshot.data is Expense) {
                    return Column(
                      children: [
                        ExpenseCard(
                          expense: snapshot.data,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                await databaseService
                                    .rejectExpense(snapshot.data);
                                setState(() {
                                  isDecided[index] = true;
                                  index++;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Reject'),
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
                                await databaseService
                                    .approveExpense(snapshot.data);
                                setState(() {
                                  isDecided[index] = true;
                                  index++;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Approve'),
                              color: Colors.green[300],
                            ),
                          ],
                        )
                      ],
                    );
                  } else if (index >= widget.expenseIds.length) {
                    return Center(
                      child: Text('No expenses'),
                    );
                  } else {
                    print(snapshot.data);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : Center(
                child: Text('No expenses'),
              ),
      ),
    );
  }
}

class ExpenseCard extends StatefulWidget {
  final Expense expense;
  const ExpenseCard({Key key, this.expense}) : super(key: key);

  @override
  _ExpenseCardState createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  String url;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getUrl() async {
    url =
        await FirebaseStorage.instance.ref(widget.expense.id).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.grey[300],
      child: Container(
        // height: 200,
        width: double.infinity,
        child: Column(
          children: [
            Text(widget.expense.category),
            Text(widget.expense.description),
            Text(widget.expense.amount.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var tag in widget.expense.tags) Text(tag),
              ],
            ),
            widget.expense.hasImage
                ? FutureBuilder(
                    future: getUrl(),
                    builder: (context, snapshot) {
                      if (url == null) {
                        return CircularProgressIndicator();
                      } else {
                        return Image.network(url);
                      }
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
