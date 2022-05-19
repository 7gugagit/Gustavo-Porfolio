import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';

/// The login page for the webapp, implemented as a StatefulWidget.
class Login extends StatefulWidget{

  /// Creates the state containing the functionality for the page.
  @override
  _Login createState() => _Login();
}

/// The state created by the page.
class _Login extends State<Login>
{

  /// Text controller for collecting the email from user input.
  final myEmailController = TextEditingController();
  /// Text controller for collecting the password from user input.
  final myPasswordController = TextEditingController();
  /// Easily settable error text for feedback to user.
  Text myTextErrorController = Text("");

  /// Initialises the page's state
  @override
  void initState() {
    super.initState();
  }

  /// Disposes the state's controllers when it is closed.
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }


  /// Builds the page, using the provided BuildContext
  @override
  Widget build(BuildContext context) {
    //final authenticationProvider = Provider.of<AuthenticationService>(context);
    final databaseProvider = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Milk Matters Login"),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                autovalidate: true,
                validator: (value) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern); //regular expression to validate emails
                  if (regExp.hasMatch(value)) {
                    return null;
                    }
                  else {
                    return "Please enter a valid email address";
                  }
                },
                controller: myEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Enter Email"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextFormField(
                controller: myPasswordController,
                decoration: InputDecoration(
                    labelText: "Enter Password"
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  var login = await databaseProvider.signInUser(myEmailController.text, myPasswordController.text);
                  if (login == null) {
                    debugPrint("No user account found");
                    setState(() {
                      myTextErrorController = Text("Incorrect Email or Password",
                        style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.italic
                        ),
                      );
                    });

                    //Notify user of what's happened
                  }
                  else
                  {
                    debugPrint("User Account found! Email: " + login.user.email.toString());
                    Navigator.pushNamed(context, '/home');
                  }
                },
                label: Text("Login"),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: myTextErrorController
            ),
          ]
      ),

    );
  }

}