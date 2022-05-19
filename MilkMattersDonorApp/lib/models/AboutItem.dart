
/// The class to store about us details
class AboutItem {
  String email;
  String description;
  String primaryNumber;
  String secondaryNumber;
  String title;

  /// Constructor
  AboutItem({this.title, this.description, this.email, this.primaryNumber, this.secondaryNumber,});

  factory AboutItem.fromMap(Map<dynamic, dynamic> map) {
    return AboutItem(
        title: map['title'],
        email: map['email'],
        description: map['description'],
        primaryNumber: map['primaryNumber'],
        secondaryNumber: map['secondaryNumber']
    );
  }
  /// Generate a map from a [AboutItem] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();
    map['title'] = this.title;
    map['email'] = this.email;
    map['description'] = this.description;
    map['primaryNumber'] = this.primaryNumber;
    map['secondaryNumber'] = this.secondaryNumber;

    return map;
  }
}