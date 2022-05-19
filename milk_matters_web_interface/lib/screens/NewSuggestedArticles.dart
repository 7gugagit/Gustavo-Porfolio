import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/models/SuggestedArticle.dart';
import 'package:milk_matters_interface/screens/SuggestedArticles.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This page allows one to add a suggested article as a new educational article in the database.
class NewSuggestedArticle extends StatefulWidget {

  /// The suggested article to be added.
  final SuggestedArticle item;
  /// True if editing an existing item, false if creating a new one
  final bool edit;

  /// Constructor
  NewSuggestedArticle({Key key, this.item, @required this.edit}) : super(key: key);

  /// Creates the state containing the functionality for the page.
  @override
  _NewSuggestedArticle createState() => _NewSuggestedArticle(item: item, edit: edit);

}

class _NewSuggestedArticle extends State<NewSuggestedArticle> {

  ///Constructor
  _NewSuggestedArticle({this.item, @required this.edit});

  final SuggestedArticle item;
  final bool edit;
  bool firstedit = true;
  final myArticleController = TextEditingController();
  final myCategoryController = TextEditingController();
  final myURLController = TextEditingController();
  final myDescriptionController = TextEditingController();
  final myImageController = TextEditingController();
  bool validTitle = false;
  bool validUrl = false;
  bool validDescription = false;
  Text validationText = Text("");
  String dropdownValue = 'Breast Conditions & Common Concerns';
  String myImage;
  String imageButtonText = "No Image Selected...";

  /// Disposes the state's controllers when it is closed.
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myArticleController.dispose();
    myCategoryController.dispose();
    myURLController.dispose();
    myDescriptionController.dispose();
    myImageController.dispose();
    super.dispose();
  }

  /// Selects an image from the users computer and sets it as the articles image
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
    final databaseProvider = Provider.of<DatabaseService>(context);
    if (!edit) {
      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/suggestedArticles');
              }
          ),
          title: Text("Milk Matters"),
          centerTitle: true,
          backgroundColor: Colors.pink[100],
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: myArticleController,
              decoration: InputDecoration(
                labelText: "Enter SuggestedBy",
              ),
            ),
            TextFormField(
              controller: myCategoryController,
              decoration: InputDecoration(
                labelText: "Enter Donor Number",
              ),
            ),
            TextFormField(
              controller: myURLController,
              decoration: InputDecoration(
                labelText: "Enter Article URL",
              ),
            ),
            TextFormField(
              controller: myDescriptionController,
              decoration: InputDecoration(
                labelText: "Enter Comments",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Choose an Image for the article"),
            ),
            //Image (image: AssetImage('/Nutrition.jpg'),
            //width: 300.0,
            //height: 300.0,

            FloatingActionButton(
              onPressed: () async {
                var now = new DateTime.now();
                String date = now.day.toString() + "/" + now.month.toString() +
                    "/" + now.year.toString();
                SuggestedArticle edu = SuggestedArticle(
                  suggestedBy: myArticleController.text,
                  dateSuggested: date,
                  donorNumber: myCategoryController.text ,
                  url: myURLController.text,
                  comments: myDescriptionController.text,
                );
                databaseProvider.pushSuggestedArticle(edu);
                Navigator.pop(context);
                //SuggestedArticle sugEdu = SuggestedArticle(suggestedBy: myArticleController.text, donorNumber: myCategoryController.text,
                //    dateSuggested: (new DateFormat().add_yMd().format(new DateTime.now()).toString()), url: myURLController.text, comments: myDescriptionController.text);

              },
              child: Text("Add Suggested Article"),
            )
          ],
        ),
      );
    }
    else{
      myArticleController.text = "";
      myDescriptionController.text = item.comments;
      // dropdownValue = item.category ?? 'Breast Conditions & Common Concerns';
      myURLController.text = item.url;
      //myImageController
      String category = item.category;
     /* if (firstedit){
        dropdownValue = category;
      }*/

      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/suggestedArticles');
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
              ),/*TextFormField(
                controller: myCategoryController,
                decoration: InputDecoration(
                  labelText: "Enter Article Category",
                ),
              ),*/
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
                  databaseProvider.pushArticle(dropdownValue, edu);
                  databaseProvider.declineSuggestedArticle(item.key);
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