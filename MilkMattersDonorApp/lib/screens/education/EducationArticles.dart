import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/ArticleCard.dart';
import 'package:milk_matters_donor_app/models/EducationArticle.dart';
import 'package:milk_matters_donor_app/services/FirebaseAnalytics.dart';

/// The stateless widget which displays the eduction articles screen
// ignore: must_be_immutable
class EducationArticles extends StatelessWidget {

  /// setup variables to store argument data
  Map arguementData = {};
  List<EducationArticle> articles;

  @override
  Widget build(BuildContext context) {

    /// retrieve argument data
    arguementData = arguementData.isNotEmpty ? arguementData : ModalRoute.of(context).settings.arguments;
    articles = arguementData['articles'];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            arguementData['category'],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          ///Articles list
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: articles.length,
            // Provide a builder function.
            itemBuilder: (context, index) {
              final item = articles[index];
              return ArticleCard(
                eduArticle: item,
              );
            },
          ),
        ),
        ///Suggest Article button
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            'Suggest An Article',
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 15.0,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){
            Analytics().logEvent('Suggest An Article'); ///log event
            Navigator.pushNamed(context, '/suggestAnArticle');
          },
        ),
      ),
    );
  }

}