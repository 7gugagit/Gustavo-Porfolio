import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/NavDrawer.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/NewsAndEventCard.dart';
import 'package:milk_matters_donor_app/models/NewsAndEventsItem.dart';
//import 'package:milk_matters_donor_app/screens/FullUrl.dart';
import 'package:provider/provider.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:milk_matters_donor_app/services/FirebaseAnalytics.dart';

/// This stateless widget displays the news and events screen
class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Retrieve the provider to access the news and events from the firebase database
    var _localDBProvider = Provider.of<LocalDatabaseService>(context);
    var _newsAndEvents = Provider.of<List<NewsAndEventsItem>>(context);
    //const social_color = Colors.white;
    //double socialSize = 20.0;
    //var donorStatus;
    //var title = 'Milk Matters';
    String donationText = 'You haven\'t logged any donations yet';
    double feeds;


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Home',
          ),
          centerTitle: true,
        ),
        drawer: NavDrawer('Home'),

        body:
        Column(
        children: [

///TODO: Check donor status  to show buttons
          ///       if(_fbKey.currentState.validate()){
          //
          //                       var result = await _databaseProvider.validateDonorNumber(_authProvider.getCurrentUser().email, donorNumberController.text);
            ///Donations button
            Container(
              height:70,
              child: (isDonor())


                  ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(237, 237, 237, 1),
                          onPrimary: Colors.black,
                          //primary: Theme.of(context).primaryColor,
                          elevation: 3,
                        ),
                        onPressed: (){
                          Analytics().logEvent('view Donation graph'); ///log event
                          Navigator.pushNamed(context, '/donationGraphs', arguments: {'initialTab' : 0});
                        },
                        /// baby icon
                        icon: Icon(FontAwesome5.baby, color: Colors.grey[900]),
                        /// text
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                                future: _localDBProvider.getTotalDonatedAmount(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                     feeds = double.parse((snapshot.data/50).toStringAsFixed(2));
                                     donationText = 'You\'ve donated ${snapshot.data.toString()}ml \nfeeding a baby for $feeds days';
                                  }
                                  return Text(donationText,
                                      style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[900],
                                  ),
                                  );
                                }
                            ),
                           // Text('Donated', style: TextStyle(color: Colors.grey[200], fontSize: 16),),
                          ],
                        ),
                      ),
                    ),
              )



            ///Become a Donor button
            : Container(
              margin: const EdgeInsets.all(10),
              child:
              ElevatedButton(
                  child: Text("Interested in becoming a breastmilk donor", textAlign: TextAlign.center,),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    padding: EdgeInsets.all(10),
                    minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height

                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/donorProcess');
                  }
              ),
            ),
            ),

            ///News and events
            Expanded(
              child: _newsAndEvents == null ? Container(child: Center(child: CupertinoActivityIndicator(radius: 30.0))) :
              Container(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  // Let the ListView know how many items it needs to build.
                  itemCount: _newsAndEvents.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    final item = _newsAndEvents[index];
                    return NewsAndEventCard(
                      newsAndEventsItem: item,
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        ),
      );
  }
  bool isDonor(){
    return true;
  }
  /*void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }*/
}
