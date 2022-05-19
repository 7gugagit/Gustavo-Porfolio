import 'package:intl/intl.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/screens/NewArticle.dart';
import 'package:milk_matters_interface/services/Base64Image.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This class uses a database listener to populate a listview with article information fetched
/// from firebase. It generates article cards with the options to edit or delete the article
/// it also allows for adding new articles

class Articles extends StatefulWidget {
  @override
  _Articles createState() => _Articles();
}

class _Articles extends State<Articles> {
  @override
  void initState() {
    super.initState();
  }

  /// This method is a confirmation pop up to ensure articles are not deleted by accident.
  Future<void> showCancellationDialog(
      DatabaseService databaseProvider, EducationArticle item) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text(
                "Are you sure you want to delete this article from the database?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.deleteArticle(item.category, item.key);
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  List<EducationArticle> populateArticles(DataSnapshot dataSnapshot) {
    List<EducationArticle> newList = new List<EducationArticle>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      Map<dynamic, dynamic> mapOfCategories = value;
      mapOfCategories.forEach((keyOne, valueOne) {
        newList.add(EducationArticle.fromJson(valueOne, keyOne, key));
      });
    });
    return newList;
  }

  List<EducationArticle> listview =
      []; //list that is populated with articles from the database
  final List<int> colorCodes = <int>[600, 500, 100];

  /// Builds the interface
  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(
        context); //controller to use database services

    DatabaseReference ref =
        databaseProvider.db.ref("Articles"); //a reference of articles database

    ref.onValue.listen((event) {
      //Whenever there is a change to the articles section of db this triggers to update article list

      setState(() {
        this.listview = this.populateArticles(event.snapshot);
      });
    });
    listview.sort((a, b) =>
        a.compareTo(b)); //sorts articles in descending list in date added

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }),
        title: Text("Milk Matters"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: listview.length,
          itemBuilder: (BuildContext context, int index) {
            final item = listview[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: item.image == 'none'
                          ? Image.asset('assets/milk_matters_logo_login.png')
                          : imageFromBase64String(item.image),
                      title: Text(listview[index].title ?? "default title"),
                      subtitle: Text(listview[index].url ?? "default url"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Date Added: " + listview[index].dateAdded ??
                          "default date"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Category: " + listview[index].category ??
                          "default category"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ExpansionTile(
                        title: Text("Description"),
                        children: <Widget>[
                          Text(listview[index].description ??
                              "default description"),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewArticle(item: item, edit: true)));
                            },
                            child: Text("Edit"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: RaisedButton(
                            onPressed: () {
                              showCancellationDialog(databaseProvider, item);
                            },
                            child: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewArticle(edit: false)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
    );
  }
}
