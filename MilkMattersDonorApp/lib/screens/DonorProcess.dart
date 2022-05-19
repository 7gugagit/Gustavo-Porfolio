import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class DonorProcess extends StatefulWidget {
  @override
  _DonorProcess createState() => _DonorProcess();
}

class _DonorProcess extends State<DonorProcess> {

  double iconSize = 80;

  List<PageViewModel> getPages() {
    return [

      PageViewModel(
        image: Icon(Icons.assignment_outlined, size: iconSize),
        title: "Step 1",
          body: "Determine your eligibility of becoming a breastmilk donor by submitting 9 pre-screening questions to Milk Matters.",
          ),

      PageViewModel(
        title: "Step 2",
        image: Icon(Icons.account_box_outlined, size: iconSize,),
        body: "Milk Matters will email you more information about the donation process, drop-off locations and consent form.",
      ),
      PageViewModel(
        title: "Step 3",
        image: Icon(Icons.medical_services_outlined, size: iconSize),
        body: "Have your medical tests done and drop-off your first milk donation at a depot location, then Milk Matters will allocate you a donor number.",
      ),
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Become a Donor Process',
        ),
        centerTitle: true,
      ),
      body:
      IntroductionScreen(
        pages: getPages(),
        showNextButton: true,
        showSkipButton: true,

        skip: Text("Skip"),
        done: Text("Next", style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),),
        onDone: () async {
          Navigator.pushNamed(context, '/becomeADonor');
        },
      ),
      /*Column(
        children: <Widget>[
          CarouselSlider(
              items: null
          ),
          Row(
            children: <Widget>[
              Text("data")
            ],
          )
        ],
      )*/
    );
  }
}