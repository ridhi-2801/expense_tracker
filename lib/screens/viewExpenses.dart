import 'package:async/async.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ViewExpenses extends StatefulWidget {
  final List<String> expIds;
  ViewExpenses({Key key, this.expIds}) : super(key: key);

  @override
  _ViewExpensesState createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('View Expenses'),
  //     ),
  //   );
  // }
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  List<Expense> expenses = new List<Expense>();
  DatabaseService db = new DatabaseService();
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int index = 8;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
  }

  fetchExpense() {
    return this._memoizer.runOnce(() async {
      for (var i = 0; i < 8; i++) {
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
    expenses.add(
      await db.getExpense(
        widget.expIds[index],
      ),
    );
    index++;
    // if failed,use loadFailed(),if no data
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchExpense(),
          builder: (context, snapshot) {
            if (expenses.length >= 8) {
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropMaterialHeader(),
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
                  itemBuilder: (c, i) => Card(
                    child: Center(
                      child: Text(
                        expenses[i].amount.toString(),
                      ),
                    ),
                  ),
                  itemExtent: 100.0,
                  itemCount: items.length,
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class ExpenseCards extends StatelessWidget {
  const ExpenseCards({
    Key key,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height / 7,
        width: width,
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
                    'expense?.createdAt',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  Text(
                    'expense.category',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'expense.amount.toString()',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Text(
              "Rejected",
              style: TextStyle(
                fontWeight: FontWeight.bold,
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
