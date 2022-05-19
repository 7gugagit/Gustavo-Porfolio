import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/customWidgets/cards/NewsAndEventCard.dart';
import 'package:milk_matters_donor_app/models/NewsAndEventsItem.dart';
import 'package:provider/provider.dart';

/// This stateless widget displays the news and events screen
class NewsAndEvents extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    /// Retrieve the provider to access the news and events from the firebase database
    var _newsAndEvents = Provider.of<List<NewsAndEventsItem>>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('News & Events'),
          centerTitle: true,

        ),
        //drawer: NavDrawer('News and Events'),
        body: _newsAndEvents == null ? Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0))) :
        Container(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            // Let the ListView know how many items it needs to build.
            itemCount: _newsAndEvents.length,
            // Provide a builder function.
            itemBuilder: (context, index) {
              final item = _newsAndEvents[index];
              return NewsAndEventCard(
                newsAndEventsItem: item,
              );
            },
          ),
        ),
      ),
    );
  }
}
