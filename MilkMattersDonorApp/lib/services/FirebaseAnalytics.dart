import 'package:firebase_analytics/firebase_analytics.dart';

/// log events
class Analytics {
  void logEvent(String event){
    // if (user.consents()) {
    FirebaseAnalytics().logEvent(name: event);
    //}
  }
}
