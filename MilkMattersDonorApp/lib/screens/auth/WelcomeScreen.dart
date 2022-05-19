import 'package:flutter/material.dart';

/// This stateless widget displays the Welcome screen with Login and Sign Up screen
///
/// It allows users to register an account by completing and then submitting a form.
class WelcomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Milk Matters',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          centerTitle: true,
          elevation: 1.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ///Welcome
              Padding(
                padding: const EdgeInsets.fromLTRB(30,30.0,30,0),
                child: Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                    color: Colors.grey[900],
                  ),
                ),
              ),

              /// Description
              Padding(
                padding: const EdgeInsets.fromLTRB(30,10,30,10),
                child: Text(
                  'Login or create an account to get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              ///Milk Matters logo
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Image.asset('assets/milk_matters_logo_login.png', height: 80, width: 80,),
              ),
              /// Login Description
              Padding(
                padding: const EdgeInsets.fromLTRB(30,10,30,10),
                child: Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              /// Login Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                    /// Navigate to the registration screen
                    onPressed: () async {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: Text('Login', ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(15),
                      minimumSize: Size(double.infinity, 30), // double.infinity
                    ),
                ),
              ),

              /// Create Description
              Padding(
                padding: const EdgeInsets.fromLTRB(30,30,30,10),
                child: Text(
                  'New to the app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              /// Create account button
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ElevatedButton(
                /// Navigate to the registration screen
                onPressed: () async {
                  Navigator.popAndPushNamed(context, '/register');
                },
                child: Text('Create an Account'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(15),
                  minimumSize: Size(double.infinity, 30), // double.infini
                ),
              ),
        ),
            ],
          ),
        ),
      ),
    );
  }
}
