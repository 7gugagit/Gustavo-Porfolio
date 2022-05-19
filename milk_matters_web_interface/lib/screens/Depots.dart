import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/Depot.dart';
import 'package:milk_matters_interface/models/DonationDropoff.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/screens/NewArticle.dart';
import 'package:milk_matters_interface/screens/NewDepot.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This class has all the depot functionality, it pulls all the depots from the
/// database and creates a list view that generates on demand as the user scrolls.
/// depots can be added, editted, deleted and the donations can be cleared for specific
/// depots from this page.

class Depots extends StatefulWidget {
  @override
  _Depots createState() => _Depots();
}

class _Depots extends State<Depots> {
  @override
  void initState() {
    super.initState();
  }

  List<Depot> listview =
      []; //these two lists are populated from the database, this is depots
  List<DonationDropoff> amountList = []; //this is donation amounts
  double amountCount =
      0; //used to count up the donation quantities for each depot.
  List<String> dropKeys = [];

  ///A confirmation of deletion pop-up. Used to avoid mistakes of deleting depots.
  Future<void> showCancellationDialog(
      DatabaseService databaseProvider, Depot item) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text(
                "Are you sure you want to delete this depot from the database?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.deleteDepot(item.key);
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete")),
            ],
          );
        });
  }

  ///A confirmation pop up for processing donations, to avoid errors from miss clicks
  Future<void> showProcessDonationDialog(
      DatabaseService databaseProvider, List<String> dropKeys) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text(
                "Are you sure you want to process the collection for this depot?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.deleteDonationDropoff(dropKeys);
                    Navigator.of(context).pop();
                  },
                  child: Text("Process Donations")),
            ],
          );
        });
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

  @override
  Widget build(BuildContext context) {
    //database controllers to use database services.
    final databaseProvider = Provider.of<DatabaseService>(context);
    DatabaseReference ref =
        databaseProvider.db.ref("Depots"); //snapshot of depots
    DatabaseReference refAmounts = databaseProvider.db
        .ref("DonationDropoffs"); //snapshot of donation drop offs

    ref.onValue.listen((event) {
      //listen to a change in depots database
      setState(() {
        this.listview = this.populateDepots(event.snapshot);
      });
    });
    listview.sort((a, b) =>
        a.compareTo(b)); //sorts articles in descending list in date added
    refAmounts.onValue.listen((event) {
      //list to change in amounts.
      setState(() {
        this.amountList = this.populateDepotsDropoffs(event.snapshot);
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
            amountCount = 0;
            //this for loop compares the item id to the amounts depot id to check whether the donation belongs to the depot.
            for (int i = 0; i < amountList.length; i++) {
              if (amountList[i].depotId == item.key) {
                double temp = double.parse(amountList[i].amount);
                amountCount += temp;
              }
            }

            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset('assets/milk_matters_logo_login.png'),
                    title: Text(listview[index].name ?? "default name"),
                    subtitle:
                        Text(listview[index].address ?? "default address"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        "Contact Number: " + listview[index].contactNumber ??
                            "default number"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Description: " + listview[index].comments ??
                        "default description"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(400, 0, 0, 0),
                    child: Text(
                        "Approximately " +
                            amountCount.toString() +
                            " ml of milk available",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () async {
                            for (int i = 0; i < amountList.length; i++) {
                              if (amountList[i].depotId == item.key) {
                                dropKeys.add(amountList[i].key);
                              }
                            }
                            await showProcessDonationDialog(
                                databaseProvider, dropKeys);
                          },
                          child: Text("Process Collection"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewDepot(item: item, edit: true)));
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewDepot(edit: false)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[200],
      ),
    );
  }
}
