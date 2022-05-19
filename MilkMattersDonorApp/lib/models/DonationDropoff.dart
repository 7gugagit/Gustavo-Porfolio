
/// The class which stores the data associated with a donation drop-off
class DonationDropoff {

  String donorNumber;
  String donorEmail;
  String depotId;
  String amount;
  String dateDroppedOff;

  /// Constructor
  DonationDropoff({this.donorNumber, this.amount, this.dateDroppedOff, this.depotId, this.donorEmail});

  /// Generate a [DonationDropoff] from a map, used when retrieving data from the database
  factory DonationDropoff.fromMap(Map<dynamic, dynamic> map) {
    return DonationDropoff(
      donorNumber: map["donorNumber"],
      amount: map["amount"],
      dateDroppedOff: map["dateDroppedOff"],
      depotId: map["depotId"],
      donorEmail: map["donorEmail"],
    );
  }

  /// Generate a map from a [DonationDropoff] object, used when writing data to the database
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