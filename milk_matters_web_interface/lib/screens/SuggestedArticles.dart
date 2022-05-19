import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/models/SuggestedArticle.dart';
import 'package:milk_matters_interface/screens/NewArticle.dart';
import 'package:milk_matters_interface/screens/NewSuggestedArticles.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This class uses a database listener to populate a listview with suggested articles information fetched
/// from firebase. It generates item cards with the options to allow or decline the item.

class SuggestedArticles extends StatefulWidget {
  @override
  _SuggestedArticles createState() => _SuggestedArticles();
}

class _SuggestedArticles extends State<SuggestedArticles> {
  @override
  void initState() {
    super.initState();
  }

  List<SuggestedArticle> listview =
      []; //database service object populates all the suggested article objects from firebase into this list

  /// This method shows a confirmation pop-up when trying to decline an article.
  Future<void> showCancellationDialog(
      DatabaseService databaseProvider, SuggestedArticle item) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text(
                "Are you sure you want to decline this suggested article?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.declineSuggestedArticle(item.key);
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  List<SuggestedArticle> populateSuggestedArticles(DataSnapshot dataSnapshot) {
    List<SuggestedArticle> newList = new List<SuggestedArticle>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      newList.add(SuggestedArticle.fromJson(value, key, ""));
    });
    return newList;
  }

  /// Builds the interface
  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<DatabaseService>(context); //object to use database services
    DatabaseReference ref = databaseProvider.db.ref(
        "SuggestedArticles"); //a reference to the SuggestedArticles database

    ref.onValue.listen((event) {
      //listens for changes in SuggestedArticles and populates list which generates list view dynamically
      setState(() {
        this.listview = this.populateSuggestedArticles(event.snapshot);
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
          //builds a view using the list of suggested articles
          padding: EdgeInsets.all(8),
          itemCount: listview.length,
          itemBuilder: (BuildContext context, int index) {
            final item = listview[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.ac_unit),
                    title: Text(listview[index].url ?? "default title"),
                    subtitle:
                        Text(listview[index].suggestedBy ?? "default url"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        "Date Suggested: " + listview[index].dateSuggested ??
                            "default date"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Description: " + listview[index].comments ??
                        "default description"),
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
                                    builder: (context) => NewSuggestedArticle(
                                        item: item, edit: true)));
                          },
                          child: Text("Accept"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60.0),
                        child: RaisedButton(
                          onPressed: () {
                            showCancellationDialog(databaseProvider, item);
                          },
                          child: Text("Decline"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
