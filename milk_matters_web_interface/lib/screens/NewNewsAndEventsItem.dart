import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewsOrEventItem.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';


/// This class adds a new news and events item to the database, the user adds input for the
/// title, description, URL, and description. The date is automatically generated.
/// The user has the option to add images.


class NewNewsAndEventsItem extends StatefulWidget {
  final NewsOrEventItem item;
  final bool edit; //True if editing an existing item, false if creating a new one
  NewNewsAndEventsItem({Key key, this.item, @required this.edit}) : super(key: key);
  @override
  _NewNewsAndEventsItem createState() => _NewNewsAndEventsItem(item: item, edit: edit);
}

class _NewNewsAndEventsItem extends State<NewNewsAndEventsItem> {

  _NewNewsAndEventsItem({this.item, @required this.edit});

  final NewsOrEventItem item;
  final bool edit;
  final myArticleController = TextEditingController(); //text controllers
  final myCategoryController = TextEditingController();
  final myURLController = TextEditingController();
  final myDescriptionController = TextEditingController();
  final myImageController = TextEditingController();
  String myImage;
  String imageButtonText = "No Image Selected...";
  Text validationText = Text("");

  bool validTitle = false; //input validation
  bool validUrl = false;
  bool validDescription = false;

  /// Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    myArticleController.dispose();
    myCategoryController.dispose();
    myURLController.dispose();
    myDescriptionController.dispose();
    myImageController.dispose();
    super.dispose();
  }

  ///Selects an image from the users computer and sets it as the news and event image
  void imagePicker() async {
    InputElement uploadInput = FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files.length > 0) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((event) {
          setState(() {
            Uint8List result = reader.result;
            myImage = base64Encode(result);
            imageButtonText = "Image Selected!";
          });
        });

        reader.onError.listen((event) {
          setState(() {
            imageButtonText = "Image Not Found";
            debugPrint("Some Error occured while reading the file");
          });
        });
        reader.readAsArrayBuffer(file);
      }
    });
  }

  ///builds the interface
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context); //object for database services
    if (!edit) { //adding a new news and event
      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/newsAndEvents');
              }
          ),
          title: Text("Milk Matters"),
          centerTitle: true,
          backgroundColor: Colors.pink[100],
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myArticleController,
                decoration: InputDecoration(
                  labelText: "Enter title",
                ),
                autovalidate: true,
                validator: (value) { //input validation
                  if (value == null || value.length == 0) {
                    validTitle = false;
                    return "Please enter a title";
                  }
                  else {
                    validTitle = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myURLController,
                decoration: InputDecoration(
                  labelText: "Enter Article URL",
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validUrl = false;
                    return "Please enter a valid url";
                  }
                  else {
                    validUrl = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myDescriptionController,
                decoration: InputDecoration(
                  labelText: "Enter description",
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validDescription = false;
                    return "Please enter a description";
                  }
                  else {
                    validDescription = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(onPressed: imagePicker, child: Text("Select Image"),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(imageButtonText),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: validationText,
            ),
            FloatingActionButton(
              onPressed: () async { //checks if the input is valid and then pushes to DB using the database service object.
                if (validTitle && validDescription) {
                  var now = new DateTime.now();
                  NewsOrEventItem edu = NewsOrEventItem(
                      dateAdded: now.day.toString() + "/" +
                          now.month.toString() + "/" + now.year.toString(),
                      description: myDescriptionController.text,
                      image:  myImage == null ? "none" : myImage.toString(),
                      url: myURLController.text,
                      title: myArticleController.text);
                  edu.toString();
                  databaseProvider.pushNewsOrEventItem(edu);
                  Navigator.pushNamed(context, '/newsAndEvents');
                }
                else {
                  setState(() {
                    validationText = Text("Something's wrong, please take a look at your input and try again.",
                      style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.italic),);
                  });
                }
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      );
    }
    else { //this is to edit an item in the DB and it works the same as adding a new article
      myArticleController.text = item.title;
      myDescriptionController.text = item.description;
      myURLController.text = item.url;

      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/newsAndEvents');
              }
          ),
          title: Text("Milk Matters"),
          centerTitle: true,
          backgroundColor: Colors.pink[100],
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myArticleController,
                //initialValue: item.title,
                decoration: InputDecoration(
                  labelText: "Enter Title",
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validTitle = false;
                    return "Please enter a title";
                  }
                  else {
                    validTitle = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myURLController,
                decoration: InputDecoration(
                  labelText: "Enter Article URL",
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validUrl = false;
                    return "Please enter a valid url";
                  }
                  else {
                    validUrl = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myDescriptionController,
                //initialValue: item.description,
                decoration: InputDecoration(
                  labelText: "Enter Description",
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validDescription = false;
                    return "Please enter a description";
                  }
                  else {
                    validDescription = true;
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(onPressed: imagePicker, child: Text("Select Image"),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(imageButtonText),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: validationText,
            ),

            FloatingActionButton(
              onPressed: () async {
                if (validTitle && validDescription) {
                  var now = new DateTime.now();
                  NewsOrEventItem edu = NewsOrEventItem(
                      dateAdded: now.day.toString() + "/" +
                          now.month.toString() + "/" + now.year.toString(),
                      description: myDescriptionController.text,
                      image: myImage == null ? "none" : myImage.toString(),
                      url: myURLController.text,
                      title: myArticleController.text);
                  edu.toString();
                  databaseProvider.setNewsOrEventItem(edu, item.key);
                  Navigator.pushNamed(context, '/newsAndEvents');
                }
                else {
                  setState(() {
                    validationText = Text("Something's wrong, please take a look at your input and try again.",
                      style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.italic),);
                  });
                }

              },
              child: Icon(Icons.add),
            )
          ],
        ),
      );
    }
  }
}