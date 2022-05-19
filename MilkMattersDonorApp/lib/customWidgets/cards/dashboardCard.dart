import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class DashboardCard extends StatelessWidget {
  final String dashInfo;
  final FontAwesome5 dashIcon;

  DashboardCard({this.dashInfo, this.dashIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(10),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40), // if you need this
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: Colors.grey[300],
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        ///Card
        child: Row(
          children: <Widget> [
            //Icon(dashIcon)
            ///Image
            Text(dashInfo),
          ],
        ),

      ),
    );
  }
}
