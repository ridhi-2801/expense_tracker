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
  String category;
  String subCategory;
  double monthlyLimit;
  String imageName;
  List usersAssigned;
  String status;
}
