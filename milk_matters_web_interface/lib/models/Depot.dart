/// This is the model class for depots, it creates depots and gives functionality
/// to read and write to the database using conversions of maps and jsons.

class Depot {
  String name; //depot attributes
  String address;
  String lat;
  String long;
  String contactNumber;
  String comments;
  String key;

  /// Constructor
  Depot(
      {this.name,
      this.lat,
      this.long,
      this.comments,
      this.contactNumber,
      this.address,
      this.key});

  /// Creates a depot object from a Json
  factory Depot.fromJson(dynamic json, String newkey) {
    return Depot(
      name: json['name'] as String,
      lat: json['lat'] as String,
      long: json['long'] as String,
      comments: json['comments'] as String,
      contactNumber: json["contactNumber"] as String,
      address: json["address"] as String,
      key: newkey,
    );
  }

  /// Creates a depot object from a Map
  factory Depot.fromMap(Map<dynamic, dynamic> map) {
    return Depot(
      name: map["name"],
      lat: map["lat"],
      long: map["long"],
      comments: map["comments"],
      contactNumber: map["contactNumber"],
      address: map['address'],
    );
  }

  /// Makes a depot into a Map to be able to push to DB
  Map<String, String> toMap() {
    Map<String, String> map = Map<String, String>();

    map['name'] = this.name;
    map['lat'] = this.lat;
    map['long'] = this.long;
    map['comments'] = this.comments;
    map['contactNumber'] = this.contactNumber;
    map['address'] = this.address;

    return map;
  }

  /// Compares the name of the depots to order them in descending order.
  int compareTo(Depot depot) {
    String n1 = this.name;
    String n2 = depot.name;
    return n1.compareTo(n2);
  }
}
