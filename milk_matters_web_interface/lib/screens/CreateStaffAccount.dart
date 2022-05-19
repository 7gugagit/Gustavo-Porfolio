import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

/// The page to create a staff account for the webapp, implemented as a StatefulWidget.
class CreateStaffAccount extends StatefulWidget {

  /// Creates the state containing the functionality for the page.
  @override
  _CreateStaffAccount createState() => _CreateStaffAccount();
}

/// The state created by the page.
class _CreateStaffAccount extends State<CreateStaffAccount> {

  /// The text controller for collecting the password from user input.
  final myPasswordController = TextEditingController();
  /// The text controller for collecting the repeated password from user input.
  final myPasswordCheckController = TextEditingController();
  /// The text controller for collecting the admin password from user input.
  final myJennyPasswordController = TextEditingController();
  /// The text controller for collecting the email from user input.
  final myEmailController = TextEditingController();
  /// Easily settable error text for feedback to user.
  Text validationText = Text("");
  /// Bool set to either true/false, depending on whether the email is of valid form.
  bool validEmail = false;
  /// Bool set to either true/false, depending on whether the email is of valid form.
  bool validPassword = false;

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();
  }

  /// Disposes the state's controllers when it is closed.
  @override
  void dispose() {
    myPasswordController.dispose();
    myPasswordCheckController.dispose();
    myJennyPasswordController.dispose();
    myEmailController.dispose();
    super.dispose();
  }

  /// Builds the page, using the provided BuildContext
  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Milk Matters"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/accountManagement');
            }
        ),
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
                controller: myPasswordController,
                decoration: InputDecoration(
                    labelText: "Enter Password"
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    validPassword = false;
                    return "Please enter 6-character long password";
                  }
                  else {
                    validPassword = true;
                    return null;
                  }
                },
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: myPasswordCheckController,
                decoration: InputDecoration(
                    labelText: "Re-enter Password"
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: myJennyPasswordController,
                decoration: InputDecoration(
                    labelText: "Enter Admin Password"
                ),
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return "Please enter an admin password";
                  }
                  else {
                    return null;
                  }
                },
                obscureText: true,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(6.0),
                child: validationText
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (myPasswordController.text == myPasswordCheckController.text) {
                    if (validEmail && validPassword) {
                      if (databaseProvider.checkJennyPassword(myJennyPasswordController.text))
                        {
                          databaseProvider.createNewStaffAccount(myEmailController.text, myPasswordController.text, myJennyPasswordController.text);
                          Navigator.pop(context);
                        }
                      else {
                        setState(() {
                          validationText = Text("Incorrect Admin password",
                            style: TextStyle(
                                color: Colors.red,
                                fontStyle: FontStyle.italic),);
                        });
                      }
                    }
                    else {
                      setState(() {
                        validationText = Text("Incorrect email or password format",
                          style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic),);
                      });
                    }

                  }
                  else {
                    setState(() {
                      validationText = Text("Passwords don't match",
                        style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic),);
                    });
                  }
                },
                label: Text("Create Account"),
              ),
            )
          ]
      ),);
  }
}