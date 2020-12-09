import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/screens/approverHomePage.dart';
import 'package:expense_tracker/screens/adminHomepage.dart';
import 'package:expense_tracker/screens/blankScaffold.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/expenseCreatorHomePage.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference categoryRef =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference expensesRef =
      FirebaseFirestore.instance.collection('Expenses');

  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('Id');
  }

  Future<String> getUserRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String ret = pref.getString('Role');
    return ret;
  }

  Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('Name');
  }

  Future<dynamic> getUserHomepage() async {
    String role = await getUserRole();
    print(role);
    if (role == 'Admin') {
      return AdminHomepage();
    } else if (role == 'Expense creator') {
      return ExpenseCreatorHomePage(isApprover: false,);
    } else if (role == 'Approver') {
      // return ApproverHomepage(edit: false,);
      return ExpenseCreatorHomePage(isApprover: true,);
    } else
      return BlankScaffold();
  }

  Future<void> updateUserData(Employee employee) async {
    DocumentReference docRef = userRef.doc(employee.id);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('Id', employee.id);
    await sharedPreferences.setString('Role', employee.role);
    await sharedPreferences.setString('Name', employee.name);
    try {
      await FirebaseFirestore.instance.collection('names').doc('uids').update(
        {
          'uids': FieldValue.arrayUnion([
            employee.id,
          ])
        },
      );
    } on FirebaseException catch (e) {
      print(e.code);

      await FirebaseFirestore.instance.collection('names').doc('uids').set(
        {
          'uids': [
            employee.id,
          ]
        },
      );
    }
    return await docRef.set(
      {
        'Employee Id': employee.id,
        'Employee name': employee.name,
        'Employee role': employee.role,
        'Employee email': employee.email,
        'Expenses': [],
      },
      SetOptions(merge: true),
    );
  }

  Future<List<String>> getAllIds() async {
    final DocumentSnapshot idRef =
        await FirebaseFirestore.instance.collection('names').doc('uids').get();
    List<String> ids = new List();
    ids = List<String>.from(idRef.data()['uids']);
    return ids;
  }

  Future<List<String>> getAllCategories() async {
    final DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('names')
        .doc('categories')
        .get();
    List<String> cats = new List();
    cats = List<String>.from(ref.data()['categories']);
    return cats;
  }

  Future<List<String>> getAllTags() async {
    try {
      final DocumentSnapshot ref = await FirebaseFirestore.instance
          .collection('names')
          .doc('tags')
          .get();
      List<String> tags = new List();
      tags = List<String>.from(ref.data()['tags']);
      return tags;
    } catch (e) {
      print(e);
      return List<String>.empty(growable: true);
    }
  }

  Future<void> addCategoryData(Category category) async {
    final DocumentReference docref = categoryRef.doc(category.name);
    try {
      await FirebaseFirestore.instance
          .collection('names')
          .doc('categories')
          .update(
        {
          'categories': FieldValue.arrayUnion([
            category.name,
          ]),
        },
      );
    } catch (e) {
      await FirebaseFirestore.instance
          .collection('names')
          .doc('categories')
          .set(
        {
          'categories': [
            category.name,
          ],
        },
      );
    }
    return await docref.set(
      {
        'Name': category.name,
        'Users': category.users,
        'Monthly limit': category.monthlyLimit,
        'Total Expenses': 0,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> addUsersToCategory(
      List<String> users, String categoryName) async {
    final DocumentReference docref = categoryRef.doc(categoryName);
    return await docref.update(
      {
        'Users': FieldValue.arrayUnion(users),
      },
    );
  }

  Future<void> addTagData(Tag tag) async {
    final CollectionReference tagsRef =
        FirebaseFirestore.instance.collection('names');
    try {
      return await tagsRef.doc('tags').update(
        {
          'tags': FieldValue.arrayUnion(
            [tag.tagName],
          ),
        },
      );
    } catch (e) {
      return await tagsRef.doc('tags').set(
        {
          'tags': [tag.tagName],
        },
      );
    }
  }

  Future<String> editExpense(Expense expense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('Id');
    expensesRef.doc(expense.id).update({
      'Category': expense.category,
      'Amount': expense.amount,
      'Tags': expense.tags,
      'Description': expense.description,
      'hasImage': expense.hasImage,
      'Creator Id': id,
      'Created at': DateTime.now(),
    });
    Category temp = await readCategory(expense.category);
    await userRef.doc(temp.users.first).update({
      'Expenses': FieldValue.arrayUnion([expense.id]),
    });
    return expense.id;
  }

  Future<String> addExpense(Expense expense) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('Id');
    DocumentReference ref = await expensesRef.add({
      'Category': expense.category,
      'Amount': expense.amount,
      'Tags': expense.tags,
      'Description': expense.description,
      'hasImage': expense.hasImage,
      'Creator Id': id,
      'Created at': DateTime.now(),
    });
    Category temp = await readCategory(expense.category);
    await userRef.doc(temp.users.first).update({
      'Expenses': FieldValue.arrayUnion([ref.id]),
    });
    return ref.id;
  }

  Future<Category> readCategory(String catName) async {
    DocumentSnapshot doc = await categoryRef.doc(catName).get();
    return Category.fromMap(doc.data());
  }

  Future<Employee> getUserData([String id]) async {
    if (id == null) {
      id = await getUserId();
    }
    DocumentSnapshot doc = await userRef.doc(id).get();
    return Employee.fromMap(doc.data());
  }

  Future<Expense> getExpense(String id) async {
    DocumentSnapshot doc = await expensesRef.doc(id).get();
    Map map = doc.data();
    map['id'] = id;
    return Expense.fromMap(map);
  }

  Future<void> approveExpense(Expense expense) async {
    DocumentSnapshot snap = await categoryRef.doc(expense.category).get();
    List users = snap.data()['Users'];
    SharedPreferences pref = await SharedPreferences.getInstance();
    int index = users.indexOf(pref.getString('Id'));
    await userRef.doc(users[index]).update({
      //Remove from current user
      'Expenses': FieldValue.arrayRemove([expense.id])
    });
    if (index != users.indexOf(users.last)) {
      //Send to next user
      await userRef.doc(users[index + 1]).update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    }
    // Send to checker
    else {
      QuerySnapshot snap =
          await userRef.where('Employee role', isEqualTo: 'Checker').get();
      await snap.docs.first.reference.update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    }
  }

  Future<void> rejectExpense(Expense expense) async {
    DocumentSnapshot snap = await categoryRef.doc(expense.category).get();
    List users = snap.data()['Users'];
    SharedPreferences pref = await SharedPreferences.getInstance();
    int index = users.indexOf(pref.getString('Id'));
    await userRef.doc(users[index]).update({
      //Remove from current user
      'Expenses': FieldValue.arrayRemove([expense.id]),
    });
    if (index != users.indexOf(users.first)) {
      //Send to previous person
      await userRef.doc(users[index - 1]).update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    } else {
      //Send back to creator
      await userRef.doc(expense.creatorId).update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    }
  }

  Future<String> getUrl(String id) async {
    return await FirebaseStorage.instance.ref(id).getDownloadURL();
  }
}
