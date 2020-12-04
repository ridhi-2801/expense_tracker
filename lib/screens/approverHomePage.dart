import 'package:expense_tracker/screens/approveExpenses.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApproverDashboard extends StatefulWidget {
  ApproverDashboard({Key key}) : super(key: key);

  @override
  _ApproverDashboardState createState() => _ApproverDashboardState();
}

class _ApproverDashboardState extends State<ApproverDashboard> {
  Employee employee;
  DatabaseService dbservice = DatabaseService();

  Future<void> fetchUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString('Id') ?? 'Not present';
    employee = await dbservice.getUserData(uid);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approver Dashboard'),
      ),
      body: FutureBuilder(
        future: employee == null ? fetchUserData() : null,
        builder: (context, snapshot) {
          if (employee == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApproveExpenses(
                            expenseIds:
                                List<String>.from(employee.expensesAssigned),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Approve expenses',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.grey[800],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
