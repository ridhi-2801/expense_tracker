import 'package:flutter/material.dart';

class Employee {
  String id;
  String name;
  String role;
  String email;
  List expensesAssigned;
  Employee({
    this.id,
    this.name,
    this.role,
    this.email,
    this.expensesAssigned,
  });
  Employee.fromMap(Map data) {
    id = data['Employee Id'];
    email = data['Employee email'];
    role = data['Employee role'];
    name = data['Employee name'];
    expensesAssigned = data['Expenses'];
  }
}

class Expense {
  String category;
  bool hasImage;
  String id;
  List tags;
  String description;
  String imageName;
  double amount;
  String creatorId;
  DateTime createdAt;
  List comments;
  Expense(
      {this.id,
      this.category,
      this.tags,
      this.description,
      this.imageName,
      this.amount,
      this.hasImage,
      this.creatorId,
      this.createdAt,
      this.comments});
  Expense.fromMap(Map data) {
    id = data['id'];
    amount = data['Amount'].runtimeType == int
        ? data['Amount'].toDouble()
        : data['Amount'];
    description = data['Description'];
    category = data['Category'];
    tags = data['Tags'];
    hasImage = data['hasImage'];
    print(data['Created at'].runtimeType);
    createdAt = DateTime.parse(data['Created at'].toDate().toString());
    creatorId = data['Creator Id'];
    comments = data['Comments'];
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['Tags'] = tags;
    map['Description'] = description;
    map['Amount'] = amount;
    return map;
  }
}

class Category {
  int totalExpenses;
  String name;
  List users;
  List expenses;
  double monthlyLimit;
  int totalLimits;
  List<List<String>> limitUsers;
  List<int> limits;
  List<String> limitNames;
  Category({
    this.name,
    this.users,
    this.expenses,
    this.monthlyLimit,
    this.totalExpenses,
    this.totalLimits,
    this.limits,
    this.limitUsers,
    this.limitNames,
  });
  Category.fromMap(Map<String, dynamic> data) {
    totalExpenses = data['Total Expenses'];
    expenses = data['Expenses'];
    monthlyLimit = data['Monthly limit'];
    totalLimits = data['Total limits'];
    name = data['Name'];
    users = data['Users'];
    limitNames = List<String>.from(data['Limits']);
    limitUsers = new List<List<String>>();
    for (var i = 0; i < limitNames.length; i++) {
      limitUsers.add(new List<String>());
      limitUsers[i].addAll(List<String>.from(data[limitNames[i]]));
    }
  }
}

class Tag {
  String tagName;
  Tag({this.tagName});
}

class Comment {
  static const TAG = 'Comment';

  String userName;
  String content;

  Comment({@required this.userName, @required this.content});
}
