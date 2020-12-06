import 'dart:io';
import 'package:expense_tracker/screens/confirmation.dart';
import 'package:expense_tracker/services/db.dart';
import 'package:expense_tracker/services/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateExpense extends StatefulWidget {
  final String description;
  final double amount;
  CreateExpense({Key key, this.amount, this.description}) : super(key: key);

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  List<String> categories = new List<String>();
  List<String> tags = new List<String>();
  List<String> chosenTags = new List<String>();
  DatabaseService databaseService = new DatabaseService();
  String category;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  int size = 1;
  bool hasImage = false;
  TextEditingController amountController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  File _image;
  final picker = ImagePicker();
  double height, width;

  @override
  void initState() {
    amountController.text = widget.amount?.toString() ?? '';
    descController.text = widget.description ?? '';
    super.initState();
  }

  Future<void> fetchData() async {
    categories = await databaseService.getAllCategories();
    tags = await databaseService.getAllTags();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder(
        future: categories.isEmpty && tags.isEmpty ? fetchData() : null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (categories.isNotEmpty && tags.isNotEmpty) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Form(
                key: formKey,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Text(
                              "Create Expense",
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (var x in chosenTags)
                                Container(
                                  padding: EdgeInsets.only(right: 18),
                                  child: InputChip(
                                    label: Text(x),
                                    onDeleted: () {
                                      setState(() {
                                        chosenTags.remove(x);
                                      });
                                    },
                                  ),
                                ),
                            ],
                          ),
                          for (var i = 0; i < size; i++) tagWidget(),
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
                                'Add new tag +',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          DropdownButtonFormField(
                            hint: Text('Select category'),
                            items: categories.map((String cat) {
                              return new DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value;
                              });
                            },
                            validator: (value) {
                              if (category == null) {
                                return 'Select a category';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: descController,
                            // initialValue: widget.description ?? '',
                            decoration:
                                InputDecoration(labelText: 'Description'),
                          ),
                          TextFormField(
                            controller: amountController,
                            decoration: InputDecoration(labelText: 'Amount'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Amount cannot be empty';
                              }
                              return null;
                            },
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('Any attachments?'),
                            value: hasImage,
                            onChanged: (value) {
                              setState(() {
                                hasImage = value;
                              });
                            },
                          ),
                          _image != null ? Image.file(_image) : Container(),
                          FlatButton(
                            height: 45,
                            minWidth: width / 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color(0xff083EF6),
                            onPressed: hasImage && _image == null
                                ? () async {
                                    await getImage();
                                  }
                                : () async {
                                    if (formKey.currentState.validate()) {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                      );
                                      Expense expense = new Expense(
                                        category: category,
                                        amount:
                                            double.parse(amountController.text),
                                        description: descController.text ?? '',
                                        tags: chosenTags,
                                        hasImage: hasImage,
                                      );
                                      String id = await databaseService
                                          .addExpense(expense);
                                      if (_image != null) {
                                        await FirebaseStorage.instance
                                            .ref(id)
                                            .putFile(_image);
                                      }
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Confirmation(
                                            text: 'Expense',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: Text(
                              hasImage && _image == null
                                  ? 'Click image'
                                  : 'Proceed',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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

  Column tagWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
        ),

        Text('Tags'),
        DropdownButtonFormField(
          validator: (value) {
            if (chosenTags.isEmpty) {
              return 'Select atlease 1 tag';
            }
            return null;
          },
          hint: Text('Select Tag'),
          items: tags.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          // value: 'Select',
          onChanged: (value) {
            setState(() {
              if (!chosenTags.contains(value)) {
                chosenTags.add(value);
                // categories.remove(value);
              }
            });
          },
        ),
        // FlatButton(onPressed: null, child: null)
      ],
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
}
