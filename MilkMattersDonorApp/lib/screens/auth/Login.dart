import 'package:bot_toast/bot_toast.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milk_matters_donor_app/helpers/AuthResultStatus.dart';
import 'package:milk_matters_donor_app/helpers/AuthExceptionHandler.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// This stateful widget displays the Login screen
///
/// It provides users with a way to login to the application,
/// by entering an email and password.
/// It contains buttons to navigate to the register and forgot password screens
class Login extends StatefulWidget {
  @override
  /// Creates the state containing the functionality and widget tree.
  _LoginState createState() => _LoginState();
}

/// The state created by the widget.
class _LoginState extends State<Login> {
  /*final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user;

  Future<User> googleLogin() async{
    await googleSignIn.signIn();
    if (googleU)
  }*/

  /// Key used to access the state of the form
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  /// Controllers to access the form's input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loaded = false;
  Image mmLogoImg;

  @override
  void didChangeDependencies() {
    precacheImage(mmLogoImg.image, context).then((value){
      setState(() {
        loaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    mmLogoImg = Image.asset('assets/milk_matters_logo_login.png');
  }

  @override
  /// Builds this screens widget tree
  Widget build(BuildContext context) {

    /// Provider used to access the firebase database
    var _authProvider = Provider.of<FirebaseAuthenticationService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('Login',
            style: Theme.of(context).appBarTheme.titleTextStyle,),
          centerTitle: true,
      ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: loaded == false ? Container(child: Center(child: CupertinoActivityIndicator(radius: 30.0))) :
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0.0),
                child: Image.asset('assets/milk_matters_logo_login.png', height: 80, width: 80,),

              ),

              /*///Description
              Padding(
                padding: const EdgeInsets.fromLTRB(30,10,30,10),
                child: Text(
                  'Login below',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),*/

              ///Login form
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(0.3, 0.3),
                        blurRadius: 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),

                  child: Column(
                    children: [
                      FormBuilder(
                        key: _fbKey,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: <Widget>[
                              FormBuilderTextField(
                                controller: emailController,
                                attribute: "email",
                                decoration: InputDecoration(
                                  labelText: "Email Address",
                                  icon: Icon(Icons.email_outlined),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'Please enter an email address.'
                                  ),
                                  FormBuilderValidators.email(
                                      errorText: 'Please enter a valid email address.'
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              FormBuilderTextField(
                                controller: passwordController,
                                attribute: "password",
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  icon: Icon(Icons.lock_outline),
                                ),
                                validators: [
                                  FormBuilderValidators.required(
                                      errorText: 'Please enter a password.'
                                  ),
                                ],
                              ),
                              ///  forgot password textbutton
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forgotPassword');
                                },
                                child: Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              ///Login
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10,0, 0),
                                child: ElevatedButton(
                                  child: Text("Login"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.all(10),
                                    minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                                  ),

                                  /// If the input form is successfully validated,
                                  /// then attempt to sign in using the provided credentials.
                                  onPressed: () async  {
                                    //Login functionality
                                    if(_fbKey.currentState.validate()) {
                                      BotToast.showLoading();
                                      AuthResultStatus result = await _authProvider.signInEmailPassword(
                                          emailController.text.trim(),
                                          passwordController.text);
                                      BotToast.closeAllLoading();
                                      /// login failed
                                      if(result!=AuthResultStatus.successful){
                                        BotToast.showText(
                                          text: AuthExceptionHandler.generateExceptionMessage(result),
                                        );
                                      }
                                      else {
                                        Navigator.popAndPushNamed(context, '/home');
                                      }
                                      FirebaseAnalytics().logLogin(); ///log login event
                                    }
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                      ///or
                      /*Container(
                        child: Text("or"),

                      ),*/

                      ///TODO: google signin button

                    ],
                  ),
                ),

              ),
              /*Container(
                margin: const EdgeInsets.all(30),
                child: ElevatedButton.icon(
                  label: Text("Sign in with Google"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                  ),
                  icon: FaIcon(FontAwesomeIcons.google,),

                  /// If the input form is successfully validated,
                  /// then attempt to sign in using the provided credentials.
                  onPressed: () async  {


                  },
                ),
              ),*/
            ],

          ),
        ),
      ),
    );
  }
}

