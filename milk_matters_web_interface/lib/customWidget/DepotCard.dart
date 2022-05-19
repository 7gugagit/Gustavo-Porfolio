import 'package:flutter/material.dart';

/// A custom widget to display depot details.
class DepotCard extends StatefulWidget {



  String name;
  String address;
  String lat;
  String long;
  String contactNumber;
  String comments;

  /// Constructor.
  DepotCard({this.name, this.lat, this.long, this.comments, this.contactNumber, this.address});

  @override
  _DepotCard createState() => _DepotCard(name: this.name, address: this.address, lat: this.lat, long: this.long, contactNumber: this.contactNumber, comments: this.comments);

}

class _DepotCard extends State<DepotCard>
{
  _DepotCard({this.name, this.lat, this.long, this.comments, this.contactNumber, this.address});

  String name;
  String address;
  String lat;
  String long;
  String contactNumber;
  String comments;

  Icon icon = Icon(Icons.check_box_outline_blank);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text(name),
            children: <Widget>[Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(address, style: TextStyle(color: Colors.black.withOpacity(0.6))),
            ),
            ],
          ),
        )

    );
  }
}