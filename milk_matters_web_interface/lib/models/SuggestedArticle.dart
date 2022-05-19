
 /// This is the model class for suggested articles, it creates a suggested article and gives functionality
 /// to read and write to the database using conversions of maps and jsons.

class SuggestedArticle {

  String suggestedBy; //suggested article attributes
  String donorNumber;
  String dateSuggested;
  String url;
  String comments;
  String category;
  String key;

  /// Constructor
  SuggestedArticle({this.suggestedBy, this.donorNumber,
    this.dateSuggested, this.url, this.comments, this.key, this.category});

  /// Makes suggested article object into map to write to DB
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['suggestedBy'] = this.suggestedBy;
    map['donorNumber'] = this.donorNumber;
    map['dateSuggested'] = this.dateSuggested;
    map['url'] = this.url;
    map['comments'] = this.comments;

    return map;
  }

  /// Creates suggested article object from a Json
  factory SuggestedArticle.fromJson(dynamic json, String newkey, String cat) {
    return SuggestedArticle(
      dateSuggested: json['dateSuggested'] as String,
      suggestedBy: json['suggestedBy'] as String,
      comments: json['comments'] as String,
      donorNumber: json['donorNumber'] as String,
      url: json["url"] as String,
      category: cat,
      key: newkey,
    );
  }

}