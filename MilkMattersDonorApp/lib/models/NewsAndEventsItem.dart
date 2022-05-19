import 'package:intl/intl.dart';

/// This class stores the data associated with a News and events item
class NewsAndEventsItem{
  String dateAdded;
  String description;
  String image;
  String title;
  String url;
  /// Constructor
  NewsAndEventsItem({this.dateAdded, this.description,
                      this.image, this.title, this.url});

  /// Generate an [NewsAndEventsItem] from a map, used when retrieving data from the database
  factory NewsAndEventsItem.fromMap(Map<dynamic, dynamic> map) {
    return NewsAndEventsItem(
      dateAdded: map["dateAdded"],
      description: map["description"],
      image: map["image"],
      title: map["title"],
      url: map["url"],
    );
  }

  /// Generates a map from a [NewsAndEventsItem] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();
    map['dateAdded'] = this.dateAdded;
    map['description'] = this.description;
    map['image'] = this.image;
    map['title'] = this.title;
    map['url'] = this.url;

    return map;
  }

  /// Used to compare the dates of 2 different news and events items, returning an int representing the item that is most recent
  int compareTo(NewsAndEventsItem date) {
    DateTime d1 = new DateFormat("dd/MM/yyyy").parse(dateAdded);
    DateTime d2 = new DateFormat("dd/MM/yyyy").parse(date.dateAdded);
    return d2.compareTo(d1);
  }
}