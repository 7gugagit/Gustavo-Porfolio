import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/models/AboutItem.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';
import 'package:milk_matters_donor_app/models/DonationDropoff.dart';
import 'package:milk_matters_donor_app/models/EducationArticle.dart';
import 'package:milk_matters_donor_app/models/FaqItem.dart';
import 'package:milk_matters_donor_app/models/NewsAndEventsItem.dart';
import 'package:milk_matters_donor_app/models/SuggestedArticle.dart';
import 'package:milk_matters_donor_app/models/DonorUser.dart';

/// FirebaseDatabaseService
///   This class provides the access and management tools for the app's Firebase Realtime Database.
///  It heavily leverages the FirebaseDatabase class for certain functions:
///    - reading
///    - deleting
///    - updating
///    - inserting
///
///  The pattern for these methods is rather repetitive.
///  We begin by creating a reference to the location in the db we wish to access
///  we then retrieve that reference using .once()
///  we then use .then() as a callback which will be triggered
///  once the db has returned the data to us (either from local cache or the cloud)
///  Finally, we process the data and return it as an object (which is wrapped in a Future!)
///
///  We also need to handle errors that may occur
class FirebaseDatabaseService extends ChangeNotifier{

  FirebaseDatabase database = FirebaseDatabase.instance;

  /// when this object is instantiated then configure the following offline parameters
  /// enable persistence - the database can now be cached locally and still utilised as if it were online
  /// set the size of the cache to 10 mb
  FirebaseDatabaseService() {
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  /// Retrieve a donor user by their email address
  Future getDonorUser(String email){
    String subbedEmail = email.replaceAll('.', ',');
    DatabaseReference donorsRef = FirebaseDatabase.instance.reference().child(
        'Users/Nonstaff/$subbedEmail');
    return donorsRef.once().then((DataSnapshot snapshot) {
      DonorUser user = DonorUser(
        email: email,
        fullName: snapshot.value['fullName'],
        phoneNumber: snapshot.value['phoneNumber'],
        donorNumber: snapshot.value['donorNumber'],
      );
      return user;
    }).catchError((e){
      print(e);
      return null;
    });
  }


  /// write a new donor user to the database using the provided data
  Future pushNewDonorUser(String email, String fullName, String phoneNumber) async {

    String subbedEmail = email.replaceAll('.', ',');
    Map donorDetails = Map<String, String>();
    donorDetails['fullName'] = fullName;
    donorDetails['phoneNumber'] = phoneNumber;
    donorDetails['donorNumber'] = '0';

    await setNewUserDonorStatus(email);

    DatabaseReference donorsRef = FirebaseDatabase.instance.reference().child(
        'Users/Nonstaff/$subbedEmail');
    return donorsRef.set(donorDetails).then((value) => null).catchError((error) => error);
  }

  /// Add a validated donor number to a particular user account.
  /// This stores their validated donor number within their account details
  Future<dynamic> addValidatedDonorNumber(String email, String donorNumber){

    String subbedEmail = email.replaceAll('.', ',');
    DatabaseReference dbUserRef = FirebaseDatabase.instance.reference().child(
        'Users/Nonstaff/$subbedEmail');
    return dbUserRef.update({'donorNumber': donorNumber});

  }

  /// Determines whether a newly registered user is already an active donor,
  /// If so then add the donor number to their user account data
  Future<dynamic> setNewUserDonorStatus(String email){
    String subbedEmail = email.replaceAll('.', ',');
    DatabaseReference donorNumbersRef = FirebaseDatabase.instance.reference().child(
        'DonorNumbers/$subbedEmail');
    return donorNumbersRef.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      if (values != null) {
        if (values['donorNumber'] != null) {
          addValidatedDonorNumber(email, values['donorNumber']);
          return null;
        }
        return false;
      }
    }).catchError((error) {return error;});

  }

  Future<dynamic> getDonorStatus(String email) {
    String subbedEmail = email.replaceAll('.', ',');
    DatabaseReference donorNumbersRef = FirebaseDatabase.instance.reference().child(
        'DonorNumbers/$subbedEmail');
    return donorNumbersRef.once().then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      if (values != null) {
        if (values['donorNumber'] != null) {
          addValidatedDonorNumber(email, values['donorNumber']);
          return null;
        }
        return false;
      }
    }).catchError((error) {return error;});
  }

    /// Validate whether a donor number exists for a particular account (email address)
  Future<dynamic> validateDonorNumber(String email, String donorNumber){
    String subbedEmail = email.replaceAll('.', ',');
    DatabaseReference donorNumbersRef = FirebaseDatabase.instance.reference().child(
        'DonorNumbers/$subbedEmail');
    return donorNumbersRef.once().then((DataSnapshot dataSnapshot) {
      bool outcome;
      Map<dynamic, dynamic> values = dataSnapshot.value;
      if(values==null){
        return null;
      }

      if(donorNumber == values['donorNumber']){
        outcome = true;
        addValidatedDonorNumber(email, donorNumber);
      } else{
        outcome = false;
      }
      return outcome;
    }).catchError((error) {return false;});
  }

  /// Write a suggested article to the firebase database
  Future<dynamic> pushSuggestedArticle(SuggestedArticle suggestedArticle){
    DatabaseReference dbArticlesCategoriesRef = FirebaseDatabase.instance.reference().child(
        'SuggestedArticles');
    return dbArticlesCategoriesRef.push().set(suggestedArticle.toMap()).then((value) => null).catchError((error) => error);

  }

  /// Read all of the articles from the database and return a map
  /// containing the category and the respective list of articles
  Future<Map<String, List<EducationArticle>>> getAllArticles() async {

    DatabaseReference dbArticlesRef = FirebaseDatabase.instance.reference().child(
        'Articles');
    await dbArticlesRef.keepSynced(true);
    Map<String, List<EducationArticle>> articlesByCategoryMap = Map();
    List<EducationArticle> articleList = <EducationArticle>[];

    dbArticlesRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> categories = snapshot.value;
      categories.forEach((key, value) {
        value.forEach((key, value) {
          articleList.add(EducationArticle.fromMap(value));
        });
        articleList.sort((a,b) => a.compareTo(b));
        articlesByCategoryMap[key] = articleList;
        articleList.clear();
        });
      });
      return articlesByCategoryMap;
  }

  /// Retrieve the news and events items from the database
  Future<List<NewsAndEventsItem>> getNewsAndEvents() async {
    DatabaseReference newsAndEventsRef = FirebaseDatabase.instance.reference().child(
        'NewsAndEvents');
    await newsAndEventsRef.keepSynced(true);
    List<NewsAndEventsItem> newsAndEventsList = <NewsAndEventsItem>[];

    return newsAndEventsRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> items = snapshot.value;
      items.forEach((key, value) {
        newsAndEventsList.add(NewsAndEventsItem.fromMap(value));
      });
      newsAndEventsList.sort((a,b) => a.compareTo(b));
      return newsAndEventsList;
    }).catchError((error) => error);
  }

  /// Retrieve the FAQ items from the database
  Future<List<FaqItem>> getFAQS() async {
    DatabaseReference faqsRef = FirebaseDatabase.instance.reference().child('FAQs');
    await faqsRef.keepSynced(true);
    List<FaqItem> faqsList = <FaqItem>[];

    return faqsRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> items = snapshot.value;
      items.forEach((key, value) {
        faqsList.add(FaqItem.fromMap(value));
      });
      return faqsList;
    }).catchError((error) => error);
  }

  /// Retrieve about us
  Future getAbout() async {
    DatabaseReference aboutRef = FirebaseDatabase.instance.reference().child('AboutUs');
    await aboutRef.keepSynced(true);
    List<AboutItem> aboutList = <AboutItem>[];

    return aboutRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> items = snapshot.value;
      items.forEach((key, value) {
        aboutList.add(AboutItem.fromMap(value));
      });
      return aboutList;
    }).catchError((error) => error);
  }
  /// Retrieve the articles of a particular category from the database
  Future<List<EducationArticle>> getArticles(String category) async {
    DatabaseReference categoryRef = FirebaseDatabase.instance.reference().child(
        'Articles/$category');
    return categoryRef.once().then((DataSnapshot snapshot) {
      List<EducationArticle> articles = <EducationArticle>[];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        articles.add(EducationArticle.fromMap(value));
      });
      articles.sort((a,b) => a.compareTo(b));
      return articles;
    }).catchError((error) => error);
  }

  /// Retrieve the list of depots from the database
  Future<List<Depot>> getDepots() async {
    DatabaseReference depotsRef = FirebaseDatabase.instance.reference().child(
        'Depots');
    await depotsRef.keepSynced(true);

    return depotsRef.once().then((DataSnapshot snapshot) async {
      List<Depot> depots = <Depot>[];
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        depots.add(Depot.fromMap(key, value));
      });
      return depots;
      }).catchError((error) => error);
  }

  /// Write a donation dropoff to the database
  Future<dynamic> pushDonationDropoff(DonationDropoff donationDropoff){

    DatabaseReference dbDepotsRef = FirebaseDatabase.instance.reference().child(
        'DonationDropoffs');
    return dbDepotsRef.push().set(donationDropoff.toMap()).then((value) => null).catchError((error) => error);

  }

}