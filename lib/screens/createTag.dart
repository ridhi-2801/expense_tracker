import 'package:expense_tracker/services/db.dart';
import '../services/models.dart';
import 'package:flutter/material.dart';

import 'confirmation.dart';

class CreateTag extends StatefulWidget {
  CreateTag({Key key}) : super(key: key);

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTag> {
  DatabaseService databaseService = new DatabaseService();
  TextEditingController tag = new TextEditingController();
  // List<String> tags = new List<String>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  double height, width;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder(
        future: isLoaded ? null : databaseService.getAllTags(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (isLoaded == false) {
              isLoaded = true;
            }
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Text(
                            "Create Tag",
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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 56.0, left: 16, right: 16),
                    child: Text(
                      "Tag Name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: width / 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: tag,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: new UnderlineInputBorder(
                          borderSide: new BorderSide(
                            color: Color(0xff083EF6),
                          ),
                        ),
                        hintText: "Enter Tag Name",
                      ),
                      validator: (value) {
                        return value.isEmpty
                            ? 'Tag name cannot be empty'
                            : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FlatButton(
                      minWidth: width / 1.5,
                      height: 60,
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          );
                          Tag newTag = new Tag(tagName: tag.text);
                          await databaseService.addTagData(newTag);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Confirmation(
                                text: 'Tag',
                              ),
                            ),
                          );
                        }
                      },
                      color: Color(0xff083EF6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Add Tag",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: width / 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
