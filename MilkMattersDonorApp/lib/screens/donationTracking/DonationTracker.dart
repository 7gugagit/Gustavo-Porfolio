import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:milk_matters_donor_app/models/TrackedDonation.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';

///Donation Tracking
/// The stateful widget that displays the Donation Tracker screen.
///
/// This screen allows donors to record donations, view their donation history and graphs,
/// and declare donation drop-offs.
class DonationTracker extends StatefulWidget {
  @override
  /// Create the widget's state
  _DonationTrackerState createState() => _DonationTrackerState();
}

/// The widget's state
class _DonationTrackerState extends State<DonationTracker> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// Setup the provider used to access the local SQL database
    final localDBProvider = Provider.of<LocalDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Donation Tracking',),
          centerTitle: true,
          ),
        //drawer: NavDrawer('Donation Tracker'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8),

            height: 60,
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0,4,0),
                      child:
                          ///Amount of ml donated button
                      ElevatedButton.icon(
                          icon: Icon(FontAwesome5.prescription_bottle, color: Colors.grey[200]),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                  future: localDBProvider.getTotalDonatedAmount(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text(
                                        '0 ml',
                                        style: TextStyle(
                                            color: Colors.grey[200]
                                        ),
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                    else {
                                      return Text(
                                        '${snapshot.data.toString()} ml',
                                        style: TextStyle(
                                            color: Colors.grey[200]
                                        ),
                                      );
                                    }
                                  }
                              ),
                              Text('Donated', style: TextStyle(color: Colors.grey[200]), textAlign: TextAlign.center,),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 2,
                            padding: EdgeInsets.all(5),
                            textStyle: TextStyle(
                              ),
                          ),
                        onPressed: (){
                          Navigator.pushNamed(context, '/donationGraphs', arguments: {'initialTab' : 0});
                        },
                      ),
                    ),
                  ),
                  /// Amount of babies fed button
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 0,0,0),
                      child:
                      ElevatedButton.icon(
                          icon: Icon(FontAwesome5.baby, color: Colors.grey[200]),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                  future: localDBProvider.getTotalDonatedAmount(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text(
                                        '0 ml',
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                    else {
                                      double feeds = double.parse((snapshot.data/50).toStringAsFixed(2));
                                      return Text(
                                        '$feeds days',
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                  }
                              ),
                              Text('of 50ml Feeds',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            elevation: 2,
                            padding: EdgeInsets.all(5),
                            textStyle: TextStyle(
                              //fontSize: constraints.maxWidth*0.85,

                            ),
                          ),
                        onPressed: (){
                          Navigator.pushNamed(context, '/donationGraphs', arguments: {'initialTab' : 1});
                        },
                      ),

                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: localDBProvider.getAllTrackedDonationsRecentFirst(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0)));
                  }
                  else{
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey[500],
                                offset: Offset(0.3, 0.3),
                                blurRadius: 1.5,
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        ///Donations display summary
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Your Donations',
                                style: TextStyle(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  TrackedDonation trackedDonation = snapshot.data[index];
                                  return ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${trackedDonation.amount} ml'),
                                        //Text('${trackedDonation.dateRecorded}'),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${trackedDonation.dateRecorded}'),
                                        trackedDonation.donationProcessed ? Text('Drop-off Complete') : Text('Awaiting Drop-off'),
                                      ],
                                    )
                                  );
                                },
                          ),
                            ),],
                          ),
                      ),
                    );
                  }
                },
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 8),
                  ///Declare a dropoff button
                  child: ElevatedButton.icon(
                      icon: Icon(Icons.announcement, color: Colors.grey[200],),
                      label: Text('Declare Drop-Off'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[200],),
                      ),
                      onPressed: ()async{
                        List<TrackedDonation> unprocessedDonations = await localDBProvider.getAllNotDroppedOffTrackedDonationsRecentFirst();
                        if(unprocessedDonations.isEmpty){
                          BotToast.showText(text: 'You do not have any tracked donations to drop off');
                        } else {
                          unprocessedDonations.forEach((element) {element.donationProcessed=true;});
                          await Navigator.pushNamed(context, '/securityCheckDeclareDropoff', arguments: {
                            'UnprocessedDonations': unprocessedDonations,
                          });
                          setState(() {

                          });
                        }
                      },
                  ),

                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                ///Floating action button to add/record a donation
                child: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white,),
                    //backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      Navigator.pushNamed(context, '/recordADonation');
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
