import 'package:flutter/material.dart';

/// A custom widget to display milk donations recorded through the mobile app.
class DonationTable extends StatefulWidget {



  String depotId;
  String amount;
  String donorNumber;
  String dateDroppedOff;

  /// Constructor
  DonationTable({this.depotId, this.amount, this.donorNumber, this.dateDroppedOff});

  @override
  _DonationTable createState() => _DonationTable();

}

class _DonationTable extends State<DonationTable> {

  _DonationTable();

  String depotId;
  String amount;
  String donorNumber;
  String dateDroppedOff;

Widget build(BuildContext context) {
  return Container();
}
}