import 'package:flutter/material.dart';

class CreateCategoryFrontend extends StatefulWidget {
  @override
  _CreateCategoryFrontendState createState() => _CreateCategoryFrontendState();
}

class _CreateCategoryFrontendState extends State<CreateCategoryFrontend> {
  List<String> chosenUsers = new List<String>();
  List<String> users = new List<String>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context,BoxConstraints viewPortConstraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height / 5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff008DFF), Color(0xff083EF6)])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80, left: 10),
                        child: Icon(
                          Icons.arrow_back, color: Colors.white, size: 30,),
                      ),
                      SizedBox(width: width / 4.7,),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text("Create Category", style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width,
                  height: height / 1.3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Text("Category Name", style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 20,
                            fontWeight: FontWeight.bold),),
                        TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color(0xff083EF6)
                                  )
                              ),
                              hintText: "Enter Category Name"

                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("Monthly Limit", style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 20,
                            fontWeight: FontWeight.bold),),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color(0xff083EF6)
                                  )
                              ),
                              hintText: "Enter Monthly Limit"

                          ),
                        ),
                        SizedBox(height: 30,),
                        Text("User", style: TextStyle(
                            color: Colors.black,
                            fontSize: width / 20,
                            fontWeight: FontWeight.bold),),
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
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("+ Add new users", style: TextStyle(
                              color: Colors.black,
                              fontSize: width / 22,
                              fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(height: 60,
                            decoration: BoxDecoration(
                                color: Color(0xff083EF6),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center,
                                children: [
                                  Text("Add Category", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: width / 20),),
                                ],
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        }
      )
      );

  }
}
