import 'package:flutter/material.dart';

/// A custom widget, designed to display a donor application question as a card
/// with a checkbox to toggle one's answer between true and false.
class QuestionCard extends StatefulWidget {

  /// Contains the question.
  final String question;
  /// Contains the question number.
  final int number;

  /// Constructor
  QuestionCard({this.question, this.number});

  @override
  /// Creates the state containing the functionality for the widget.
  _QuestionCard createState() => _QuestionCard(question: this.question, number: this.number);

}

/// The state created by the widget.
class _QuestionCard extends State<QuestionCard>
{
  ///Constructor
  _QuestionCard({this.question, this.number});

  /// Contains the question.
  String question;
  /// Contains the question number.
  int number;
  /// Contains the current answer to the question. Defaults to false.
  bool answer = false;
  /// Contains the current icon to display to the user, depending on their
  /// answer. Defaults to the "false" icon.
  Icon icon = Icon(Icons.check_box_outline_blank);


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
                title: Text("Question " + number.toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                question,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                textAlign: TextAlign.left,
              ),
            ),
            /**
            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                FlatButton.icon(
                  icon: icon,
                  onPressed: () {
                    if (!answer) {
                      setState(() {answer = true; icon = Icon(Icons.check_box);});
                    }
                    else {
                      setState(() {answer = false; icon = Icon(Icons.check_box_outline_blank);});
                    }
                  },
                  label: Text(answer.toString().toUpperCase()),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}