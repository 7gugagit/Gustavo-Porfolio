import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/DepotCard.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';
import 'package:provider/provider.dart';

/// This stateless widget displays a list of depots
///
/// Each depot is displayed on a card, containing the depot's details as well as
/// a button which navigates back to the depot locator screen and focuses on the specific depot on the map.
class Depots extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// This provider provides the list of depots
    var _depots = Provider.of<List<Depot>>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Depots',
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _depots == null ? Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0))) :
        Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: _depots.length,
            // Provide a builder function.
            itemBuilder: (context, index) {
              final item = _depots[index];
              return DepotCard(
                depot: item,
              );
            },
          ),
        ),
      ),
    );
  }
}
