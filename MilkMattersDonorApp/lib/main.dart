import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_matters_donor_app/Screens/BottomNav.dart';
import 'package:milk_matters_donor_app/helpers/LocationHelper.dart';
import 'package:milk_matters_donor_app/models/AboutItem.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';
import 'package:milk_matters_donor_app/models/FaqItem.dart';
import 'package:milk_matters_donor_app/screens/BecomeADonor.dart';
import 'package:milk_matters_donor_app/screens/About.dart';
import 'package:milk_matters_donor_app/screens/DonorProcess.dart';
import 'package:milk_matters_donor_app/screens/FAQs.dart';
import 'package:milk_matters_donor_app/screens/PrivacyPolicy.dart';
import 'package:milk_matters_donor_app/screens/depotLocator/Depots.dart';
import 'package:milk_matters_donor_app/models/NewsAndEventsItem.dart';
import 'package:milk_matters_donor_app/screens/NewsAndEvents.dart';
import 'package:milk_matters_donor_app/screens/auth/ForgotPassword.dart';
import 'package:milk_matters_donor_app/screens/auth/Login.dart';
import 'package:milk_matters_donor_app/screens/auth/Register.dart';
import 'package:milk_matters_donor_app/screens/depotLocator/DepotLocator.dart';
import 'package:milk_matters_donor_app/screens/depotLocator/SecurityCheckDepots.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/DeclareDonationDropoff.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/DonationGraphs.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/DonationTracker.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/RecordADonation.dart';
import 'package:milk_matters_donor_app/screens/donationTracking/SecurityCheckDeclareDropoff.dart';
import 'package:milk_matters_donor_app/screens/education/EducationArticles.dart';
import 'package:milk_matters_donor_app/screens/education/EducationCategories.dart';
import 'package:milk_matters_donor_app/screens/education/SuggestAnArticle.dart';
import 'package:milk_matters_donor_app/screens/auth/AuthWrapper.dart';
import 'package:milk_matters_donor_app/services/FirebaseAuthenticationService.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:milk_matters_donor_app/services/LocalDatabaseService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:milk_matters_donor_app/screens/Intro.dart';
import 'package:milk_matters_donor_app/screens/auth/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MilkMattersApp());

}

///The widget that contains the application
class MilkMattersApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    const appName = 'Milk Matters';
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Color.fromRGBO(166, 7, 74, 1)
        )
    );

    return MultiProvider(
      /// The providers below provide data to several screens.
      /// Change notifier providers are used to pass future data to screens on a larger scale: eg, a class which provides multiple futures (FirebaseDatabaseService)
      /// Future providers provide futures of a specific type directly, for example, the list of depots obtained from FirebaseDatabaseService().getDepots()
      /// Stream providers act as normal providers, but provider a stream of data, for example, streaming the auth status of a user (nouser->user->nouser->..)
      providers: [
        ChangeNotifierProvider<FirebaseDatabaseService>(create: (_) => FirebaseDatabaseService(),),
        ChangeNotifierProvider<FirebaseAuthenticationService>(create: (_) => FirebaseAuthenticationService(),),
        ChangeNotifierProvider<LocalDatabaseService>(create: (_) => LocalDatabaseService(),),
        FutureProvider<List<NewsAndEventsItem>>(create: (_) => FirebaseDatabaseService().getNewsAndEvents(),),
        FutureProvider<List<AboutItem>>(create: (_) => FirebaseDatabaseService().getAbout(),),
        FutureProvider<List<FaqItem>>(create: (_) => FirebaseDatabaseService().getFAQS(),),
        //FutureProvider<List<About>>(create: (_) => FirebaseDatabaseService().getAbout(),),
        FutureProvider<List<Depot>>(create: (_) => FirebaseDatabaseService().getDepots(),),
        FutureProvider<bool>(create: (_) => LocationHelper().requestLocationPermissions(),),
        StreamProvider<User>.value(value: FirebaseAuthenticationService().user,),
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Color.fromRGBO(220, 9, 99, 1),
          accentColor: Color.fromRGBO(0,176,240,1),
          backgroundColor: Color.fromRGBO(253, 220, 216, 1),

          scaffoldBackgroundColor: Color.fromRGBO(254,239,236,1),
          //AppBar Theme
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromRGBO(220, 9, 99, 1),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white),
          ),

          // Define the default font family.
          fontFamily: 'San Francisco',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            headline5: TextStyle(fontSize: 16.5, letterSpacing: 0.4, fontWeight: FontWeight.w500),
            button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, letterSpacing: 0.2),
            bodyText1: TextStyle(fontSize: 15.0),
            bodyText2: TextStyle(fontSize: 15.0), //article description style

          ),
        ),
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),

        navigatorObservers: [BotToastNavigatorObserver(), FirebaseAnalyticsObserver(analytics: analytics),], ///added firebase analytics - user tracking
        routes: {
          /// Below are the routes that the app has and which widget will be returned for that route.
          /// a single route can be seen as a screen that can be navigated to

          '/': (context) => Wrapper(),
          '/Intro': (context) => Intro(),
          '/privacyInfo': (context) => PrivacyPolicy(),
          '/welcome': (context) => WelcomeScreen(),
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/forgotPassword': (context) => ForgotPassword(),
          '/home': (context) => Home(),
          '/educationCategories': (context) => EducationCategories(),
          '/newsAndEvents': (context) => NewsAndEvents(),
          '/educationArticles': (context) => EducationArticles(),
          '/suggestAnArticle': (context) => SuggestAnArticle(),
          '/depotLocator': (context) => DepotLocator(),
          '/depots': (context) => Depots(),
          '/securityCheckDepots': (context) => SecurityCheckDepots(),
          '/donationTracker': (context) => DonationTracker(),
          '/donationGraphs': (context) => DonationGraphs(),
          '/recordADonation': (context) => RecordADonation(),
          '/declareDonationDropoff': (context) => DeclareDonationDropoff(),
          '/securityCheckDeclareDropoff': (context) => SecurityCheckDeclareDropoff(),
          '/aboutMilkMatters': (context) => About(),
          '/faqs': (context) => FAQs(),
          '/becomeADonor': (context) => BecomeADonor(),
          '/donorProcess': (context) => DonorProcess(),

        },
      ),
    );
  }
}


