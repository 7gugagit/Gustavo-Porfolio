import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/Depot.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// This class adds a new depot to the database, the user adds input for the
/// name, address, contact info and description of the depot.

class NewDepot extends StatefulWidget {
  final Depot item;
  final bool edit; //True if editing an existing item, false if creating a new one
  NewDepot({Key key, this.item, @required this.edit}) : super(key: key);
  @override
  _NewDepot createState() => _NewDepot(item: item, edit: edit);
}

class _NewDepot extends State<NewDepot> {

  _NewDepot({this.item, @required this.edit});

  final Depot item;
  final bool edit;
  final myNameController = TextEditingController();
  final myAddressController = TextEditingController();
  final myContactController = TextEditingController();
  final myDescriptionController = TextEditingController();
  final myLatController = TextEditingController();
  final myLongController = TextEditingController();

  /// Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    myNameController.dispose();
    myAddressController.dispose();
    myContactController.dispose();
    myDescriptionController.dispose();
    super.dispose();
  }

  ///build the interface
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context); //object to use database services class.
    if (!edit) { //add a new depot if parameter for edit is false
      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/depots');
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
                controller: myNameController,
                decoration: InputDecoration(
                  labelText: "Enter Depot Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myAddressController,
                decoration: InputDecoration(
                  labelText: "Enter Address *Note this must be exactly as google lists it*",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myContactController,
                decoration: InputDecoration(
                  labelText: "Enter Contact Number",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myDescriptionController,
                decoration: InputDecoration(
                  labelText: "Enter Comments",
                ),
              ),
            ),

            FloatingActionButton(
              onPressed: () async { //pushes a new depot to DB using the database service object.
                Depot depot = Depot(name: myNameController.text,
                address: myAddressController.text,
                comments: myDescriptionController.text,
                contactNumber: myContactController.text,
                lat:"0", //myLatController.text,
                long: "0" );//myLongController.text);
                databaseProvider.pushDepot(depot);
                Navigator.pop(context);
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      );
    }
    else{ //the same as add but editing instead.
      myNameController.text = item.name;
      myAddressController.text = item.address;
      myDescriptionController.text = item.comments;
      myContactController.text = item.contactNumber;
      return Scaffold(
        appBar: AppBar
          (
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/depots');
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
                controller: myNameController,
                decoration: InputDecoration(
                  labelText: "Enter Depot Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myAddressController,
                decoration: InputDecoration(
                  labelText: "Enter Address *Note this must be exactly as google lists it*",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myContactController,
                decoration: InputDecoration(
                  labelText: "Enter Contact Number",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: myDescriptionController,
                decoration: InputDecoration(
                  labelText: "Enter Comments",
                ),
              ),
            ),


            FloatingActionButton(
              onPressed: () async {
                Depot depot = Depot(name: myNameController.text,
                    address: myAddressController.text,
                    comments: myDescriptionController.text,
                    contactNumber: myContactController.text,
                    lat: "0",//myLatController.text,
                    long: "0");//myLongController.text);
                databaseProvider.setDepot(depot, item.key);
                Navigator.pop(context);
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      );
    }
  }
}