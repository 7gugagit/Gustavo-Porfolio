/// A class which stores depot data
class Depot {

  String id;
  String name;
  String address;
  String lat;
  String long;
  String contactNumber;
  String comments;

  /// Constructor
  Depot({this.id, this.name, this.lat, this.long, this.comments, this.contactNumber, this.address});

  /// Generate a [Depot] from a map, used when retrieving data from the database
  factory Depot.fromMap(String id, Map<dynamic, dynamic> map) {
    return Depot(
      id: id,
      name: map["name"],
      lat: map["lat"],
      long: map["long"],
      comments: map["comments"],
      contactNumber: map["contactNumber"],
      address: map['address'],
    );
  }

  /// Generate a map from a [Depot] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['name'] = this.name;
    map['lat'] = this.lat;
    map['long'] = this.long;
    map['comments'] = this.comments;
    map['contactNumber'] = this.contactNumber;
    map['address'] = this.address;

    return map;
  }
}