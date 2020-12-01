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
  });
}

class Expense {
  Category category;
  String description;
  String imageName;
  List usersAssigned;
  String status;
  Expense({
    this.category,
    this.description,
    this.imageName,
    this.status,
  });
}

class Category {
  String name;
  List expenses;
  double monthlyLimit;
}
