import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/SuggestedArticle.dart';
import 'package:milk_matters_interface/screens/AccountManagement.dart';
import 'package:milk_matters_interface/screens/CreateStaffAccount.dart';
import 'package:milk_matters_interface/screens/Dashboard.dart';
import 'package:milk_matters_interface/screens/DeleteDonorNumber.dart';
import 'package:milk_matters_interface/screens/Login.dart';
import 'package:milk_matters_interface/screens/Articles.dart';
import 'package:milk_matters_interface/screens/Home.dart';
import 'package:milk_matters_interface/screens/NewArticle.dart';
import 'package:milk_matters_interface/screens/NewNewsAndEventsItem.dart';
import 'package:milk_matters_interface/screens/NewSuggestedArticles.dart';
import 'package:milk_matters_interface/screens/NewsAndEvents.dart';
import 'package:milk_matters_interface/screens/RegisterDonorNumber.dart';
import 'package:milk_matters_interface/screens/ResetStaffPassword.dart';
import 'package:milk_matters_interface/screens/SuggestedArticles.dart';
import 'package:milk_matters_interface/services/DatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:milk_matters_interface/screens/Depots.dart';
import 'package:milk_matters_interface/screens/NewDepot.dart';

void main() {
  runApp(MultiProvider(
    providers: [
   // Provider(
      //Provider( create: (_) => AuthenticationService()),
      //StreamProvider(create: (context) => context.read<AuthenticationService>().onAuthStateChanged),
      //ChangeNotifierProvider<AuthenticationService>(create: (_) => AuthenticationService()),
      ChangeNotifierProvider<DatabaseService>(create: (_) => DatabaseService()),//create: (_) => DatabaseService()
    ],
    child: MaterialApp(
        routes: {
          '/': (context) => Login(),
          '/home': (context) => Home(),
          '/dash': (context) => Dashboard(),
          '/articles': (context) =>  Articles(),
          '/newArticle': (context) => NewArticle(),
          '/suggestedArticles': (context) => SuggestedArticles(),
          '/newSuggestedArticles': (context) => NewSuggestedArticle(),
          '/newsAndEvents': (context) => NewsAndEvents(),
          '/newNewsAndEventsItem': (context) => NewNewsAndEventsItem(),
          '/accountManagement': (context) => AccountManagement(),
          '/registerDonorNumber': (context) => RegisterDonorNumber(),
          '/deleteDonorNumber': (context) => DeleteDonorNumber(),
          '/createStaffAccount': (context) => CreateStaffAccount(),
          '/resetStaffPassword': (context) => ResetStaffPassword(),
          '/depots': (context) => Depots(),
          '/newDepots': (context) => NewDepot(),
        }
    ),),);
}
