import 'package:intl/intl.dart';

/// The class which stores an education article's data
class EducationArticle {

  String dateAdded;
  String description;
  String image;
  String title;
  String url;

  /// Constructor
  EducationArticle({this.dateAdded, this.description,
    this.image, this.title, this.url});

  /// Generate an [EducationArticle] from a map, used when retrieving data from the database
  factory EducationArticle.fromMap(Map<dynamic, dynamic> map) {
    return EducationArticle(
      dateAdded: map["dateAdded"],
      description: map["description"],
      //image: 'none',
      image: map["image"],
      title: map["title"],
      url: map["url"],
    );
  }
  /// Generates a map from a [EducationArticle] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['dateAdded'] = this.dateAdded;
    map['description'] = this.description;
    map['image'] = this.image;
    map['title'] = this.title;
    map['url'] = this.url;

    return map;
  }

  /// Used to compare the dates of 2 different articles, returning an int representing the article that is most recent
  int compareTo(EducationArticle date) {
    DateTime d1 = new DateFormat("dd/MM/yyyy").parse(dateAdded);
    DateTime d2 = new DateFormat("dd/MM/yyyy").parse(date.dateAdded);
    return d2.compareTo(d1);
  }
}