import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/NavDrawer.dart';
//import 'package:milk_matters_donor_app/screens/EditProfile.dart';
//import 'package:milk_matters_donor_app/screens/Profile.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/DonationTracker.dart';
import 'package:milk_matters_donor_app/screens/education/EducationCategories.dart';
import 'package:milk_matters_donor_app/screens/Home.dart';



/// The stateful widget which displays the home screen
///
/// This contains buttons to access the donation graphs, Milk Matters social media,
/// and displays the news and events feed
class Home extends StatefulWidget {

  @override
  /// Creates the state containing the functionality and widget tree.
  _HomeState createState() => _HomeState();

  ///static FirebaseAnalyticsObserver firebaseAnalyticsObserver = new FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

}
/// The state created by the widget.
class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> pageList = <Widget>[
    HomeLayout(),
    DonationTracker(),
    EducationCategories(),
    //EditProfile('Zukiswa', '0614231859', 'Zukiswa@gmail.com'),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: NavDrawer('Home'),
        body: pageList[_currentIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value){
            setState(() {
              _currentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.assessment_outlined), label: 'Donations'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Education'),
            //BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

}
