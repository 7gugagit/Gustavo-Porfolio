
/// This class stores the data of a single tracked donation
class TrackedDonation{

  final String columnId = '_id';
  final String columnAmount = 'amount';
  final String columnDateString = 'dateString';
  final String columndateFormated = 'dateFormated';
  final String columnDonationProcessed = 'donationProcessed';

  int id;
  int amount;
  String dateRecorded;
  String dateFormated;
  bool donationProcessed;

  /// Constructor for a tracked donation with an ID
  TrackedDonation({this.id, this.amount, this.dateRecorded, this.donationProcessed, this.dateFormated});
  /// Constructor for a tracked donation without an ID
  TrackedDonation.withoutId({this.amount, this.dateRecorded, this.donationProcessed, this.dateFormated});

  /// Generates a map from a [TrackedDonation] object, used when writing data to the database
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAmount: amount,
      columnDateString: dateRecorded,
      columnDonationProcessed: donationProcessed == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  /// Generate an instance of [TrackedDonation] from a map, used when retrieving data from the database
  TrackedDonation.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    amount = map[columnAmount];
    dateRecorded = map[columnDateString];
    donationProcessed = map[columnDonationProcessed] == 1;
    dateFormated = map[columndateFormated];
  }

  @override
  String toString() {
    return "TrackedDonation [id=${this.id}, amount=${this.amount}, dateRecorded=${this.dateRecorded}, donationProcessed=${this.donationProcessed}, dateFormated=${this.dateFormated}]";
  }
}