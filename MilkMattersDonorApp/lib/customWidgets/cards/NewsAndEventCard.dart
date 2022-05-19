import 'dart:ui';
import 'package:milk_matters_donor_app/screens/FullUrl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:milk_matters_donor_app/helpers/Base64Image.dart';
import 'package:milk_matters_donor_app/models/NewsAndEventsItem.dart';
import 'package:share/share.dart';
import 'package:readmore/readmore.dart';


/// A card which displays the detail of a [NewsAndEventsItem].
///
/// It displays:
/// The item's image (defaults to the MM logo)
/// The title
/// The date it was added
/// Its URL
/// Within an ExpandedTile(
///   Article description
/// )
/// It also includes a share button to share the content.
class NewsAndEventCard extends StatelessWidget {

  /// The news and events item that will be displayed on this card
  final NewsAndEventsItem newsAndEventsItem;
  NewsAndEventCard({this.newsAndEventsItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ///Card
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///News and Event Title
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 10.0),
              child: Text(
                  newsAndEventsItem.title,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
              ),
            ),
            ///Image
            Container(
              height: 150,
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      newsAndEventsItem.image == 'none' ? Image.asset('assets/milk_matters_logo_login.png') : imageFromBase64String(newsAndEventsItem.image),
                    ],
                  ),
              ),
            ),

            /// Upload date and description
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Date
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                    child: Text(
                      'Date: ' + newsAndEventsItem.dateAdded,
                      style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12.0),
                    ),
                  ),
                  ///Description
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
                    child: ReadMoreText(
                      newsAndEventsItem.description,
                      trimLines: 3,
                      colorClickableText: Colors.black.withOpacity(0.4),
                      trimMode: TrimMode.Line,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
             ),


            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.web_rounded),
                  onPressed: () async {
                  ///if URL contains 'http', remove it
                      _handleURLButtonPress(context, newsAndEventsItem.url, newsAndEventsItem.title);
                  },
                  label: const Text('See full event', style: TextStyle(fontSize: 14)),
                ),

                TextButton.icon(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share(newsAndEventsItem.title + ' ' + newsAndEventsItem.url + ' Shared from the Milk Matters App.',
                        sharePositionOrigin:
                        box.localToGlobal(Offset.zero) &
                        box.size);
                  },
                  label: const Text('Share', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
  ///Open URL
  void _handleURLButtonPress(BuildContext context, String url, String title) {
    if (url.contains('https',0)){
      url = 'https:' + newsAndEventsItem.url.substring(5);
    }
    else if (newsAndEventsItem.url.contains('http',0)) {
      url = 'https:' + newsAndEventsItem.url.substring(5);
    }
    else {
      url = 'https:' + newsAndEventsItem.url;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}
