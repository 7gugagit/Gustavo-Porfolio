
 /// This is the model class for Donation Drop-offs, it creates depots and gives functionality
 /// to read and write to the database using conversions of maps and jsons.


class DonationDropoff {

  String donorNumber; //donation drop off attributes
  String donorEmail;
  String depotId;
  String amount;
  String dateDroppedOff;
  String key;

  /// Constructor
  DonationDropoff({this.donorNumber, this.amount, this.dateDroppedOff, this.depotId, this.donorEmail, this.key});

  /// Create a donation drop off object from Json
  factory DonationDropoff.fromJson(dynamic json, String newKey) {
    return DonationDropoff(
      donorNumber: json['donorNumber'] as String,
      donorEmail: json['donorEmail'] as String,
      depotId: json['depotId'] as String,
      amount: json['amount'] as String,
      dateDroppedOff: json["dateDroppedOff"] as String,
      key: newKey,
    );
  }

  /// Create a donation drop off object from Map
  factory DonationDropoff.fromMap(Map<dynamic, dynamic> map) {
    return DonationDropoff(
      donorNumber: map["donorNumber"],
      amount: map["amount"],
      dateDroppedOff: map["dateDroppedOff"],
      depotId: map["depotId"],
      donorEmail: map["donorEmail"],
    );
  }

  /// Makes a donation drop off into a Map to write to DB
  Map<String, String> toMap(){
    Map<String, String> map = Map<String, String>();

    map['donorNumber'] = this.donorNumber;
    map['amount'] = this.amount;
    map['dateDroppedOff'] = this.dateDroppedOff;
    map['depotId'] = this.depotId;
    map['donorEmail'] = this.donorEmail;

    return map;
  }

  @override
  String toString() {
    return "DonationDropoff [donorNumber=${this.donorNumber}, amount=${this.amount}, dateDroppedOff=${this.dateDroppedOff}, depotId=${this.depotId}, donorEmail=${this.donorEmail}]";
  }
}