/// This is the model class for staff accounts, it creates staff account objects and gives functionality
/// to read and write to the database using conversions of maps and jsons.

class StaffAccount {
  String email;
  String accountType;

  /// Constructor
  StaffAccount({this.email, this.accountType});

  /// Create staff account object from Map
  factory StaffAccount.fromMap(Map<dynamic, dynamic> map){
    return StaffAccount(
      accountType: map["AccountType"],
      email: map["Email"],
    );
  }

  /// Creates a Map from a staff account object to write to DB
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();
    map["AccountType"] = this.accountType;
    map["Email"] = this.email;
    return map;
  }
}