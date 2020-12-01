import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/models.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userRef =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference categoryRef =
      FirebaseFirestore.instance.collection('categories');
  final CollectionReference tagsRef =
      FirebaseFirestore.instance.collection('tags');

  Future<void> updateUserData(Employee employee) async {
    DocumentReference docRef = userRef.doc(employee.id);
    return await docRef.set(
      {
        'Employee Id': employee.id,
        'Employee name': employee.name,
        'Employee role': employee.role,
        'Employee email': employee.email,
      },
      SetOptions(merge: true),
    );
  }

  Future<List<String>> getAllIds() async {
    final QuerySnapshot result = await userRef.get();
    final List<DocumentSnapshot> docs = result.docs;
    List<String> ids = new List();
    for (var i = 0; i < docs.length; i++) {
      ids.add(docs[i].id);
    }
    return ids;
  }

  Future<List<String>> getAllCategories() async {
    final QuerySnapshot result = await categoryRef.get();
    final List<DocumentSnapshot> docs = result.docs;
    List<String> ids = new List();
    for (var i = 0; i < docs.length; i++) {
      ids.add(docs[i].id);
    }
    return ids;
  }

  Future<List<String>> getAllTags() async {
    final QuerySnapshot result = await tagsRef.get();
    final List<DocumentSnapshot> docs = result.docs;
    List<String> ids = new List();
    for (var i = 0; i < docs.length; i++) {
      ids.add(docs[i].id);
    }
    return ids;
  }
}
