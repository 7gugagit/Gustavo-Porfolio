
 /// This is the model class for News or Event items, it creates News or Event items and gives functionality
 /// to read and write to the database using conversions of maps and jsons.


class NewsOrEventItem {

  String dateAdded; //attributes of a news or event item
  String description;
  String image;
  String title;
  String key;
  String url;

  NewsOrEventItem({this.dateAdded, this.description,
    this.image, this.title, this.url, this.key});

  /// Create News or Event object from Map
  factory NewsOrEventItem.fromMap(Map<dynamic, dynamic> map) {
    return NewsOrEventItem(
      dateAdded: map["dateAdded"] ?? " ERROR ",
      description: map["description"],
      image: map["image"],
      title: map["title"],
      url: map["url"],
    );
  }

  /// Creates News or Event object from Json
  factory NewsOrEventItem.fromJson(dynamic json, String newkey) {
    return NewsOrEventItem(
      dateAdded: json['dateAdded'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      key: newkey,
    );
  }

  /// Creates a Map from News or Events object to write to DB
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['dateAdded'] = this.dateAdded;
    map['description'] = this.description;
    map['image'] = this.image;
    map['title'] = this.title;
    map['url'] = this.url;

    return map;
  }
}