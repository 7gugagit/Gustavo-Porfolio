import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:milk_matters_donor_app/screens/FullUrl.dart';


/// This stateless widget displays the Privacy Info screen
///
/// It displays the use of personal info on the app, and how usage will be tracked.
class PrivacyPolicy extends StatelessWidget {
  final privacyPolicyURL = 'https://milkmatters.org/resources/privacy-policy-milk-mattters-app/';

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(253, 220, 216, 1),
        appBar: AppBar(
          title: Text(
            'Privacy Policy',
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Milk Matters Logo
              Padding(
                padding: const EdgeInsets.fromLTRB(0,15,0,0),
                child: Image.asset('assets/milk_matters_logo_login.png', height: 80, width: 80,),
              ),

              /// Privacy Policy Heading
              Padding(
                padding: const EdgeInsets.fromLTRB(0,15,0,0),
                child: Text('Milk Matters Donor App Beta Testing',
                   style: TextStyle(
                     fontSize: 18.0,
                     fontWeight: FontWeight.w500,
                     color: Colors.grey[900],
                   )
                )

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25,2,25,0),
                child: Text(
                  'This app is being developed in collaboration between UCT Computer Science and Milk Matters.\n\n'
                      'Please note that by using this app, you consent to the following: \n\n'
                      'We use your device information (in particular, your IP address) to improve and optimize the app. We generate analytics about how our app\'s users interact with the apps\'s features.\n\n'
                      'The personal information you add during registration/login (i.e. name, email address, and contact number) will only be used to gain access to the app and verify donor status with Milk Matters. \n\nYou may be asked to provide permissions for the app to access your device’s location, while entirely optional, none of the location data is sent from your device or collected.\n\n'
                      'If you would like to withdraw consent, please uninstall the app.',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),

              ///Privacy policy for mobile app link to website
              Padding(
                padding: const EdgeInsets.fromLTRB(0,15,0,5),
                child: RichText(
                  text: TextSpan(
                    text: 'Read our full privacy policy here',
                    style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline, fontSize: 16.0),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                            _handleURLButtonPress(context, privacyPolicyURL, 'Privacy Policy');
                        },
                  ),
                ),
              ),

              Center(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /// Yes Consent
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child:
                        ElevatedButton(
                          child: Text("I consent"),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                ),
                          ),
                            onPressed: () async {
                            Navigator.popAndPushNamed(context, '/welcome');
                            }
                        ),
                    ),
                    /// No consent
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child:
                      ElevatedButton(
                                    child: Text("I do not consent"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[200],),
                                    ),
                                    onPressed: () async {
                                    showDialog(context: context,
                                        builder: (BuildContext context) => CupertinoAlertDialog(
                                          title: Text("I do not Consent"),
                                          content: Text("We're sorry, but the app is still in the testing phase and we will be tracking usage throughout the app. \n\n Stay in touch with Milk Matters, and once the app is officially released they will let you know when you can use it."),
                                          actions: [
                                            CupertinoDialogAction(
                                              isDefaultAction: true,
                                                child: Text('Close', style: TextStyle(color: Theme.of(context).accentColor)),
                                                onPressed: ()async{
                                                  Navigator.of(context).pop();
                                                }
                                            ),
                                          ],
                                        )
                                    );
                                  }
                                ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}