import 'package:firebase_database/firebase_database.dart';

class User{
  String fullName;
  String phoneNumber;
  String email;
  bool donorStatus;

  ///Constructor
  User({this.fullName, this.email, this.phoneNumber, this.donorStatus});

  User.forSnapShot(DataSnapshot snapshot) : email = snapshot.key,
        fullName = snapshot.value["fullName"],
        phoneNumber = snapshot.value["phoneNumber"];

  /*toJSON(){
    return(
      "Full Name" : fullName,
        "Phone Number" : phoneNumber,
        "Email" : email,
    );
  }*/
  /// Generates a map from a [User] object, used when writing data to the database
  Map<String, String> toMap() {
    Map<String, String> map = Map<String, String>();

    map['fullName'] = this.fullName;
    map['phoneNumber'] = this.phoneNumber;
    map['email'] = this.email;
    //map['donorStatus'] = this.donorStatus;
    return map;
  }
  String getFullName(){
    return fullName;
  }

  String getEmail(){
    return email;
  }

  String getPhoneNumber(){
    return phoneNumber;
  }

  bool getDonorStatus(){
    return donorStatus;
  }

}