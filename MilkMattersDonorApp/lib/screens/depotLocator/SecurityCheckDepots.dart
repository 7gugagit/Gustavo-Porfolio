import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';


/// A stateful widget which displays the depot locator security check
///
/// It ensures that only active donors are able to view the location of depots,
/// by requiring users to input their donor number before proceeding.
class SecurityCheckDepots extends StatefulWidget {
  @override
  /// Create the widget's state
  _SecurityCheckDepotsState createState() => _SecurityCheckDepotsState();
}

/// The widget's state, containing the functionality and widget tree
class _SecurityCheckDepotsState extends State<SecurityCheckDepots> {

  /// Controller used to access inputted data
  final donorNumberController = TextEditingController();
  /// Key used to access the state of the form
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  var invalidDonorNumber = 'Please provide a valid donor number.';


  @override
  Widget build(BuildContext context) {
    /// Providers to access the firebase authentication and database services
    FirebaseDatabaseService _databaseProvider = Provider.of<FirebaseDatabaseService>(context);
    FirebaseAuthenticationService _authProvider = Provider.of<FirebaseAuthenticationService>(context);

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
                  child: Text(
                    'Submit',
                  ),
                  onPressed: () async {
                    if(_fbKey.currentState.validate()){
                      BotToast.showLoading();
                      var result = await _databaseProvider.validateDonorNumber(_authProvider.getCurrentUser().email, donorNumberController.text);
                      BotToast.closeAllLoading();
                      if(result == true){
                        Navigator.pushReplacementNamed(context, '/depotLocator');
                        return;
                      }if(result == false){
                        BotToast.showText(text: 'Donor number incorrect. Please try again.');
                        return;
                      }if(result == null){
                        BotToast.showText(text: 'It looks like you don\'t have a donor number yet.');
                        return;
                      }else{
                        BotToast.showText(text: 'An error occurred, please try again later.');
                        return;
                      }
                    }
                  },
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.all(20),
                child: Text(
                  'The locations of milk depots are sensitive information which is only made available to current donors.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 1.0,
                  ),
                ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
