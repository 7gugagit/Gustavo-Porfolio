import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/QuestionCard.dart';

/// The page allowing one to begin the application process to become a donor,
/// implemented as a StatefulWidget.
class BecomeADonor extends StatefulWidget {
  @override
  /// Creates the state containing the functionality for the page.
  _BecomeADonor createState() => _BecomeADonor();
}


/// The state created by the page.
class _BecomeADonor extends State<BecomeADonor> {

  /// Displays question 1.
  QuestionCard question1 = QuestionCard(question: "Do you live in the greater Cape Town area or nearby?", number: 1);
  /// Stores answer to question 1.
  bool answer1 = false;
  /// Stores display icon for question 1, depending on the current answer. (Depreciated)
  Icon icon1 = Icon(Icons.check_box_outline_blank);

  /// Displays question 2.
  QuestionCard question2 = QuestionCard(question: "For the safety of the recipient babies, all potential donor mothers need to be screened via a simple but thorough screening process. As part of the screening, are you willing to complete a screening questionnaire?", number: 2);
  /// Stores answer to question 2.
  bool answer2 = false;
  /// Stores display icon for question 2, depending on the current answer. (Depreciated)
  Icon icon2 = Icon(Icons.check_box_outline_blank);

  /// Displays question 3.
  QuestionCard question3 = QuestionCard(question: "Are you willing to have a blood test done, at no cost to you, as part of the screening process?", number: 3);
  /// Stores answer to question 3.
  bool answer3 = false;
  /// Stores display icon for question 3, depending on the current answer. (Depreciated)
  Icon icon3 = Icon(Icons.check_box_outline_blank);

  /// Displays question 4.
  QuestionCard question4 = QuestionCard(question: "Milk Matters has depots in various areas to make breast milk donation easier and more convenient for donor mothers. Are you able to collect sterile containers for freezing your milk donations in and / or drop off batches of frozen breast milk at a Milk Matters depot?", number: 4);
  /// Stores answer to question 4.
  bool answer4 = false;
  /// Stores display icon for question 4, depending on the current answer. (Depreciated)
  Icon icon4 = Icon(Icons.check_box_outline_blank);

  /// Displays question 5.
  QuestionCard question5 = QuestionCard(question: "Donor breast milk needs to be frozen within 24 hours of expressing and kept in the fridge until it is frozen.  Are you able to refrigerate and then freeze your breast milk at home?", number: 5);
  /// Stores answer to question 5.
  bool answer5 = false;
  /// Stores display icon for question 5, depending on the current answer. (Depreciated)
  Icon icon5 = Icon(Icons.check_box_outline_blank);

  /// Displays question 6.
  QuestionCard question6 = QuestionCard(question: "Are you aware that only breast milk that is in excess of your own baby’s needs should be donated?", number: 6);
  /// Stores answer to question 6.
  bool answer6 = false;
  /// Stores display icon for question 6, depending on the current answer. (Depreciated)
  Icon icon6 = Icon(Icons.check_box_outline_blank);

  /// Displays question 7.
  QuestionCard question7 = QuestionCard(question: "Do you understand that the breast milk you donate is pasteurised and microbiologically tested before being dispensed on a prescription basis to qualifying premature babies in state and private neonatal ICUs?", number: 7);
  /// Stores answer to question 7.
  bool answer7 = false;
  /// Stores display icon for question 7, depending on the current answer. (Depreciated)
  Icon icon7 = Icon(Icons.check_box_outline_blank);

  /// Displays question 8.
  QuestionCard question8 = QuestionCard(question: "All newborns are particularly susceptible to drugs in their first six weeks of life and premature babies even more so as their systems are still very immature. It is also important that they are not exposed to anything via the donated breast milk that they are not able to digest or metabolize.  Screening our donors is therefore very important. Are you on any medication, supplements or herbal remedies? ", number: 8);
  /// Stores answer to question 7.
  bool answer8 = false;
  /// Stores display icon for question 8, depending on the current answer. (Depreciated)
  Icon icon8 = Icon(Icons.check_box_outline_blank);

  /// Displays question 9.
  QuestionCard question9 = QuestionCard(question: "To keep the donor breast milk as safe as possible and to avoid the risk of the recipient babies being exposed to harmful chemicals such as nicotine, we need to ask you whether you smoke, use any tobacco products, a nicotine patch, or an e-cigarette?", number: 9);
  /// Stores answer to question 7.
  bool answer9 = false;
  /// Stores display icon for question 7, depending on the current answer. (Depreciated)
  Icon icon9 = Icon(Icons.check_box_outline_blank);

  @override
  /// Builds the page, using the provided BuildContext.
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Pre-screening',
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              centerTitle: true,
              elevation: 1.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Thank you for your interest in becoming a Milk Matters Donor!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            letterSpacing: 1.0,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),

                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'The questions below aim to determine your eligibility as a donor and provide some insight into the Milk Matters donation process.\n\n'
                              'Once you complete the questions you can send a generated email containing your answers to Milk Matters by pressing the \'Email Application\' button.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 0.5,
                                color: Colors.grey[800],
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column (
                        children: [
                          question1,
                          ListTile(
                            title: const Text("Yes"),
                            leading: Radio(
                              value: true,
                              groupValue: answer1,
                              onChanged: (bool choice) {
                                setState(() {
                                  answer1 = choice;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text("No"),
                            leading: Radio(
                              value: false,
                              groupValue: answer1,
                              onChanged: (bool choice) {
                                setState(() {
                                  answer1 = choice;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question2,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer2,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer2 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer2,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer2 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question3,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer3,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer3 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer3,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer3 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question4,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer4,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer4 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer4,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer4 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question5,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer5,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer5 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer5,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer5 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question6,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer6,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer6 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer6,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer6 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question7,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer7,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer7 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer7,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer7 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question8,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer8,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer8 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer8,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer8 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column (
                          children: [
                            question9,
                            ListTile(
                              title: const Text("Yes"),
                              leading: Radio(
                                value: true,
                                groupValue: answer9,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer9 = choice;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text("No"),
                              leading: Radio(
                                value: false,
                                groupValue: answer9,
                                onChanged: (bool choice) {
                                  setState(() {
                                    answer9 = choice;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ),
                    Container (
                      margin: EdgeInsets.all(20),
                          child:
                          ElevatedButton(
                              child: Text("Email Application"),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[200],),
                              ),


                            ///TODO: Add full name to email
                            onPressed: () async {
                              showDialog(context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                        title: Text("Email application"),
                                        content: Text(
                                            "Please proceed to email your response to Milk Matters.\nWe will get in touch with you as soon as possible on the way forward"),
                                        actions: [
                                          CupertinoDialogAction(

                                              isDefaultAction: true,
                                              child: Text('Send Email',
                                                  style: TextStyle(color: Theme
                                                      .of(context)
                                                      .primaryColor)),
                                              onPressed: () async {
                              final Email email = Email(

                              //Need to check how to access answer boolean, currently returns null.
                              body: 'This is an automated email generated by the '
                              'Milk Matters mobile app. '
                              + ', ' +
                              'a potential donor '
                              'has filled in the questionnaire, and has agreed'
                              ' to send their responses to Milk Matters. '
                              'Below are their responses:'
                              '\n\n Question 1: '  +question1.question + '\nAnswer: ' + answer1.toString().toUpperCase() +
                              '\n\n Question 2: '  +question2.question + '\nAnswer: ' + answer2.toString().toUpperCase() +
                              '\n\n Question 3: '  +question3.question + '\nAnswer: ' + answer3.toString().toUpperCase() +
                              '\n\n Question 4: '  +question4.question + '\nAnswer: ' + answer4.toString().toUpperCase() +
                              '\n\n Question 5: '  +question5.question + '\nAnswer: ' + answer5.toString().toUpperCase() +
                              '\n\n Question 6: '  +question6.question + '\nAnswer: ' + answer6.toString().toUpperCase() +
                              '\n\n Question 7: '  +question7.question + '\nAnswer: ' + answer7.toString().toUpperCase() +
                              '\n\n Question 8: '  +question8.question + '\nAnswer: ' + answer8.toString().toUpperCase() +
                              '\n\n Question 9: '  +question9.question + '\nAnswer: ' + answer9.toString().toUpperCase(),


                              subject: 'Milk Matters App: Donor Application',
                              recipients: ['info@milkmatters.org'],
                              isHTML: false,
                              );

                              await FlutterEmailSender.send(email);
                              Navigator.pushReplacementNamed(context, '/home');
                              },
                                          ),
                                        ],
                                      )
                              );
                            }
                          ),
                        )
                  ],
                )
            )
        )
      );
  }

    Future<String> getUsername() async {
      final ref = FirebaseDatabase.instance.reference();
      User cuser = await FirebaseAuth.instance.currentUser;

      return ref.child('User_data').child(cuser.uid).once().then((DataSnapshot snap) {
        final String userName = snap.value['name'].toString();
        print(userName);
        return userName;
      });

  }
}