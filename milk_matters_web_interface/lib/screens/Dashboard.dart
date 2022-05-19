import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/Depot.dart';
import 'package:milk_matters_interface/models/DonationDropoff.dart';
import 'package:milk_matters_interface/models/SuggestedArticle.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This class is a dashboard view with a list of depots and a list of suggested articles
/// as well as buttons to navigate to those respective screens. The depot list here is used to
/// see the approximate amount of milk available.

class Dashboard extends StatefulWidget {
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  List<Depot> listview = [];
  List<SuggestedArticle> suggestedList = [];
  List<DonationDropoff> amountList = [];
  double amountCount = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Depot> populateDepots(DataSnapshot dataSnapshot) {
    List<Depot> newList = new List<Depot>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      newList.add(Depot.fromJson(value, key));
    });
    return newList;
  }

  List<DonationDropoff> populateDepotsDropoffs(DataSnapshot dataSnapshot) {
    List<DonationDropoff> newList = new List<DonationDropoff>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      newList.add(DonationDropoff.fromJson(value, key));
    });
    return newList;
  }

  List<SuggestedArticle> populateSuggestedArticles(DataSnapshot dataSnapshot) {
    List<SuggestedArticle> newList = new List<SuggestedArticle>();
    Map<dynamic, dynamic> elementsOfSnap = dataSnapshot.val();
    elementsOfSnap.forEach((key, value) {
      newList.add(SuggestedArticle.fromJson(value, key, ""));
    });
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context);
    //These are the database controllers to use database services.
    DatabaseReference ref = databaseProvider.db.ref("Depots");
    DatabaseReference refAmounts = databaseProvider.db.ref("DonationDropoffs");
    DatabaseReference refSuggested =
        databaseProvider.db.ref("SuggestedArticles");

    ref.onValue.listen((event) {
      //listen to a change in depots database
      setState(() {
        this.listview = this.populateDepots(event.snapshot);
      });
    });

    refAmounts.onValue.listen((event) {
      //list to change in amounts.
      setState(() {
        this.amountList = this.populateDepotsDropoffs(event.snapshot);
      });
    });

    refSuggested.onValue.listen((event) {
      //listen to change in suggested articles
      DataSnapshot dataSnapshot = event.snapshot;
      setState(() {
        this.suggestedList = this.populateSuggestedArticles(event.snapshot);
      });
    });

    var size = MediaQuery.of(context).size;
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
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(100),
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              //Depots and amounts
              padding: const EdgeInsets.all(8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Depots",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/depots');
                      },
                      child: Text("Go to Depots"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.pink[100],
                      width: 1000.0,
                      height: 500.0,
                      child: Container(
                        height: 10,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listview.length,
                          itemBuilder: (context, index) {
                            final item = listview[index];
                            amountCount = 0;

                            for (int i = 0; i < amountList.length; i++) {
                              if (amountList[i].depotId == item.key) {
                                double temp =
                                    double.parse(amountList[i].amount);
                                amountCount += temp;
                              }
                            }
                            return Card(
                              child: ListTile(
                                title: Text(item.name),
                                subtitle: Text(amountCount.toString() + "ml"),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.pink[200],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Suggested Articles",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/suggestedArticles');
                      },
                      child: Text("Go to Suggested Articles"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.pink[100],
                      width: 1000.0,
                      height: 500.0,
                      child: ListView.builder(
                        itemCount: suggestedList.length,
                        itemBuilder: (context, index) {
                          final item = suggestedList[index];

                          return Card(
                            child: ListTile(
                              title: Text("Article: " + item.url),
                              subtitle: Text("Suggested By: " +
                                  item.suggestedBy +
                                  " #" +
                                  item.donorNumber),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.pink[200],
            ),
          ],
        ),
      ),
    );
  }
}
