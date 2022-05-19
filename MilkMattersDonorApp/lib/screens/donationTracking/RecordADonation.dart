import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/TrackedDonation.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';


/// A stateless widget allowing donors to record a donation
class RecordADonation extends StatelessWidget {

  /// The key used to store the form state
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  /// Initialise controllers used to retrieve form input data
  final donationAmountController = TextEditingController();
  final donationDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    /// Setup the provider to access the local SQL database
    final localDBProvider = Provider.of<LocalDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        //backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
          'Record A Donation',
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body:
    Padding(
      padding: EdgeInsets.all(20),
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

        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: FormBuilder(
                  key: _fbKey,
                  child: Column(
                    children: [
                      ///donation amount
                      FormBuilderTextField(
                        attribute: 'donationAmount',
                        controller: donationAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Donation Amount (ml)",
                          icon: Icon(FontAwesome5.prescription_bottle),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Please enter a donation amount.'
                          ),
                          FormBuilderValidators.numeric(
                              errorText: 'Please enter a valid number.'
                          ),
                        ],
                      ),
                      ///date
                      FormBuilderDateTimePicker(
                        attribute: 'donationDate',
                        controller: donationDateController,
                        inputType: InputType.date,
                        format: DateFormat("dd/MM/yyyy"),
                        //format: DateFormat('EEEE, d MMM ''yyyy'),
                        initialDate: DateTime.now(),
                        initialValue: DateTime.now(),
                        decoration: InputDecoration(
                          labelText: "Donation Date",
                          icon: Icon(FontAwesome5.calendar_day),
                        ),
                        validators: [
                          FormBuilderValidators.required(
                              errorText: 'Please provide a donation date.'
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              ///record donation button
              ElevatedButton.icon(
                  label: Text("Record Donation"),
                  icon: Icon(
                    Icons.playlist_add,
                    color: Colors.grey[200],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[200],),
                  ),
                onPressed: () async {
                  if(_fbKey.currentState.validate()) {
                    BotToast.showLoading();
                    TrackedDonation donation = TrackedDonation.withoutId(
                        amount: int.parse(donationAmountController.text),
                        dateRecorded: donationDateController.text, donationProcessed: false);
                    await localDBProvider.insert(donation);
                    BotToast.closeAllLoading();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
    ),
    ),
      ),
    );
  }
}
