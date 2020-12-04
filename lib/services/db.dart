import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference categoryRef =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference expensesRef =
      FirebaseFirestore.instance.collection('Expenses');

  Future<void> updateUserData(Employee employee) async {
    DocumentReference docRef = userRef.doc(employee.id);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('Id', employee.id);
    await sharedPreferences.setString('Category', employee.category);
    await FirebaseFirestore.instance.collection('names').doc('uids').update(
      {
        'uids': FieldValue.arrayUnion([
          employee.id,
        ])
      },
    );
    await FirebaseFirestore.instance
        .collection('names')
        .doc('unassigned')
        .update(
      {
        'uids': FieldValue.arrayUnion([
          employee.id,
        ]),
      },
    );
    return await docRef.set(
      {
        'Employee Id': employee.id,
        'Employee name': employee.name,
        'Employee role': employee.role,
        'Employee email': employee.email,
        'Assigned category': [],
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
    final DocumentSnapshot ref =
        await FirebaseFirestore.instance.collection('names').doc('tags').get();
    List<String> tags = new List();
    tags = List<String>.from(ref.data()['tags']);
    return tags;
  }

  Future<List<String>> getUnassinedUsers() async {
    final DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('names')
        .doc('unassigned')
        .get();
    List<String> uids = List<String>.from(ref.data()['uids']);
    return uids;
  }

  Future<void> addCategoryData(Category category) async {
    final DocumentReference docref = categoryRef.doc(category.name);
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
    await docref.set(
      {
        'Name': category.name,
        'Users': category.users,
        'Monthly limit': category.monthlyLimit,
        'Total Expenses': 0,
      },
      SetOptions(merge: true),
    );
    await FirebaseFirestore.instance
        .collection('names')
        .doc('unassigned')
        .update({
      'uids': FieldValue.arrayRemove(category.users),
    });
    for (var user in category.users) {
      await userRef.doc(user).update(
        {
          'Assigned category': FieldValue.arrayUnion([category.name]),
        },
      );
    }
  }

  Future<void> addTagData(Tag tag) async {
    final CollectionReference tagsRef =
        FirebaseFirestore.instance.collection('names');
    return await tagsRef.doc('tags').update(
      {
        'tags': FieldValue.arrayUnion(
          [tag.tagName],
        ),
      },
    );
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

  Future<Employee> getUserData(String id) async {
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
}
