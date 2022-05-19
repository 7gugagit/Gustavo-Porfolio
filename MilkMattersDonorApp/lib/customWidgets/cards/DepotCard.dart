import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';

/// A card which displays the detail of [Depot].
///
/// It displays the depots details:
/// The name
/// The contact number
/// The address
/// Any comments/instructions for that specific depot
/// A button which takes the user back to the Google Map and focuses on the selected location
class DepotCard extends StatelessWidget {

  final Depot depot;

  DepotCard({this.depot});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              title: Text(depot.name),
              subtitle: Text(
                depot.contactNumber,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                depot.address,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                depot.comments,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child:
              ElevatedButton.icon(
                icon: Icon(Icons.location_searching),
                label: Text('Take me there!'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    //primary: HexColor('#fddcd8'),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[200],),
                  ),
                onPressed: (){
                  Navigator.pop(context, depot);
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
