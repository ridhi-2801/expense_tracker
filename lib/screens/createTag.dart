import 'package:expense_tracker/services/db.dart';
import '../main.dart';
import '../services/models.dart';
import 'package:flutter/material.dart';

class CreateTag extends StatefulWidget {
  CreateTag({Key key}) : super(key: key);

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTag> {
  DatabaseService databaseService = new DatabaseService();
  TextEditingController tag = new TextEditingController();
  List<String> tags = new List<String>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create tag'),
      ),
      body: FutureBuilder(
        future: databaseService.getAllTags(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: tag,
                      decoration: InputDecoration(labelText: 'Tag Name'),
                      validator: (value) {
                        if (snapshot.data.contains(value)) {
                          return 'Tag already exists';
                        } else if (value.isEmpty) {
                          return 'Tag cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          Tag temp = new Tag(tagName: tag.text);
                          await databaseService.addTagData(temp);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        'Add tag',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.purple[400],
                    ),
                  ],
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
    );
  }
}
