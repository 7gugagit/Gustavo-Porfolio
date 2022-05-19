import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/helpers/AuthExceptionHandler.dart';
import 'package:milk_matters_donor_app/helpers/AuthResultStatus.dart';

/// This class provides authentication functionality used in the app.
///
/// It heavily leverages [FirebaseAuth] for the following functionality:
/// login, register, sign out, password reset
class FirebaseAuthenticationService extends ChangeNotifier{

  /// Retrieve the Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthResultStatus _status;

  /// Get a stream containing User objects, which returns the user if any authentication state changes occur
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  /// Returns the currently signed in user, null if no user signed in
  User getCurrentUser() {
    return _auth.currentUser;
  }

  /// Attempts to sign a user in with the provider email and password
  Future signInEmailPassword(String email, String password) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthResultStatus.successful;
    } catch (e) {
      print('Exception @signInEmailPassword: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  /// Attempts to register an email and password pair for a new account
  Future registerEmailPassword(String email, String password) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _status = AuthResultStatus.successful;
    } catch (e) {
      print('Exception @registerEmailPassword: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  /// Sends a password reset email to the provided email address
  Future sendForgotPasswordEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  /// Signs the current user out.
  Future signOut() async {
    try{
      await _auth.signOut();
      print('signed out');
      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}