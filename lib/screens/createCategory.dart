import 'package:expense_tracker/responsiveScreen.dart';
import 'package:expense_tracker/screens/setLimits.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:flutter/material.dart';

class CreateCategory extends StatefulWidget {
  CreateCategory({Key key}) : super(key: key);

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  List<String> users = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  List<String> chosenUsers = new List<String>();
  int size = 1;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  double width, height;
  List<String> categories = new List<String>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchUsers() async {
    users = await databaseService.getAllIds();
    categories = await databaseService.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewPortConstraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff008DFF), Color(0xff083EF6)])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: width / 4.7,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Text(
                        "Create Category",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future:
                    users.isEmpty || categories.isEmpty ? fetchUsers() : null,
                builder: (context, snapshot) {
                  if (users.isNotEmpty && categories.isNotEmpty) {
                    return Container(
                      width: ResponsiveWidget.isSmallScreen(context)
                          ? width
                          : width / 3,
                      height: height / 1.3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: formKey,
                          child: ListView(
                            children: [
                              Text(
                                "Category Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? width / 20
                                          : width / 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Color(0xff083EF6),
                                    ),
                                  ),
                                  hintText: "Enter Category Name",
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name cannot be empty';
                                  } else if (categories.contains(value)) {
                                    return 'Category already exists';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Monthly Limit",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? width / 20
                                          : width / 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: new UnderlineInputBorder(
                                    borderSide: new BorderSide(
                                      color: Color(0xff083EF6),
                                    ),
                                  ),
                                  hintText: "Enter Monthly Limit",
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Amount cannot be empty';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              for (var i = 0; i < size; i++) categoryWidget(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    setState(() {
                                      size++;
                                    });
                                  },
                                  child: Text(
                                    'Add new user +',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Color(0xff083EF6),
                                  height:
                                      ResponsiveWidget.isSmallScreen(context)
                                          ? 60
                                          : 50,
                                  onPressed: () async {
                                    if (formKey.currentState.validate()) {
                                      Category category = new Category(
                                        name: nameController.text,
                                        monthlyLimit:
                                            double.parse(amountController.text),
                                        users: chosenUsers,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SetLimits(
                                            category: category,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Set Limits",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              ResponsiveWidget.isSmallScreen(
                                                      context)
                                                  ? width / 20
                                                  : width / 60,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: ResponsiveWidget.isSmallScreen(
                                                context)
                                            ? width / 15
                                            : width / 45,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Column categoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          "User",
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveWidget.isSmallScreen(context)
                ? width / 20
                : width / 70,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField(
          validator: (value) {
            if (chosenUsers.isEmpty) {
              return 'Select atlease 1 user';
            }
            return null;
          },
          hint: Text('Select User'),
          items: users.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          // value: 'Select',
          onChanged: (value) {
            setState(() {
              if (!chosenUsers.contains(value)) {
                chosenUsers.add(value);
                // categories.remove(value);
              }
            });
          },
        ),
        // FlatButton(onPressed: null, child: null)
      ],
    );
  }
}
