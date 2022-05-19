import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/modern_pictograms_icons.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/SuggestedArticle.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';

/// The stateful widget which displays the suggest an article screen
class SuggestAnArticle extends StatefulWidget {
  @override
  /// Creates the state containing the functionality and widget tree.
  _SuggestAnArticleState createState() => _SuggestAnArticleState();
}

/// The state created by the widget.
class _SuggestAnArticleState extends State<SuggestAnArticle> {

  /// Setup the controllers used to access the form data
  final nameController = TextEditingController();
  final donorNumberController = TextEditingController();
  final urlController = TextEditingController();
  final commentsController = TextEditingController();

  /// The key that stores the form's state
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {

    /// Retrieve the provider to access the firebase database service
    final databaseProvider = Provider.of<FirebaseDatabaseService>(context);
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Suggest An Article',
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        body:
        ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
              child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/suggestion.jpg'),
                  maxRadius: 40.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0, 15.0),
                    child: Text(
                        'Thank you for taking the time to suggest a new article!\n\n'
                        + 'Please complete and submit the form below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          letterSpacing: 1.0,
                          color: Colors.grey[800],
                        ),
                      ),
                ),


        Padding(
          padding: EdgeInsets.fromLTRB(20,0,20,5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey[500],
                  offset: Offset(0.3, 0.3),
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            ///Full names
            child: Column(
              children: [
                FormBuilder(
                    key: _fbKey,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            controller: nameController,
                            attribute: "name",
                            decoration: InputDecoration(
                                labelText: "Name",
                                icon: Icon(Elusive.adult),
                            ),
                            validators: [
                              FormBuilderValidators.required(
                                errorText: 'Please provide your name.'
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          FormBuilderTextField(
                            controller: donorNumberController,
                            attribute: "donorNumber",
                            decoration: InputDecoration(
                              labelText: "Donor Number",
                              icon: Icon(Iconic.hash),
                            ),
                            keyboardType: TextInputType.number,
                            validators: [
                              FormBuilderValidators.numeric(
                                errorText: 'Please provide a valid donor number.'
                              ),
                              FormBuilderValidators.required(
                                  errorText: 'Please provide a valid donor number.'
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          FormBuilderTextField(
                            attribute: "articleURL",
                            controller: urlController,
                            decoration: InputDecoration(
                              labelText: "Article URL",
                              icon: Icon(ModernPictograms.globe),
                            ),
                            validators: [
                              FormBuilderValidators.url(
                                errorText: 'Please provide a valid URL to the article.'
                              ),
                              FormBuilderValidators.required(
                                  errorText: 'Please provide a valid URL to the article.'
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          FormBuilderTextField(
                            attribute: "comments",
                            controller: commentsController,
                            scrollPadding: EdgeInsets.all(5),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            //expands: true,
                            decoration: InputDecoration(
                                labelText: "Comments",
                              icon: Icon(Iconic.comment_alt2,
                              ),
                            ),
                          ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                          child: ElevatedButton(
                              child: Text("Submit Suggestion"),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(10),
                                minimumSize: Size(double.infinity, 30), // double.infinity is the width and 30 is the height
                              ),
                              onPressed: () async {
                                if(_fbKey.currentState.validate()) {
                                  databaseProvider.pushSuggestedArticle(
                                      SuggestedArticle(url: urlController.text,
                                          comments: commentsController.text,
                                          dateSuggested: (new DateFormat()
                                              .add_yMd()
                                              .format(new DateTime.now())
                                              .toString()),
                                          donorNumber: donorNumberController.text,
                                          suggestedBy: nameController.text));
                                  BotToast.showText(
                                    text: 'Suggestion submitted!',
                                  );
                                  Navigator.pop(context);
                                }
                              }
                          ),
                      ),
                        ],
                      ),

                    )
                ),
              ],
          ),
            )
        )
              ],
              )
      ),
        ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    urlController.dispose();
    commentsController.dispose();
    donorNumberController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
