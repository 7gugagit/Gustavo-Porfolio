import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_matters_donor_app/models/GraphAmountDataPoint.dart';
import 'package:milk_matters_donor_app/models/GraphFeedsDataPoint.dart';
import 'package:milk_matters_donor_app/models/TrackedDonation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// This class provides the access and management tools for the app's Local SQL Database - provided by sqflite package.
/// Interaction is done using SQL queries which are built similarly to normal SQL statements
class LocalDatabaseService extends ChangeNotifier{

  /// Set the table and column values for the database
  final String tableTrackedDonations = 'trackedDonations';
  final String columnId = '_id';
  final String columnAmount = 'amount';
  final String columnDateString = 'dateString';
  final String columnDonationProcessed = 'donationProcessed';

  Database db;

  /// Constructor
  LocalDatabaseService(){
    openMMDatabase();
  }

  /// Open the database.
  /// If the database does not yet exist, then create the database and execute
  /// the SQL command to generate the table
  Future openMMDatabase() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mmDatabase.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            create table $tableTrackedDonations ( 
              $columnId integer primary key autoincrement, 
              $columnAmount integer not null,
              $columnDateString text not null,
              $columnDonationProcessed integer not null)
            ''');
        });
  }

  /// Delete the tracked donations database
  Future<void> deleteDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mmDatabase.db');
    databaseFactory.deleteDatabase(path);
  }

  /// Write a tracked donation to the database
  Future<TrackedDonation> insert(TrackedDonation trackedDonation) async {
    await openMMDatabase();
    trackedDonation.id = await db.insert(tableTrackedDonations, trackedDonation.toMap());
    notifyListeners();
    return trackedDonation;
  }

  /// retrieve a particular tracked donation with the specified ID
  Future<TrackedDonation> getTrackedDonation(int id) async {
    await openMMDatabase();
    List<Map> maps = await db.query(tableTrackedDonations,
        columns: [columnId, columnDateString, columnAmount, columnDonationProcessed],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return TrackedDonation.fromMap(maps.first);
    }
    return null;
  }

  /// Retrieve all tracked donations and convert them to a list of [GraphAmountDataPoint] objects.
  /// These will be used to plot the donation data on the donation graph
  Future<List<GraphAmountDataPoint>> getAllTrackedDonationsForAmountGraph() async {
    await openMMDatabase();
    int total = 0;
    List<Map> maps = await db.query(tableTrackedDonations,
      columns: [columnId, columnDateString, columnAmount, columnDonationProcessed],);
    List<GraphAmountDataPoint> dataPoints = <GraphAmountDataPoint>[];

    maps.forEach((element) {
      TrackedDonation tracked = TrackedDonation.fromMap(element);
      dataPoints.add(GraphAmountDataPoint(amount: tracked.amount, date: tracked.dateRecorded, dateDT: DateFormat('d/M/yyyy').parse(tracked.dateRecorded)));
    });
    dataPoints.sort((a,b) => a.dateDT.compareTo(b.dateDT));
    dataPoints.forEach((element) {print(element.date + " " + element.amount.toString() + " " + element.dateDT.toString());});
    for(int i=0; i < dataPoints.length; i++){
      total += dataPoints[i].amount;
      dataPoints[i].amount = total;
      print(total);
    }
    return dataPoints;
  }

  /// Retrieves all tracked donations and convert them to a list of [GraphFeedsDataPoint] objects.
  /// These will be used to plot the donation data on the feeds graph
  Future<List<GraphFeedsDataPoint>> getAllTrackedDonationsForFeedGraph() async {
    await openMMDatabase();
    double total = 0;
    List<Map> maps = await db.query(tableTrackedDonations,
      columns: [columnId, columnDateString, columnAmount, columnDonationProcessed],);

    List<GraphFeedsDataPoint> dataPoints = <GraphFeedsDataPoint>[];

    maps.forEach((element) {
      TrackedDonation tracked = TrackedDonation.fromMap(element);
      dataPoints.add(GraphFeedsDataPoint(amount: double.parse((tracked.amount/50).toStringAsFixed(2)), date: tracked.dateRecorded, dateDT: DateFormat('d/M/yyyy').parse(tracked.dateRecorded)));
    });
    dataPoints.sort((a,b) => a.dateDT.compareTo(b.dateDT));
    for(int i=0; i < dataPoints.length; i++){
      total += dataPoints[i].amount;
      dataPoints[i].amount = total;
    }
    return dataPoints;
  }


  /// Retrieves a list of tracked donations from the database, ordered by date recorded.
  Future<List<TrackedDonation>> getAllTrackedDonationsRecentFirst() async {
    await openMMDatabase();
    List<Map> maps = await db.query(tableTrackedDonations,
      columns: [columnId, columnDateString, columnAmount, columnDonationProcessed],);

    List<TrackedDonation> trackedDonations = <TrackedDonation>[];
    maps.forEach((element) {
      trackedDonations.add(TrackedDonation.fromMap(element));
    });
    trackedDonations.sort((a,b) => a.dateRecorded.compareTo(b.dateRecorded));
    return (trackedDonations.reversed).toList();
  }

  /// Retrieves a list of tracked donations that have not yet been dropped off, ordered by date recorded.
  Future<List<TrackedDonation>> getAllNotDroppedOffTrackedDonationsRecentFirst() async {
    await openMMDatabase();
    List<Map> maps = await db.query(tableTrackedDonations,
      columns: [columnId, columnDateString, columnAmount, columnDonationProcessed],);

    List<TrackedDonation> trackedDonations = <TrackedDonation>[];

    maps.forEach((element) {
      if(element['donationProcessed'] == 0){
        trackedDonations.add(TrackedDonation.fromMap(element));
      }
    });
    return (trackedDonations.reversed).toList();
  }

  /// Deletes a particular Tracked Donation from the database
  Future<int> delete(int id) async {
    return await db.delete(tableTrackedDonations, where: '$columnId = ?', whereArgs: [id]);
  }

  /// Retrieves a list of tracked donations from the database, ordered by date recorded.
  Future<int> update(TrackedDonation trackedDonation) async {
    return await db.update(tableTrackedDonations, trackedDonation.toMap(),
        where: '$columnId = ?', whereArgs: [trackedDonation.id]);
  }

  /// Retrieves the total amount of donated milk
  Future<int> getTotalDonatedAmount() async {
    var trackedDonations = await getAllTrackedDonationsRecentFirst();
    int totalDonated = 0;
    trackedDonations.forEach((element) {totalDonated+=element.amount;});
    return totalDonated;
  }

  /// Closes the database connection
  Future close() async => db.close();

}