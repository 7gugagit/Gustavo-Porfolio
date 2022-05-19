import 'dart:html';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_interface/models/Depot.dart';
import 'package:milk_matters_interface/models/EducationArticle.dart';
import 'package:milk_matters_interface/models/NewDonorNumber.dart';
import 'package:milk_matters_interface/models/NewsOrEventItem.dart';
import 'package:milk_matters_interface/models/StaffAccount.dart';
import 'package:milk_matters_interface/models/SuggestedArticle.dart';

/// This is a service provider class. It serves as the link between the screens and
/// the database (Firebase). Provides CRUD functionality.

class DatabaseService extends ChangeNotifier {
  Database db;
  String JennyPassword = "123456";
//johnnytest@test.com
// 123456

  /// Initializes the information needed to access the real time database in Firebase
  DatabaseService() {
    //this is the information needed to access the Real time database in Firebase

    this.db = database();
  }

  /// Uses future and async to sign in an user and wait for the sign in to be successful
  Future<UserCredential> signInUser(String email, String password) async {
    try {
      var login = auth()
          .signInWithEmailAndPassword(email, password)
          .catchError((object) => debugPrint(object.toString()));
      DatabaseReference staff = db.ref("Users").child("Staff").child("path");
      return login;
    } catch (e) {
      return null;
    }
  }

  /// Signs out an user from the interface
  Future<UserCredential> signOutUser() {
    var login = auth().signOut().then((value) {
      return value;
    });
  }

  /// This is the admin password, checks if its correct.
  bool checkJennyPassword(String password) {
    return password == JennyPassword;
  }

  /// Creates a new staff account, using an email, password, and admin password.
  void createNewStaffAccount(
      String email, String password, String jennyPassword) {
    try {
      if (jennyPassword == this.JennyPassword) {
        String safeemail = email.replaceAll(".", ",");
        DatabaseReference refArt =
            db.ref("Users").child("Staff").child(safeemail);
        StaffAccount s = StaffAccount(email: email);
        refArt.set(s.toMap());
        auth().createUserWithEmailAndPassword(email, password);
        auth().signOut();
      } else {
        debugPrint("Jenny password not correct!");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Sends an email to the email entered so the password can be reset.
  void resetStaffPassword(String email, String jennyPassword) {
    try {
      if (jennyPassword == this.JennyPassword) {
        auth().sendPasswordResetEmail(email);
      } else {
        debugPrint("Jenny password incorrect");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Pushes an article into the database, it searches for Articles, then the category, and pushes the article there.
  void pushArticle(String category, EducationArticle edu) {
    DatabaseReference refArt = db.ref("Articles");
    refArt.child(category).push(edu.toMap());
  }

  /// Pushes news or event to the database
  void pushNewsOrEventItem(NewsOrEventItem edu) {
    DatabaseReference refNews = db.ref("NewsAndEvents");
    refNews.push(edu.toMap());
  }

  /// Edits a news or event item in the database
  void setNewsOrEventItem(NewsOrEventItem edu, String key) {
    DatabaseReference refNews = db.ref("NewsAndEvents").child(key);
    refNews.set(edu.toMap());
  }

  /// Deletes news or event item in the database.
  void deleteNewsOrEventItem(String key) {
    DatabaseReference refNews = db.ref("NewsAndEvents").child(key);
    refNews.remove();
  }

  /// Donation drop offs are deleted in batches as they are deleted when collected from a depot, so a list of donations collected is sent and removed from the database
  Future deleteDonationDropoff(List<String> dropKeys) async {
    for (String key in dropKeys) {
      DatabaseReference refDrop = db.ref("DonationDropoffs").child(key);
      refDrop.remove();
    }
  }

  /// Pushes a donor number to the database, links an account with donor number.
  void pushDonorNumber(NewDonorNumber donorNumber) {
    DatabaseReference refArt =
        db.ref("DonorNumbers").child(donorNumber.email.replaceAll(".", ","));
    refArt.set(donorNumber.toMap());
  }

  /// Pushes a depot to the database
  void pushDepot(Depot depot) {
    DatabaseReference refArt = db.ref("Depots");
    refArt.push(depot.toMap());
  }

  /// Removes a depot from the database
  void deleteDepot(String key) {
    DatabaseReference refNews = db.ref("Depots").child(key);
    refNews.remove();
  }

  /// Edits article in the database. If the category changes then the article in the old category is deleted.
  void setArticle(EducationArticle edu, String key, String category) {
    print(edu.category);
    DatabaseReference oldRef = db.ref("Articles").child(category).child(key);
    oldRef.remove();
    DatabaseReference refNews =
        db.ref("Articles").child(edu.category).child(key);
    refNews.set(edu.toMap());
  }

  ///Edits a depot item in the database
  void setDepot(Depot depot, String key) {
    DatabaseReference refNews = db.ref("Depots").child(key);
    refNews.set(depot.toMap());
  }

  ///Deletes article from database
  void deleteArticle(String category, String key) {
    DatabaseReference refNews = db.ref("Articles").child(category).child(key);
    refNews.remove();
  }

  ///Push suggested article from the database this was for testing
  void pushSuggestedArticle(SuggestedArticle edu) {
    DatabaseReference refArt = db.ref("SuggestedArticles");
    refArt.push(edu.toMap());
  }

  ///Deletes a suggested article from the database
  void declineSuggestedArticle(String key) {
    DatabaseReference refNews = db.ref("SuggestedArticles").child(key);
    refNews.remove();
  }

  ///Deletes donor number from database, unlinking it from an existing account.
  void deleteDonorNumber(String email) {
    DatabaseReference refNews = db.ref("DonorNumbers").child(email);
    refNews.remove();
  }
}
