import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/FAQsCard.dart';
import 'package:milk_matters_donor_app/models/FaqItem.dart';
import 'package:provider/provider.dart';

/// This stateless widget displays the news and events screen
class FAQs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Retrieve the provider to access the FAQ's from the firebase database
    var _faq = Provider.of<List<FaqItem>>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Frequently Asked Questions'),
          centerTitle: true,
        ),
        backgroundColor: Color.fromRGBO(237, 237, 237, 1),
        ///Show loading
        body: _faq == null ? Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0))) :
        Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: _faq.length,
            // Provide a builder function.
            itemBuilder: (context, index) {
              final item = _faq[index];
              return FAQsCard(
                faqItem: item,
              );
            },
          ),
        ),
      ),
    );
  }
}
