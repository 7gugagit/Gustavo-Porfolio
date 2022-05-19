import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/screens/FullUrl.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseAnalytics.dart';

/// This is the navigation drawer widget (menu bar)
/// The widget itself contains each menu item as a list tile,
/// of which the ontap() triggers processNavigation().

/// Each navdrawer is constructed using the parent screen's name.

class NavDrawer extends StatelessWidget {

  final FirebaseAuthenticationService _authService = FirebaseAuthenticationService();
  String _screenName;

  NavDrawer(String _screenName){
    this._screenName = _screenName;
  }

  /// This method processes the navigation from a particular screen to another via the navigation drawer.
  /// Essentially performs 2 checks,
  /// 1: If already on the screen that was selected, then ignore.
  /// 2: If on a screen other than home, then push a named replacement, otherwise just push the new screen.
  /// This ensures that we always display the home screen if back is pressed on any other screen.
  void processNavigation(BuildContext context, String route, String navigationPressed) {
    if (navigationPressed == _screenName) {
      return;
    } if(_screenName != 'Home'){
      Analytics().logEvent('Home'); ///log event
        if(_screenName == 'Education Articles'){
          Analytics().logEvent('Education Articles'); ///log event
          Navigator.pop(context);
        }
        Navigator.pushReplacementNamed(context, route);
        return;
    } else {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
              ),
              child: Image(image: AssetImage('assets/milk_matters_logo_login.png'), fit: BoxFit.contain,),
            ),

            /// About Milk Matters
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () => {processNavigation(context, '/aboutMilkMatters', 'About'), Analytics().logEvent('About')},
            ),

            /// Depot Locator
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Depot Locator'),
              onTap: () => {processNavigation(context, '/securityCheckDepots', 'Depot Locator'), Analytics().logEvent('Depot Locator')},
            ),

            /// help
            ListTile(
              leading: Icon(Icons.help_outline_outlined),
              title: Text('Frequently Asked Questions'),
              onTap: () => {
                processNavigation(context, '/faqs', 'Frequently Asked Questions'), Analytics().logEvent('FAQs')
            },
            ),

            /// launch mobile app privacy policy
            ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Privacy Policy'),
              onTap: () =>  _handleURLButtonPress(context, 'https://milkmatters.org/resources/privacy-policy-milk-mattters-app', 'Privacy Policy'),
            ),

            /// user log out
            ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Logout'),
              onTap: () async {
                Analytics().logEvent('User Logout');
                await _authService.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}
