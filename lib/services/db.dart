import 'package:cloud_firestore/cloud_firestore.dart';
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
      return ExpenseCreatorHomePage(
        isApprover: false,
      );
    } else if (role == 'Approver') {
      // return ApproverHomepage(edit: false,);
      return ExpenseCreatorHomePage(
        isApprover: true,
      );
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

    Map<String, dynamic> map = {
      'Name': category.name,
      'Users': category.users,
      'Monthly limit': category.monthlyLimit,
      'Total Expenses': 0,
      'Total limits': category.totalLimits,
      'Limits': category.limitNames,
    };
    for (var i = 0; i < category.limitNames.length; i++) {
      map[category.limitNames[i]] = category.limitUsers[i];
    }
    return await docref.set(
      map,
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

  Future<String> editExpense(Expense expense, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('Id');
    String username = await getUserName();
    Map map = {username: comment};
    expensesRef.doc(expense.id).update({
      'Category': expense.category,
      'Amount': expense.amount,
      'Tags': expense.tags,
      'Description': expense.description,
      'hasImage': expense.hasImage,
      'Creator Id': id,
      'Created at': DateTime.now(),
      'Comments': FieldValue.arrayUnion([map]),
    });
    Category temp = await readCategory(expense.category);

    await userRef.doc(temp.limitUsers.first.first).update({
      'Expenses': FieldValue.arrayUnion([expense.id]),
    });
    return expense.id;
  }

  Future<String> addExpense(Expense expense, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('Id');
    String username = await getUserName();
    Map map = {username: comment};
    DocumentReference ref = await expensesRef.add({
      'Category': expense.category,
      'Amount': expense.amount,
      'Tags': expense.tags,
      'Description': expense.description,
      'hasImage': expense.hasImage,
      'Creator Id': id,
      'Created at': DateTime.now(),
      'Comments': FieldValue.arrayUnion([map]),
    });
    Category temp = await readCategory(expense.category);
    await userRef.doc(temp.limitUsers.first.first).update({
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

  Future<void> addComment(String comment, String id) async {
    String username = await getUserName();
    Map map = {username: comment};
    await expensesRef.doc(id).update({
      'Comments': FieldValue.arrayUnion(
        [map],
      ),
    });
  }

  findLimit(double amt, List<String> limits) {
    for (var limit in limits) {
      if (double.parse(limit.split(' ').first) < amt &&
          double.parse(limit.split(' ').last) > amt) {
        return limit;
      }
    }
  }

  Future<void> approveExpense(Expense expense, String comment) async {
    String userId = await getUserId();
    await userRef.doc(userId).update({
      //Remove from current user
      'Expenses': FieldValue.arrayRemove([expense.id])
    });
    Category temp = await readCategory(expense.category);
    String limit = findLimit(expense.amount, temp.limitNames);
    int x = temp.limitNames.indexOf(limit);

    if (temp.limitUsers[x].contains(userId)) {
      //Currently in the right limit
      if (userId == temp.limitUsers[x].last) {
        int total = temp.totalExpenses + 1;
        // String cat = expense.category.
        total += 1000;
        String id = '${expense.category.substring(0, 3)}' + total.toString();
        Map map = {id: expense.id};
        try {
          await FirebaseFirestore.instance
              .collection('Approved')
              .doc(expense.category)
              .update(
            {
              'Expenses': FieldValue.arrayUnion(
                [map],
              ),
            },
          );
        } catch (e) {
          await FirebaseFirestore.instance
              .collection('Approved')
              .doc(expense.category)
              .set(
            {
              'Expenses': FieldValue.arrayUnion(
                [map],
              ),
            },
          );
        }
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(expense.category)
            .update({
          'Total Expenses': FieldValue.increment(1),
        });
      } else {
        int index = temp.limitUsers[x].indexOf(userId);
        await userRef.doc(temp.limitUsers[x][index + 1]).update({
          'Expenses': FieldValue.arrayUnion([expense.id])
        });
      }
    } else {
      //In limit below the actual limit
      for (var i = x - 1; i >= 0; i--) {
        if (temp.limitUsers[i].contains(userId)) {
          if (temp.limitUsers[i].last == userId) {
            String next = temp.limitUsers[i + 1].first;
            await userRef.doc(next).update({
              'Expenses': FieldValue.arrayUnion([expense.id])
            });
          } else {
            int index = temp.limitUsers[i].indexOf(userId);
            await userRef.doc(temp.limitUsers[i][index + 1]).update({
              'Expenses': FieldValue.arrayUnion([expense.id])
            });
          }
          break;
        }
      }
    }
    await addComment(comment, expense.id);
  }

  Future<void> rejectExpense(Expense expense, String comment) async {
    String userId = await getUserId();
    await userRef.doc(userId).update({
      //Remove from current user
      'Expenses': FieldValue.arrayRemove([expense.id])
    });
    Category temp = await readCategory(expense.category);
    String limit = findLimit(expense.amount, temp.limitNames);
    int x = temp.limitNames.indexOf(limit);

    if (x == 0 && userId == temp.limitUsers[x].first) { //For sending back to creator
      await userRef.doc(expense.creatorId).update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    } else if (temp.limitUsers[x].first == userId) {  //For sending to the previous limit's last user
      await userRef.doc(temp.limitUsers[x - 1].last).update({
        'Expenses': FieldValue.arrayUnion([expense.id])
      });
    } else {    //For sending to previous user
      for (var i = x - 1; i >= 0; i--) {
        if (temp.limitUsers[i].contains(userId)) {
          int index = temp.limitUsers[i].indexOf(userId);
          await userRef.doc(temp.limitUsers[i][index-1]).update({
            'Expenses': FieldValue.arrayUnion([expense.id])
          });
          break;
        }
      }
    }
    await addComment(comment, expense.id);
  }

  Future<String> getUrl(String id) async {
    return await FirebaseStorage.instance.ref(id).getDownloadURL();
  }
}
