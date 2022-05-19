import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:milk_matters_donor_app/helpers/AuthExceptionHandler.dart';
import 'package:milk_matters_donor_app/helpers/AuthResultStatus.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';

/// This stateless widget displays the Register screen
///
/// It allows users to register an account by completing and then submitting a form.
class Register extends StatelessWidget {

  /// Key to access the form's state
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  /// Controllers to access data inputted into the form
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    /// Providers to access the authentication and database services
    var _authProvider = Provider.of<FirebaseAuthenticationService>(context);
    var _databaseProvider = Provider.of<FirebaseDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            'Register',
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
              ///Milk Matters Logo
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0.0),
                child: Image.asset('assets/milk_matters_logo_login.png', height: 80, width: 80,),
              ),

              ///Register Description
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'Please complete and submit the form to create an account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),

              ///Form Box
              Padding(
                padding: EdgeInsets.fromLTRB(20,0,20,20),
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
                  ///Full names
                  child: Column(
                    children: [
                        FormBuilder(
                          key: _fbKey,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                            child: Column(
                              children: <Widget>[
                                FormBuilderTextField(
                                  controller: nameController,
                                  attribute: "fullName",
                                  decoration: InputDecoration(
                                    labelText: "Full Name",
                                    icon: Icon(Icons.person_outline),
                                    //focusedBorder:
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Please enter a full name.'
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                ///Phone Number
                                FormBuilderTextField(
                                  controller: phoneNumberController,
                                  attribute: "phoneNumber",
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    icon: Icon(Icons.phone_outlined),
                                    //focusedBorder:
                                  ),
                                  ///Phone Number
                                  validators: [
                                    FormBuilderValidators.required(
                                        errorText: 'Please enter a phone number.'
                                    ),
                                    FormBuilderValidators.numeric(
                                        errorText: 'Please enter a valid phone number.'
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                ///Email validation
                                FormBuilderTextField(
                                  controller: emailController,
                                  attribute: "email",
                                  decoration: InputDecoration(
                                    labelText: "Email",
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
                                ///Password Validation
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

                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child:
                              ElevatedButton(
                                child: Text("Register"),

                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.all(10),
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[200],),
                                  minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                                ),
                                /// If the form is validated correctly,
                                /// then attempt to register the account.
                                /// Inform the user of any errors, or log them into their account.
                                onPressed: () async  {
                                  if(_fbKey.currentState.validate()) {
                                    BotToast.showLoading();
                                    AuthResultStatus result = await _authProvider.registerEmailPassword(
                                        emailController.text,
                                        passwordController.text);
                                    if(result==AuthResultStatus.successful){
                                      await _databaseProvider.pushNewDonorUser(emailController.text.trim(),
                                          nameController.text.trim(), phoneNumberController.text.trim());
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created successfully!')));
                                      Navigator.popAndPushNamed(context, '/home');
                                    }
                                    BotToast.closeAllLoading();
                                    String response = AuthExceptionHandler.generateExceptionMessage(result);
                                    if(result!=AuthResultStatus.successful){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(response),),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),

                              ],
                            ),
                          ),
                        ),
                      ],
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
