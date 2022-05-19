import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';


/// Helper class to manage and access device location data
///
/// It is used to manage permission requests,
/// and perform geo-coding
class LocationHelper extends ChangeNotifier{

  /// Used to access geo-coding functionality
  Location location = new Location();

  /// boolean to store whether the location service permission is enabled
  bool _serviceEnabled;
  /// boolean to store whether the location service permission is enabled
  PermissionStatus _permissionGranted;

  /// Requests location permissions from the user
  /// First check whether location services are enabled, then request permissions.
  Future<bool> requestLocationPermissions() async{
    //Check if location services are enabled. If not, request, then return false if denied.
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    //Check if location permissions are granted. If not, request, then return false if denied.
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      } else{
        return true;
      }
    }
    return true;
  }

  /// Uses geo-coding to get a lat and long for a particular address,
  /// and then updates the parsed [Depot], adding its lat long value
  Future<Depot> addLatLongToDepot(Depot depot) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(depot.address);
      var first = addresses.first;
      var coords = first.coordinates;
      depot.long = coords.longitude.toString();
      depot.lat = coords.latitude.toString();
      return depot;
    } catch (e) {
      print(e.toString());
    }
  }
}