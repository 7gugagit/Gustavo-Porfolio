
/// This class stores the data associated with a suggested article
class SuggestedArticle {

  String suggestedBy;
  String donorNumber;
  String dateSuggested;
  String url;
  String comments;

  /// Constructor
  SuggestedArticle({this.suggestedBy, this.donorNumber,
    this.dateSuggested, this.url, this.comments});

  /// Generates a map from a [SuggestedArticle] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['suggestedBy'] = this.suggestedBy;
    map['donorNumber'] = this.donorNumber;
    map['dateSuggested'] = this.dateSuggested;
    map['url'] = this.url;
    map['comments'] = this.comments;

    return map;
  }

}