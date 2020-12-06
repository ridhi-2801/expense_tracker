import 'package:expense_tracker/screens/confirmation.dart';
import 'package:expense_tracker/screens/expenseCreatorHomePage.dart';
import 'package:expense_tracker/screens/approverHomePage.dart';
import 'package:expense_tracker/screens/assignUsers.dart';
import 'package:expense_tracker/screens/createCategory.dart';
import 'package:expense_tracker/screens/createExpense.dart';
import 'package:expense_tracker/screens/createTag.dart';
import 'package:expense_tracker/shared/drawer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/signIn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      home: SignIn(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // FirebaseAuth.instance.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: commonDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCategory()),
              ),
              child: Text('Create Category'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssignUsers()),
              ),
              child: Text('Assign users to category'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTag()),
              ),
              child: Text('Create tag'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateExpense()),
              ),
              child: Text('Create expense'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApproverDashboard()),
              ),
              child: Text('Approver homepage'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExpenseCreatorHomePage()),
              ),
              child: Text('Homepage'),
              color: Colors.red[300],
            ),
            FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Confirmation(
                    text: 'Default',
                  ),
                ),
              ),
              child: Text('Confirmation'),
              color: Colors.red[300],
            ),
          ],
        ),
      ),
    );
  }
}
