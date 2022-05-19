import 'package:flutter/material.dart';

/// A custom widget, designed to display intros as a card
/// with picture and description
class IntroCard extends StatefulWidget {

  /// Contains the description.
  final String description;
  /// Contains the image.
  final int image;

  /// Constructor
  IntroCard({this.description, this.image});

  @override
  /// Creates the state containing the functionality for the widget.
  _IntroCard createState() => _IntroCard(description: this.description, image: this.image);

}

/// The state created by the widget.
class _IntroCard extends State<IntroCard>
{
  ///Constructor
  _IntroCard({this.description, this.image});

  /// Contains the description.
  String description;
  /// Contains the image.
  int image;


  @override
  /// Builds the widget, using the provided BuildContext.
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListTile(
                //leading: Icon(Icons.add),
                //leading: imageFromBase64String(eduArticle.image),
                leading: Image.asset('assets/milk_matters_logo_login.png'),
                title: Text("Question " + image.toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                description,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}