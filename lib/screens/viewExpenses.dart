import 'package:async/async.dart';
import 'package:expense_tracker/screens/approverHomePage.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ViewExpenses extends StatefulWidget {
  final List<String> expIds;
  final bool isApprover;
  ViewExpenses({Key key, this.expIds, this.isApprover}) : super(key: key);

  @override
  _ViewExpensesState createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  List<Expense> expenses = new List<Expense>();
  DatabaseService db = new DatabaseService();
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int index = 8;
  bool isLoaded = false;
  int max = 8;
  @override
  void initState() {
    if (widget.expIds.length < 8) {
      max = widget.expIds.length;
    }
    super.initState();
  }

  fetchExpense() {
    return this._memoizer.runOnce(() async {
      for (var i = 0; i < max; i++) {
        Expense temp = await db.getExpense(widget.expIds[i]);
        expenses.add(temp);
      }
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    Expense temp = await db.getExpense(widget.expIds[index]);
    expenses.add(temp);
    index++;

    // if failed,use loadFailed(),if no data
    if (mounted) setState(() {});
    if (index == widget.expIds.length) {
      _refreshController.loadNoData();
    } else {
      _refreshController.loadComplete();
    }
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('View expenses'),
      ),
      body: FutureBuilder(
        future: fetchExpense(),
        builder: (context, snapshot) {
          if (expenses.length >= 8) {
            return SmartRefresher(
              enablePullUp: true,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CircularProgressIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpenseCards(
                    height: height,
                    width: width,
                    expense: expenses[i],
                    edit: !widget.isApprover,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ListTile(
                //     tileColor: Colors.black12,
                //     title: Text(
                //       expenses[i].amount.toString(),
                //     ),
                //     onTap: () {},
                //   ),
                // ),
                itemExtent: 100.0,
                itemCount: expenses.length,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ExpenseCards extends StatefulWidget {
  const ExpenseCards({
    Key key,
    @required this.height,
    @required this.width,
    @required this.expense,
    @required this.edit,
  }) : super(key: key);

  final double height;
  final double width;
  final Expense expense;
  final bool edit;

  @override
  _ExpenseCardsState createState() => _ExpenseCardsState();
}

class _ExpenseCardsState extends State<ExpenseCards> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApproverHomepage(
              expense: widget.expense,
            ),
          ),
        );
      },
      child: Container(
        height: widget.height / 7,
        width: widget.width,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              //                   <--- left side
              color: Colors.redAccent,
              width: 10.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.expense.createdAt.toString(),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                  Text(
                    widget.expense.category,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Row(
                    children: [
                      for (var tag in widget.expense.tags)
                        Text(
                          tag,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '₹${widget.expense.amount.toString()}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xfff60808),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
