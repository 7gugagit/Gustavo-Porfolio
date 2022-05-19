import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("assets/milk_matters_logo.png"),
          title: "Welcome to Milk Matters",
          body: "Milk Matters is a breastmilk bank in the Western Cape",
          ),
      PageViewModel(
        title: "What do we do?",
        image: Image.asset("assets/baby_intro.png"),
        body: "We give babies without access to breastmilk from their own "
              "mothers donated pasteurized breastmilk.",
      ),
      PageViewModel(
        title: "Impact of Donor Breastmilk",
        image: Image.asset("assets/donor_milk.png"),
        body: "With 50ml of breastmilk you could feed a premature baby of under "
            "1kg for a whole day and make a huge impact on the baby’s health.",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 220, 216, 1),
      appBar: AppBar(
        title: Text(
          'Welcome to Milk Matters',
        ),
        centerTitle: true,
      ),
      body: IntroductionScreen(
        //globalBackgroundColor: Theme.of(context).backgroundColor,
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,
        skip: Text("Skip"),
        done: Text("Done", style: TextStyle(color: Theme.of(context).primaryColor),),
        onDone: () {
          Navigator.pushNamed(context, '/privacyInfo');
        },
      ),
    );
  }
}