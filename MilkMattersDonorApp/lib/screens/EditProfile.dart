import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Edit Profile Screen
class EditProfile extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;

  EditProfile(this.name, this.phoneNumber, this.email);
  @override
  createState() => _EditProfile(this.name, this.phoneNumber, this.email);
}

/// This stateless widget displays the Register screen
///
/// It allows users to register an account by completing and then submitting a form.
class _EditProfile extends State<EditProfile> {
  String name;
  String phoneNumber;
  String email;

  _EditProfile(this.name, this.phoneNumber, this.email);
  @override
  Widget build(BuildContext context) {

    /// Providers to access the authentication and database services
    //var _authProvider = Provider.of<FirebaseAuthenticationService>(context);
    //var _databaseProvider = Provider.of<FirebaseDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        ///AppBar
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 1.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
        IconButton(
        icon: const Icon(Icons.check),
        tooltip: 'Save',
        ///TODO: Update changes in firebase
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile Saved')));
        },
        ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(30),
            child: GestureDetector(
              child: ListView(
                children: [
                  buildTextField("Full Name", name),
                  buildTextField("Email", email),
                  buildTextField("Phone Number", phoneNumber),
                ]
            ),
            ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder){
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,

          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey
          )
        ),
      ),
    );
  }
}
