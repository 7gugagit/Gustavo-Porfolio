
/// The class to store donor user details
class DonorUser {
  String email;
  String fullName;
  String phoneNumber;
  String donorNumber;

  /// Constructor
  DonorUser({this.fullName, this.email, this.phoneNumber, this.donorNumber});

  /// Generate a map from a [DonorUser] object, used when writing data to the database
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['email'] = this.email;
    map['fullName'] = this.fullName;
    map['phoneNumber'] = this.phoneNumber;
    map['donorNumber'] = this.donorNumber;

    return map;
  }
}