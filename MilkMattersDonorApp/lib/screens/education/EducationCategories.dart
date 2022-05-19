import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/Models/EducationCategory.dart';
import 'package:milk_matters_donor_app/services/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';

/// This stateful widget displays the education categories screen
class EducationCategories extends StatefulWidget {
  @override
  /// Creates the state containing the functionality and widget tree.
  _EducationCategoriesState createState() => _EducationCategoriesState();
}

/// The state created by the widget.
class _EducationCategoriesState extends State<EducationCategories> {

  // The list of educational categories
  List<EducationCategory> categories = [
    EducationCategory(name: "Breastfeeding", bgImageUrl: "Breastfeeding.png"),
    EducationCategory(name: "Breast Milk Donation", bgImageUrl: "Donation.jpg"),
    EducationCategory(name: "Breast Milk Supply", bgImageUrl: "Breast Milk Supply.png"),
    EducationCategory(name: 'Nutrition When Breastfeeding', bgImageUrl: "Nutrition.jpg"),
    EducationCategory(name: "Latching", bgImageUrl: "Latching.png"),
    EducationCategory(name: 'Expressing, Pumping & Sterilising', bgImageUrl: "Pumping.jpg"),
    EducationCategory(name: "Breast Conditions & Common Concerns", bgImageUrl: "Breast Conditions and Common Concerns.png"),
    EducationCategory(name: "The Working Mother", bgImageUrl: "The Working Mother.png"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// Setup the provider used to access the firebase database
    final databaseProvider = Provider.of<FirebaseDatabaseService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Education Categories',
          ),
          centerTitle: true,

        ),
        //drawer: NavDrawer('Education Categories'),
        body: GridView.count(
          crossAxisCount: 2,
          physics: BouncingScrollPhysics(),
          children: List.generate(8, (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                onTap: () async {
                  Navigator.pushNamed(context, '/educationArticles', arguments: {
                    'category': categories[index].name,
                    'articles': await databaseProvider.getArticles(categories[index].name),
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image:DecorationImage(
                      image: AssetImage('assets/educationCategories/${categories[index].bgImageUrl}'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(0.3, 0.3),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            color: Color.fromRGBO(245, 236, 204, 1),
                            //color: HexColor('#f5eccc'),//Colors.grey[300].withOpacity(0.9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: Center(
                            child: Text(
                              "${categories[index].name}",
                              style: TextStyle(
                                fontSize: 15.0,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
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
            Navigator.pushNamed(context, '/suggestAnArticle');
          },
        ),
      ),
    );
  }
}
