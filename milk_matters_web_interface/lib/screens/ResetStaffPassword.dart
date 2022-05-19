import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

/// The page to reset a staff password for the webapp, implemented as a StatefulWidget.
class ResetStaffPassword extends StatefulWidget {

  /// Creates the state containing the functionality for the page.
  @override
  _ResetStaffPassword createState() => _ResetStaffPassword();
}

/// The state created by the page.
class _ResetStaffPassword extends State<ResetStaffPassword> {

  /// The text controller for collecting the admin password from user input.
  final myJennyPasswordController = TextEditingController();
  /// The text controller for collecting the email from user input.
  final myEmailController = TextEditingController();
  /// Bool set to either true/false, depending on whether the email is of valid form.
  bool validEmail = false;
  /// Bool set to either true/false, depending on whether the admin password is of valid form.
  bool validPassword = false;
  /// Easily settable error text for feedback to user.
  Text validationText = Text("");

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();
  }

  /// Disposes the state's controllers when it is closed.
  @override
  void dispose() {
    myJennyPasswordController.dispose();
    myEmailController.dispose();
    super.dispose();
  }

  /// Builds the page, using the provided BuildContext
  @override
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
                decoration: InputDecoration(
                    labelText: "Enter Email"
                ),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: myJennyPasswordController,
                decoration: InputDecoration(
                    labelText: "Enter Admin Password"
                ),
                obscureText: true,
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return "Please enter an admin password";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (validEmail == true) {
                    if (databaseProvider.checkJennyPassword(myJennyPasswordController.text)) {
                      databaseProvider.resetStaffPassword(myEmailController.text, myJennyPasswordController.text);
                      Navigator.pushNamed(context, '/accountManagement');
                    }
                    else {
                      setState(() {
                        validationText = Text("Incorrect admin password",
                          style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic),
                        );
                      });
                    }
                  }
                  else {
                    setState(() {
                      validationText = Text("Incorrect email or password format",
                          style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic),
                      );
                    });
                  }

                },
                label: Text("Reset"),
              ),
            )
          ]
      ),);
  }
}