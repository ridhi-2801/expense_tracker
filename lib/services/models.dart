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
    amount = data['Amount'];
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
  Category({
    this.name,
    this.users,
    this.expenses,
    this.monthlyLimit,
    this.totalExpenses,
  });
  Category.fromMap(Map<String, dynamic> data) {
    totalExpenses = data['Total Expenses'];
    expenses = data['Expenses'];
    monthlyLimit = data['Monthly limit'];
    name = data['Name'];
    users = data['Users'];
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