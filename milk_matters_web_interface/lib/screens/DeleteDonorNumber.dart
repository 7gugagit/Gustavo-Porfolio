import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// The page to delete a donor number for the webapp, implemented as a StatefulWidget.
class DeleteDonorNumber extends StatefulWidget {

  /// Creates the state containing the functionality for the page.
  @override
  _DeleteDonorNumber createState() => _DeleteDonorNumber();
}

/// The state created by the page.
class _DeleteDonorNumber extends State<DeleteDonorNumber> {

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();
  }

  /// The text controller for collecting the email from user input.
  final myEmailController = TextEditingController();
  /// Bool set to either true/false, depending on whether the email is of valid form.
  bool validEmail = false;

  /// Disposes the state's controllers when it is closed.
  void dispose(){
    myEmailController.dispose();
    super.dispose();
  }

  ///Confirmation dialog to ensure deletion of donor number.
  Future<void> showDeletionDialog(DatabaseService databaseProvider, String email) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete confirmation"),
            content: Text("Are you sure you want to delete this donor number?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    databaseProvider.deleteDonorNumber(email);
                    Navigator.of(context).pop();
                  }, child: Text("Delete")),
            ],);
        }
    );
  }

  /// Builds the page, using the provided BuildContext
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar
        (
        title: Text("Milk Matters"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/accountManagement');
            }
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextFormField(
              controller: myEmailController,
              autovalidate: true,
              validator: (value) {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                if (regExp.hasMatch(value)) {
                  validEmail = true;
                  return null;
                }
                else {
                  validEmail = false;
                  return "Please enter a valid email address";
                }
              },
              decoration: InputDecoration(
                labelText: "Enter email",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () async {
                String emailDel = myEmailController.text.replaceAll(".", ",");
                await showDeletionDialog(databaseProvider, emailDel);
                Navigator.pop(context);
              },
              label: Text("Delete Donor"),
            ),
          )
        ],
      ),
    );
  }
}
