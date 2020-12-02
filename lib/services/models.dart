class Employee {
  String id;
  String name;
  String role;
  String email;
  List expensesAssigned;
  String category;
  Employee({
    this.id,
    this.name,
    this.role,
    this.email,
  });
}

class Expense {
  String category;
  List tags;
  String description;
  String imageName;
  List usersAssigned;
  String status;
  double amount;
  Expense({
    this.category,
    this.tags,
    this.description,
    this.imageName,
    this.status,
    this.amount,
  });
}

class Category {
  String name;
  List users;
  List expenses;
  double monthlyLimit;
  Category({
    this.name,
    this.users,
    this.expenses,
    this.monthlyLimit,
  });
}

class Tag {
  String tagName;
  List expenses;
  Tag({this.tagName, this.expenses});
}
