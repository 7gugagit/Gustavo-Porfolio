import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/screens/Intro.dart';
import 'package:milk_matters_donor_app/screens/BottomNav.dart';
import 'package:provider/provider.dart';

/// This widget acts as a authentication wrapper
///
/// It is used to return either the home or login screens based on whether a user is authenticated
class Wrapper extends StatelessWidget {

  final Image mmLogoImg = Image.asset('assets/milk_matters_logo_login.png');

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    precacheImage(mmLogoImg.image, context);
    if(user == null){
      return Intro();
    } else {
      return Home();
    }
  }
}
