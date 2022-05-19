import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_matters_donor_app/screens/FullUrl.dart';
import 'package:milk_matters_donor_app/models/AboutItem.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:milk_matters_donor_app/services/FirebaseAnalytics.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';

/// The stateless widget which displays the contact us screen
///
/// Provides information about Milk Matters, and their contact details
class About extends StatelessWidget {

  String description ="Milk Matters is a community-based breast milk bank, "
      "that distributes donations of screened breast milk to premature babies.\n\n"
      "We aim to expand the delivery of pasteurised breast milk to many more vulnerable babies, "
      "and also to educate others about this significant cause.\nWhen it comes to breast milk, "
      "demand always exceeds supply and it is very much needed 365 days of the year.\n\n"
      "Help us to provide babies with a crucial life-line by getting involved.",

      email ="info@milkmatters.org",
      num1 = "082 895 8004",
      num2 ="021 659 5599";
  AboutItem aboutItem;


  @override
  Widget build(BuildContext context) {
    Color socialColor = Theme.of(context).primaryColor;
    double socialSize = 40;
    var title = 'Milk Matters';
    var aboutItem = Provider.of<FirebaseDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        ///set up appbar and background colour
        backgroundColor: Color.fromRGBO(237, 237, 237, 1),
        appBar: AppBar(
          title: Text(
            'About Us',
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

          body:

          Container(
            child: FutureBuilder(
              future:  aboutItem.getAbout(),
              builder: (context, snapshot) {
                // Checking if future is resolved or not
                if (snapshot.connectionState == ConnectionState.done) {
                  // If we got an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: TextStyle(fontSize: 16),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    /// Extracting About Us data from snapshot object
                    final AboutItem about = snapshot.data[0];
                    description = about.description;
                    num1 = about.primaryNumber;
                    num2 = about.secondaryNumber;
                    email = about.email;
                    title = about.title;

                return  ListView(
                physics: BouncingScrollPhysics(),

                children: <Widget>[

                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [

                        ///About label and image
                          ListTile(
                          leading: Image.asset('assets/milk_matters_logo_login.png'),
                          title: Text(title.toUpperCase()),
                          ),

                          ///description
                          Padding(
                          padding: const EdgeInsets.all(16.0),
                              child: Text(
                                '$description',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16
                                ),
                              ),
                            ),

                          ///Become a donor text button
                          Padding(
                          padding: const EdgeInsets.fromLTRB(14, 5, 16, 14),
                          child: RichText(
                            text: TextSpan(
                              text: 'Find out how to become a breastmilk donor',
                              style: TextStyle(
                                color: Colors.blueAccent, fontSize: 16.0),
                              recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                              Navigator.pushNamed(context, '/becomeADonor');
                              },
                            ),
                            textAlign: TextAlign.center,
                          ),
                          ),
                        ],
                        ),
                    ),
                  ),
                ),

                ///Contact Us
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///CONTACT US
                          ListTile(
                            leading: Image.asset('assets/milk_matters_logo_login.png'),
                            title: Text("CONTACT US"),
                          ),

                          ///Contact Us details
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ///Phone number 1
                                ElevatedButton.icon(
                                    onPressed: () {
                                      _handleContactURL(context, "tel:"+num1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                    icon: Icon(Icons.phone),
                                    label: Text(num1), //
                                ),

                                  ///Phone number 2
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _handleContactURL(context, "tel:"+ num2);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  icon: Icon(Icons.phone),
                                  label: Text(num2),
                                ),

                                  ///Email
                                  ElevatedButton.icon(
                                  onPressed: () {
                                  // _handleContactURL(context, 'mailto:'+ aboutItem.email); //"mailto:info@milkmatters.org"
                                  },
                                  icon: Icon(Icons.email),
                                  label: Text(email),
                                    style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                    padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),

                ///Social Media label
                Text(
                  'Connect with Milk Matters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    //letterSpacing: 0.8,
                    letterSpacing: 1,
                    color: Colors.grey[700],
                  ),
                ),

                ///Social Media Buttons
                Container(
                  height: 80,
                  child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  direction: Axis.horizontal,
                  children: [
                  Expanded(
                  flex: 1,
                  child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                  iconSize: socialSize,
                  onPressed: () {
                  Analytics().logEvent('Facebook');
                  _handleURLButtonPress(
                  context, 'https://www.facebook.com/MilkMatters',
                  title);
                },
                icon: Icon(Icons.facebook_rounded,
                color: socialColor),
                ),
                ),
                ),
                Expanded(
                child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                iconSize: socialSize,
                onPressed: () async {
                Analytics().logEvent('Instagram');
                _handleURLButtonPress(context,
                'https://www.instagram.com/milkmattersmilkbank/',
                title);
                },
                icon: Icon(FontAwesome5.instagram,
                color: socialColor),
                ),
                ),
                ),
                Expanded(
                child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                iconSize: socialSize,
                onPressed: () async {
                Analytics().logEvent('Milk Matters Website');

                ///log event
                _handleURLButtonPress(
                context, 'https:www.milkmatters.org', title);
                },
                icon: Icon(Icons.language, color: socialColor),
                ),
                ),
                ),
                ],
                ),
                ),
                ],
                );

                  }
                }
                // Displaying LoadingSpinner to indicate waiting state
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),



        ),
      ),
    );
  }
///launch social media
  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
///launch phone and email
  void _handleContactURL(BuildContext context, String url) async {
    //_launchCaller() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text('Could not launch $url'),
        ),
      );
    }
  }

}
