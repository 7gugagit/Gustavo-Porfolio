import 'package:intl/intl.dart';


 /// This is the model class for educational articles, it creates articles and gives functionality
 /// to read and write to the database using conversions of maps and jsons.


class EducationArticle {

  String dateAdded; //information for an education article
  String description;
  String image;
  String title;
  String url;
  String key;
  String category;
  DateTime date;

  /// Constructor
  EducationArticle({this.dateAdded, this.description,
    this.image, this.title, this.url, this.key, this.category});

  /// Create education article object from a Map
  factory EducationArticle.fromMap(Map<dynamic, dynamic> map) {
    return EducationArticle(
      dateAdded: map["dateAdded"] ?? " ERROR ",
      description: map["description"],
      image: map["image"],
      title: map["title"],
      url: map["url"],
    );
  }

  /// Create an education article object from Json
  factory EducationArticle.fromJson(dynamic json, String newkey, String cat) {
    return EducationArticle(
      dateAdded: json['dateAdded'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      url: json["url"] as String,
      category: cat,
      key: newkey,
    );
  }

  /// Makes the education article object into a Map for writing to DB
  Map<String, String> toMap() {
    Map<String, String> map = Map<String, String>();

    map['dateAdded'] = this.dateAdded;
    map['description'] = this.description;
    map['image'] = this.image;
    map['title'] = this.title;
    map['url'] = this.url;
    map['category'] = this.category;

    return map;
  }

  void setCategory(String category) {
    this.category = category;
  }

  /// Compares the date added attributes of the article to order them in descending order.
  int compareTo(EducationArticle date) {
    DateTime d1 = new DateFormat("dd/MM/yyyy").parse(dateAdded);
    DateTime d2 = new DateFormat("dd/MM/yyyy").parse(date.dateAdded);
    return d2.compareTo(d1);
  }
}