import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';


/// The animated depot detail component
///
/// This is the animated 'pill' which displays the details of a depot
/// when its pin is pressed on the Depot Locator Map.
///
/// It displays the details of the depot: Its name, contact details,
/// address, and any comments
class MapPinPillComponent extends StatefulWidget {

  /// The height of the pill on the screen (i.e. whether it is hidden / below the bottom of its parent widget)
  double pinPillPosition;
  /// The depot whose details are displayed
  Depot currentlySelectedDepot;

  MapPinPillComponent({ this.pinPillPosition, this.currentlySelectedDepot});

  /// Creates the state containing the functionality for the widget.
  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

/// The state created by the widget.
class MapPinPillComponentState extends State<MapPinPillComponent> {

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.63,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 2, offset: Offset.zero, color: Theme.of(context).accentColor)
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 8,14,8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.currentlySelectedDepot.name, style: TextStyle(fontSize: 16),),
                        Text(widget.currentlySelectedDepot.address, style: TextStyle(fontSize: 12)),
                        Text(widget.currentlySelectedDepot.contactNumber, style: TextStyle(fontSize: 12)),
                        Text(widget.currentlySelectedDepot.comments, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
