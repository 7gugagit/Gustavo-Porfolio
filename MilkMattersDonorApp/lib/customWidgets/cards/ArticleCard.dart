import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:milk_matters_donor_app/models/EducationArticle.dart';
import 'package:milk_matters_donor_app/helpers/Base64Image.dart';
import 'package:milk_matters_donor_app/screens/FullUrl.dart';
import 'package:share/share.dart';
import 'package:readmore/readmore.dart';

/// A card which displays the detail of an [eduArticle].
///
/// It displays:
/// The article image (defaults to the MM logo)
/// The article title
/// The date it was added
/// Within an ExpandedTile(
///   Article description
///   Article URL
/// )
/// It also includes a share button to share the content.
class ArticleCard extends StatelessWidget {

  final EducationArticle eduArticle;

  ArticleCard({this.eduArticle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      ///Article card
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ///Image
            ListTile(
              leading: eduArticle.image == 'none' ? Image.asset('assets/milk_matters_logo_login.png') : imageFromBase64String(eduArticle.image),
              title: Text(eduArticle.title),
              subtitle: Text(
                eduArticle.dateAdded,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            ///Description
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: ReadMoreText(
                eduArticle.description,
                  trimLines: 3,
                  colorClickableText: Colors.black.withOpacity(0.4),
                  trimMode: TrimMode.Line,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),

            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///See full article button
                TextButton.icon(
                  icon: Icon(Icons.article),
                  onPressed: () async {
                    _handleURLButtonPress(context, eduArticle.url, eduArticle.title);
                  },
                  label: const Text('See full article', style: TextStyle(fontSize: 14),),
                ),

                ///Share button
                TextButton.icon(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share('I found this article on the Milk Matters Mobile App: ' + eduArticle.title + ' ' + eduArticle.url,
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
    );
  }
  ///Open URL
  void _handleURLButtonPress(BuildContext context, String url, String title) {
    if (url.contains('https',0)){
      url = 'https:' + eduArticle.url.substring(5);
    }
    else if (eduArticle.url.contains('http',0)) {
      url = 'https:' + eduArticle.url.substring(5);
    }
    else {
      url = 'https:' + eduArticle.url;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}
