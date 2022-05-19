import 'dart:ui';
import 'package:milk_matters_donor_app/models/FaqItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// A card which displays the detail of a [FaqItem].
///
/// It displays:
/// The item's image (defaults to the MM logo)
/// The title
/// The date it was added
/// Its URL
/// Within an ExpandedTile(
///   Firebase description
/// )
/// It also includes a share button to share the content.
class FAQsCard extends StatelessWidget {

  /// The news and events item that will be displayed on this card
  final FaqItem faqItem;
  FAQsCard({this.faqItem});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(0.5),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            title: Text(faqItem.question),
            children: <Widget>[Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(faqItem.answer, style: TextStyle(color: Colors.black.withOpacity(0.6))),
            ),
            ],
          ),
        )

    );
  }
}
