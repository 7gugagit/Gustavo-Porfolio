import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:provider/provider.dart';

/// The widget that displays the Forgot Password screen
///
/// This allows users to reset their password using their registered email address.
class ForgotPassword extends StatelessWidget {

  /// Variables to access the state of the form, and retrieve the entered data
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    /// Used to access the authentication services from within the widget tree
    final authProvider = Provider.of<FirebaseAuthenticationService>(context);

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(253, 220, 216, 1),
          appBar: AppBar(
            title: Text(
              'Forgot Password',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            elevation: 1.0,
          ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0.0),
                child: Image.asset('assets/milk_matters_logo_login.png', height: 80, width: 80,),

              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'Please enter your email address below and we\'ll send you an email to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20,0,20,5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(0.3, 0.3),
                        blurRadius: 3.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Column(
                    children: [
                      FormBuilder(
                        key: _fbKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 5.0),
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
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                  child: Text("Send Email"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.all(10),
                                    minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                                  ),
                                  /// Validate the form
                                  /// If validated, then use the auth provider to send a password reset email
                                  onPressed: () {
                                    if(_fbKey.currentState.validate()) {
                                      BotToast.showLoading();
                                      var result = authProvider.sendForgotPasswordEmail(emailController.text.trim());
                                      BotToast.closeAllLoading();
                                      if(result==null){
                                        BotToast.showText(
                                          text: 'Your request cannot be processed. Please try again or contact Milk Matters.',
                                        );
                                      } else {
                                        BotToast.showText(
                                          text: 'A password reset link has been sent to your email address.',
                                        );
                                      }
                                    }
                                    Navigator.pop(context);
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
        )
    )
    );
  }
}
