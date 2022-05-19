import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:html';


/// This class adds a new article to the database, the user adds input for the
/// title, description, URL, and category. The date is automatically generated.
/// The user has the option to add images.


class NewArticle extends StatefulWidget {
  final EducationArticle item; //item being pushed to database
  final bool edit; //True if editing an existing item, false if creating a new one taken as a parameter of NewArticle

  NewArticle({Key key, this.item, @required this.edit}) : super(key: key);
  @override
  _NewArticlePage createState() => _NewArticlePage(item: item, edit: edit);
}

class _NewArticlePage extends State<NewArticle> {

  _NewArticlePage({this.item, @required this.edit});

  final EducationArticle item;
  final bool edit;
  bool firstedit = true; //used to set states with whether article is being edited or added.
  final myArticleController = TextEditingController(); //text controllers
  final myCategoryController = TextEditingController();
  final myURLController = TextEditingController();
  final myDescriptionController = TextEditingController();
  String myImage;
  String imageButtonText = "No Image Selected...";
  String dropdownValue = 'Breast Conditions & Common Concerns'; //default value for category
  Text validationText = Text("");

  bool validTitle = false;//text validation
  bool validUrl = false;
  bool validDescription = false;

  /// Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    myArticleController.dispose();
    myCategoryController.dispose();
    myURLController.dispose();
    myDescriptionController.dispose();
    super.dispose();
  }

  ///Selects an image from the users computer and sets it as the articles image
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

  /// Builds the page
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context); //database service instance

    if (!edit) { //this is adding a new article instead of editing, so if the parameter false is giving, it goes into this block.
      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/articles');
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
                  labelText: "Enter Article title",
                ),
                autovalidate: true,
                validator: (value) { //text validation for the title.
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
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) { //changes state on a new category selection
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Breast Conditions & Common Concerns',
                  'Breast Milk Donation', 'Breast Milk Supply', 'Breastfeeding',
                  'Expressing, Pumping & Sterilising', 'Latching', 'Nutrition When Breastfeeding',
                'The Working Mother'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                  labelText: "Enter Article Description",
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
              onPressed: () async { //when the submit button is pressed it checks if the input is correct then pushes the article to the DB  using the database service.
                if (validDescription && validTitle && validUrl) {
                  var now = new DateTime.now();
                  String date = now.day.toString() + "/" + now.month.toString() +
                      "/" + now.year.toString();
                  EducationArticle edu = EducationArticle(dateAdded: (date),
                      description: myDescriptionController.text,
                      image: myImage == null ? "none" : myImage.toString(),
                      title: myArticleController.text,
                      url: myURLController.text,
                      category: dropdownValue);
                  edu.toString();
                  databaseProvider.pushArticle(dropdownValue, edu);
                  Navigator.pop(context);
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
    else
      { //works the same as adding a new article but instead its for editing an existing article
      myArticleController.text = item.title;
      myDescriptionController.text = item.description;
     // dropdownValue = item.category ?? 'Breast Conditions & Common Concerns';
      myURLController.text = item.url;
      //myImageController
      String category = item.category;
      myImage = item.image;
      if (myImage != "none") {
        imageButtonText = "Image Selected!";
      }
      if (firstedit){
        dropdownValue = category;
      }

      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/articles');
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
                  labelText: "Enter Article title",
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
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    firstedit = false;
                    item.url = myURLController.text;
                    item.title = myArticleController.text;
                    item.description = myDescriptionController.text;
                    item.image = myImage;
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Breast Conditions & Common Concerns',
                  'Breast Milk Donation', 'Breast Milk Supply', 'Breastfeeding',
                  'Expressing, Pumping & Sterilising', 'Latching', 'Nutrition When Breastfeeding',
                  'The Working Mother'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                    labelText: "Enter Article Description",
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
                if (validDescription && validTitle && validUrl) {
                  var now = new DateTime.now();
                  EducationArticle edu = EducationArticle(
                      dateAdded: now.day.toString() + "/" +
                          now.month.toString() + "/" + now.year.toString(),
                      description: myDescriptionController.text,
                      image: myImage == null ? "none" : myImage.toString(),
                      title: myArticleController.text,
                      url: myURLController.text,
                      category: dropdownValue);
                  edu.toString();
                  databaseProvider.setArticle(edu, item.key, category);
                  Navigator.pop(context);
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