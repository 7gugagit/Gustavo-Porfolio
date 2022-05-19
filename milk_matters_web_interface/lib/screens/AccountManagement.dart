import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

/// The account management page for the webapp, implemented as a StatefulWidget
class AccountManagement extends StatefulWidget {

  /// Creates the state containing the functionality for the page.
  @override
  _AccountManagement createState() => _AccountManagement();

}

/// The state created by the page
class _AccountManagement extends State<AccountManagement> {

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();

  }

  /// Builds the page, using the provided BuildContext
  @override
  Widget build(BuildContext context) {

    final databaseProvider = Provider.of<DatabaseService>(context);
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar
        (
        leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }
        ),
        title: Text("Milk Matters"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
        ),
      body: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: GridView.count(
          childAspectRatio: size.width/size.height,
          primary: false,
          padding: const EdgeInsets.all(100),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            SingleChildScrollView(
              child: Container( //dashboard
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: const Text("Register a Donor Number",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("Register a donor number for use in the mobile app",
                        textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: RaisedButton(
                        onPressed: () {
                          print("Going to donor number registration");
                          Navigator.pushNamed(context, '/registerDonorNumber');
                        },
                        child: Text("Register"),
                      ),
                    )
                  ],
                ),
                color: Colors.pink[100],
              ),
            ),
            SingleChildScrollView(
                child: Container( //Articles
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text("Create a new staff account",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Create a new account to manage the milk matters app",
                          textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/createStaffAccount');
                          },
                          child: Text("Create account"),
                        ),
                      )
                    ],
                  ),
                  color: Colors.pink[200],
                ),
            ),
            SingleChildScrollView(
                child: Container( //News and Events
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text("Reset a staff account password",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Reset a password associated with a staff account",
                          textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/resetStaffPassword');
                          },
                          child: Text("Reset Password"),
                        ),
                      )
                    ],
                  ),
                  color: Colors.pink[200],
                ),
            ),
            SingleChildScrollView(
                child: Container( //dashboard
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: const Text("Delete a Donor Number",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Delete a donor number being used in the mobile app",
                          textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: RaisedButton(
                          onPressed: () {
                            print("Going to donor number deletion");
                            Navigator.pushNamed(context, '/deleteDonorNumber');
                          },
                          child: Text("Delete a Donor Number"),
                        ),
                      )
                    ],
                  ),
                  color: Colors.pink[100],
                ),
            ),





          ],
        ),
      ),

    );
  }
}