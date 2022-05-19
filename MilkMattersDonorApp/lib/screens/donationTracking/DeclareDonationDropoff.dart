import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';
import 'package:milk_matters_donor_app/models/DonationDropoff.dart';
import 'package:milk_matters_donor_app/models/DonorUser.dart';
import 'package:milk_matters_donor_app/models/TrackedDonation.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';

/// A stateful widget which displays the Declare Donation Drop-off screen.
///
/// This allows users to select donations that have been dropped off at a milk depot,
/// as well as selecting the specific depot it was dropped-off at.
class DeclareDonationDropoff extends StatefulWidget {
  @override
  /// Create the widget's state
  _DeclareDonationDropoffState createState() => _DeclareDonationDropoffState();
}

/// The state created by the widget.
class _DeclareDonationDropoffState extends State<DeclareDonationDropoff> {

  /// Map used to store arguments passed from the previous screen
  Map arguementData = {};
  List<TrackedDonation> trackedDonations;
  /// The key used to identify the form's state
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String selectedDepotId;

  @override
  Widget build(BuildContext context) {

    /// Setup providers to the firebase authentication, database services and depot list, as well as the local SQL database
    final localDBProvider = Provider.of<LocalDatabaseService>(context);
    final firebaseDatabaseProvider = Provider.of<FirebaseDatabaseService>(context);
    final authProvider = Provider.of<FirebaseAuthenticationService>(context);
    var _depots = Provider.of<List<Depot>>(context);
    /// Populate the argument data passed to this widget
    arguementData = arguementData.isNotEmpty ? arguementData : ModalRoute.of(context).settings.arguments;
    trackedDonations = arguementData['UnprocessedDonations'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Declare Donation Drop-Off',
          ),
          centerTitle: true,
          //elevation: 1.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: FormBuilder(
                key: _fbKey,
                child: FormBuilderDropdown(
                  onChanged: (value) {
                    selectedDepotId = value;
                  },
                  hint: Text('Drop-Off Depot'),
                  attribute: 'depotDropoff',
                  items: _depots == null ? null : (generateDropdownList(_depots)),
                  validators: [
                    FormBuilderValidators.required(
                        errorText: 'Please select the depot you will be dropping off at.'
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(0.3, 0.3),
                        blurRadius: 1.5,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Donations Awaiting Drop-off',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: trackedDonations.length,
                          itemBuilder: (context, index) {
                            TrackedDonation trackedDonation = trackedDonations[index];
                            return CheckboxListTile(
                              title: Text('${trackedDonation.amount} ml'),
                              subtitle: Text('${trackedDonation.dateRecorded}'),
                              value: trackedDonation.donationProcessed,
                              onChanged: (bool value) async {
                                setState(() {
                                  trackedDonation.donationProcessed = value;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
            Container(
              padding: EdgeInsets.all(18),
              child:
              ElevatedButton.icon(
                /// If the form is validated,
                /// then update the tracked donations that are stored locally and which were dropped off,
                /// and calculate the total dropped-off amount.
                /// Push the donation drop-off data to the firebase database
                icon: Icon(Icons.announcement, color: Colors.grey[200],),
                label: Text('Declare Donation Drop-Off'),
                    style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    textStyle: TextStyle(
                      color: Colors.grey[200],),
                  ),
                onPressed: ()async{
                  if(_fbKey.currentState.validate()) {
                    BotToast.showLoading();
                    int totalDonationAmount = 0;
                    trackedDonations.forEach((element) {
                      localDBProvider.update(element);
                      if(element.donationProcessed == true){
                        totalDonationAmount += element.amount;
                      }
                    });
                    if(selectedDepotId == 'other'){
                      //do nothing. No need to push a depot dropoff
                    } else {
                      String currentUserEmail = authProvider.getCurrentUser().email;
                      DonorUser currentUser = await firebaseDatabaseProvider.getDonorUser(currentUserEmail);
                      DonationDropoff donationDropoff = DonationDropoff(amount: totalDonationAmount.toString(), donorNumber: currentUser.donorNumber,
                          dateDroppedOff: DateFormat("dd/MM/yyyy").format(DateTime.now()), depotId: selectedDepotId, donorEmail: currentUser.email); //);
                      await firebaseDatabaseProvider.pushDonationDropoff(donationDropoff);
                    }
                    BotToast.showSimpleNotification(title: 'Thank you for declaring your donation drop off!');
                    BotToast.closeAllLoading();
                    Navigator.pop(context);
                  }
                },
              ),

            ),
          ],
        ),
      ),
    );
  }

  /// This method generates the dropdown list items from a list of Depots.
  List<DropdownMenuItem> generateDropdownList(List<Depot> depots){

    List<DropdownMenuItem> depotDropdowns = List<DropdownMenuItem>.from(depots.map(
            (depot) => DropdownMenuItem(value: depot.id, child: Text(depot.name))));
    depotDropdowns.add(DropdownMenuItem(value: 'other', child: Text('Other')));
    return depotDropdowns;
    
  }
  
}
