import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewsOrEventItem.dart';
import 'package:milk_matters_interface/screens/NewNewsAndEventsItem.dart';
import 'package:milk_matters_interface/services/Base64Image.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:html';

/// This class uses a database listener to populate a listview with news and events items information fetched
/// from firebase. It generates item cards with the options to edit or delete the item
/// it also allows for adding new news and events items

class NewsAndEvents extends StatefulWidget {
  @override
  _NewsAndEvents createState() => _NewsAndEvents();
}

class _NewsAndEvents extends State<NewsAndEvents> {
  @override
  void initState() {
    super.initState();
  }

  List<NewsOrEventItem> listview =
      []; //list populated with the items fetched from firebase

  ///this is a confirmation dialog to confirm the deletion of an item.
  Future<void> showCancellationDialog(
      DatabaseService databaseProvider, NewsOrEventItem item) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text(
                "Are you sure you want to delete this news item from the database?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.deleteNewsOrEventItem(item.key);
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  List<NewsOrEventItem> populateArticles(DataSnapshot dataSnapshot) {
    List<NewsOrEventItem> newList = new List<NewsOrEventItem>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      newList.add(NewsOrEventItem.fromJson(value, key));
    });
    return newList;
  }

  ///builds the interface
  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(
        context); //an object of the database services class which can also be used as a listener
    DatabaseReference ref = databaseProvider.db
        .ref("NewsAndEvents"); //a reference of NewsAndEvents from firebase.

    ref.onValue.listen((event) {
      //listens to any changes to news and events database
      setState(() {
        this.listview = this.populateArticles(event.snapshot);
      });
    });

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
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: item.image == 'none'
                          ? Image.asset('assets/milk_matters_logo_login.png')
                          : imageFromBase64String(item.image),
                      title: Text(item.title ?? ""),
                      subtitle: Text(item.url ?? ""),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(item.dateAdded ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ExpansionTile(
                      title: Text("Description"),
                      children: <Widget>[
                        Text(item.description ?? ""),
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
                                    builder: (context) => NewNewsAndEventsItem(
                                        item: item, edit: true)));
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
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //adding a new news and events item
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewNewsAndEventsItem(edit: false)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
    );
  }
}
