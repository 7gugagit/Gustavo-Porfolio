import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

/// The page to register a donor number for the webapp, implemented as a StatefulWidget.
class RegisterDonorNumber extends StatefulWidget {

  /// Creates the state containing the functionality for the page.
  @override
  _RegisterDonorNumber createState() => _RegisterDonorNumber();

}

/// The state created by the page.
class _RegisterDonorNumber extends State<RegisterDonorNumber> {

  /// The text controller for collecting the donor number from user input.
  final myDonorNumberController = TextEditingController();
  /// The text controller for collecting the email from user input.
  final myEmailController = TextEditingController();
  /// Bool set to either true/false, depending on whether the email is of valid form.
  bool validEmail = false;
  /// Bool set to either true/false, depending on whether the donor number is of valid form.
  bool validCode = false;
  /// Easily settable error text for feedback to user.
  Text validationText = Text("");

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();
  }

  /// Disposes the state's controllers when it is closed.
  @override
  void dispose(){
    myDonorNumberController.dispose();
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
              child:TextFormField(
                controller: myDonorNumberController,
                autovalidate: true,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    validCode = false;
                    return "Please enter a donor number";
                  }
                  else {
                    validCode = true;
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Enter donor number",
                ),
              ),
            ),
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
                padding: const EdgeInsets.all(6.0),
                child: validationText
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  if (validEmail && validCode) {
                    NewDonorNumber donorNumber = NewDonorNumber(donorNumber: myDonorNumberController.text, email: myEmailController.text);

                    databaseProvider.pushDonorNumber(donorNumber);
                    Navigator.pushNamed(context, '/accountManagement');
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
              ),
            )
          ],
        ),
    );
  }

}