import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/FeedsGraph.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/DonationAmountGraph.dart';

/// The stateful widget which contains the donation graphs
///
/// Displays both graphs to the user and allow them to switch between them using a tab
class DonationGraphs extends StatefulWidget {
  @override
  /// Create the widget's state
  _DonationGraphsState createState() => _DonationGraphsState();
}

/// The widget's state
class _DonationGraphsState extends State<DonationGraphs> {

  /// Store the argument defining which graph tab should be shown
  Map arguementData = {};
  int initialTab;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// Retrieve the argument data and set the initialTab value.
    arguementData = arguementData.isNotEmpty ? arguementData : ModalRoute.of(context).settings.arguments;
    initialTab = arguementData['initialTab'];
    var icon_color = Colors.white;


    return SafeArea(
      child: DefaultTabController(
        initialIndex: initialTab,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Donation Graphs',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              physics: NeverScrollableScrollPhysics(),
              tabs: [
                Tab(icon: Icon(FontAwesome5.prescription_bottle, color: icon_color), child: Text('Donations',style: TextStyle(color: icon_color),) ),
                Tab(icon: Icon(FontAwesome5.baby, color: icon_color,), child: Text('50 ml Feeds',style: TextStyle(color: icon_color),)),
              ],
            ),
          ),
          body: Container(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                DonationAmountGraph(),
                FeedsGraph(),
            ],
          ),
        ),
      ),
    ),
    );
  }
}