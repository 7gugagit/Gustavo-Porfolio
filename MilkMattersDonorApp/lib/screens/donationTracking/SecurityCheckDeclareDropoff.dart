import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:milk_matters_donor_app/models/TrackedDonation.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';

/// A stateful widget which displays the depot locator security check
///
/// It ensures that only active donors are able to declare donation drop-offs.
class SecurityCheckDeclareDropoff extends StatefulWidget {
  @override
  /// Create the widget's state
  _SecurityCheckDeclareDropoffState createState() => _SecurityCheckDeclareDropoffState();
}

/// The widget's state, containing the functionality and widget tree
class _SecurityCheckDeclareDropoffState extends State<SecurityCheckDeclareDropoff> {

  /// Key used to access the state of the form
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  /// Controller used to access inputted data
  final donorNumberController = TextEditingController();
  /// The map and variable used to store arguments passed from the previous widget
  Map arguementData = {};
  List<TrackedDonation> trackedDonations;
  var invalidDonorNumber = 'Please provide a valid donor number.';


  @override
  Widget build(BuildContext context) {
    /// Providers to access the firebase authentication and database services
    FirebaseDatabaseService _databaseProvider = Provider.of<FirebaseDatabaseService>(context);
    FirebaseAuthenticationService _authProvider = Provider.of<FirebaseAuthenticationService>(context);
    /// Retrieve any argument data passed to this widget
    arguementData = arguementData.isNotEmpty ? arguementData : ModalRoute.of(context).settings.arguments;
    trackedDonations = arguementData['UnprocessedDonations'];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Security Check',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Please submit your donor number.'),
                Padding(
                  padding: const EdgeInsets.all(50),
                  child: FormBuilder(
                    key: _fbKey,
                    child: FormBuilderTextField(
                      controller: donorNumberController,
                      attribute: "donorNumber",
                      decoration: InputDecoration(
                        labelText: "Donor Number",
                        icon: Icon(Icons.lock_outline),
                      ),
                      validators: [
                        FormBuilderValidators.required(
                          errorText: invalidDonorNumber
                        ),
                        FormBuilderValidators.numeric(
                          errorText: invalidDonorNumber
                        ),
                        FormBuilderValidators.minLength(
                          4,
                          errorText: invalidDonorNumber
                        ),
                      ],
                    ),
                  ),
                ),

                ElevatedButton(
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[200],),
                    ),
                  onPressed: () async {
                    if(_fbKey.currentState.validate()){
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      BotToast.showLoading();
                      var result = await _databaseProvider.validateDonorNumber(_authProvider.getCurrentUser().email, donorNumberController.text);
                      BotToast.closeAllLoading();
                      if(result == true){

                        await Navigator.pushNamed(context, '/declareDonationDropoff', arguments: {
                          'UnprocessedDonations': trackedDonations,
                        });
                        Navigator.pop(context);
                        return;
                      }if(result == false){
                        BotToast.showText(text: 'Donor number incorrect. Please try again.');
                        return;
                      }if(result == null){
                        showDialog(context: context,
                            builder: (BuildContext context) => CupertinoAlertDialog(
                              title: Text("Error"),
                              content: Text("It looks like you don\'t have a donor number yet."),
                              actions: [
                                CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
                                    onPressed: ()async{
                                      return;
                                    }
                                ),
                              ],
                            )
                        );
                      }else{
                        BotToast.showText(text: 'An error occurred, please try again later.');
                        return;
                      }
                    }
                  },
                ),

                SizedBox(height: 20,),
                Text(
                  'Only current donors are able to declare donation drop-offs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
