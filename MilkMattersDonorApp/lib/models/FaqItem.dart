/// This class stores the data associated with an FAQ item
class FaqItem{

  String question;
  String answer;

  /// Constructor
  FaqItem({this.question, this.answer});

  /// Generate an [FaqItem] from a map, used when retrieving data from the database
  factory FaqItem.fromMap(Map<dynamic, dynamic> map) {
    return FaqItem(
      question: map["title"],
      answer: map["description"],
    );
  }

  /// Generates a map from a [FaqItem] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['title'] = this.question;
    map['description'] = this.answer;

    return map;
  }

}