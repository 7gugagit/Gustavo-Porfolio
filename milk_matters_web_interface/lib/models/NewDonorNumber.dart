/// This is the model class for new donor numbers, it new donor number objects and gives functionality
/// to read and write to the database using conversions of maps and jsons.
class NewDonorNumber {
  String donorNumber;
  String email;

  NewDonorNumber({this.donorNumber, this.email});

  /// Create a new donor number object from Json
  factory NewDonorNumber.fromJson(dynamic json) {
    return NewDonorNumber(
      donorNumber: json['donorNumber'] as String,
      email: json['email'] as String,
    );
  }

  /// Create a new donor number off object from a map
  factory NewDonorNumber.fromMap(Map<dynamic, dynamic> map){
    return NewDonorNumber(
      donorNumber: map["donorNumber"],
      email: map["email"],
    );
  }

  /// Generate a map from a donor number object
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();
    map["donorNumber"] = this.donorNumber;
    map["email"] = this.email;
    return map;
  }
}