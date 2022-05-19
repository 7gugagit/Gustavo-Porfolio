import 'dart:async';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:milk_matters_donor_app/customWidgets/MapPinPillComponent.dart';
import 'package:milk_matters_donor_app/helpers/LocationHelper.dart';
import 'package:milk_matters_donor_app/models/Depot.dart';
import 'package:milk_matters_donor_app/screens/depotLocator/Depots.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// This stateful widget displays the Depot Locator screen
///
/// It allows users to locate depots using a Google Maps map
class DepotLocator extends StatefulWidget {
  @override
  /// Creates the state containing the functionality for the widget.
  _DepotLocatorState createState() => _DepotLocatorState();
  FirebaseAnalytics firebaseAnalytics = new FirebaseAnalytics();
}

/// The state created by the widget.
class _DepotLocatorState extends State<DepotLocator> {

  ///The completer of type GoogleMapController, used to process interactions with the map
  Completer<GoogleMapController> _controller = Completer();
  /// The default position of the pin, below the map interface and essentially hidden
  double pinPillPosition = -150;
  /// An empty depot, used when no depot is selected
  Depot currentlySelectedPin = Depot(address: '', long: '0', lat: '0', contactNumber: '', name: '', comments: '');

  /// A set of markers used to represent the depots on the map
  Set<Marker> _markers = Set<Marker>();

  /// The starting position of the map's camera vew
  CameraPosition _startingPosition = CameraPosition(
    zoom: 16,
    target: LatLng(-33.9489479, 18.4741508),
  );

  ///static final CameraPosition _kLake = CameraPosition(
   //   bearing: 192.8334901395799,
   //   target: LatLng(37.43296265331129, -122.08832357078792),
   //   tilt: 59.440717697143555,
   //   zoom: 19.151926040649414);

  Location location = new Location();
  LocationData _locationData;

  @override
  void initState() {
    /// Request the required permissions when the widget is first initialised
    LocationHelper().requestLocationPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /// The provider to access the permission data
    var _locationPermission = Provider.of<bool>(context);
    /// The provider used to access the depots retrieved from the firebase database
    var _depotsProvider = Provider.of<List<Depot>>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Depot Locator',
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        /// If the providers are null, then display a loading spinner until the values are ready to be presented
        body: (_depotsProvider == null || _locationPermission == null) ? Container(child: Center(child: CupertinoActivityIndicator(radius: 50.0))) :
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        mapToolbarEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: true,
                        initialCameraPosition: _startingPosition,
                        markers: _markers,
                        onTap: (LatLng location) {
                          setState(() {
                            pinPillPosition = -200;
                          });
                        },
                        onMapCreated: (GoogleMapController controller)async{
                          /// Set the markers to represent the depot
                          await setDepotMarkers(_depotsProvider);
                          _controller.complete(controller);
                          setStartingCameraLocation( _locationPermission);
                        },
                      ),
                MapPinPillComponent(
                          pinPillPosition: pinPillPosition,
                          currentlySelectedDepot: currentlySelectedPin,
                      )
                    ],
                  ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ElevatedButton.icon(
                      icon: Icon(Icons.location_on, color: Colors.grey[200],),
                      label: Text('Find My Nearest Depot'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        textStyle: TextStyle(
                          color: Colors.grey[200],),
                      ),
                    /// If permissions are granted, take the user to the depot closest to their current location
                    onPressed: () async {
                      if(_locationPermission){
                        Depot shortestDistanceDepot;
                        double shortestDistance = double.infinity;
                        _locationData = await location.getLocation();
                        var depots = _depotsProvider;
                        depots.forEach((depot) async {
                          double distanceInMeters = calculateDistance(_locationData.latitude, _locationData.longitude, double.parse(depot.lat), double.parse(depot.long));
                          if(distanceInMeters<shortestDistance){
                            shortestDistance = distanceInMeters;
                            shortestDistanceDepot = depot;
                          }
                        });
                        final GoogleMapController controller = await _controller.future;
                        setState(() {
                          controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(double.parse(shortestDistanceDepot.lat), double.parse(shortestDistanceDepot.long)),
                              zoom: 16)));
                        });
                      } else {
                        BotToast.showText(text: 'Enable Location Services and Grant Permissions to use this feature');
                      }
                    },
                  ),

                  ElevatedButton.icon(
                    icon: Icon(Icons.list, color: Colors.grey[200],),
                   label: Text('Depot List'),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[200],),
                      ),
                    onPressed: () async {
                      Depot depot = await Navigator.push(context, MaterialPageRoute(builder: (context) => Depots()));
                      if(depot!=null){
                        final GoogleMapController controller = await _controller.future;
                        setState(() {
                          currentlySelectedPin = depot;
                          pinPillPosition = 0;
                          controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              target: LatLng(double.parse(depot.lat), double.parse(depot.long)),
                              zoom: 16)));
                        });
                      }
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Processes the depot data, using geocoding to determine the latitude and longitude of their addresses.
  /// Finally, add the depot marker to the set of markers
  Future<void> setDepotMarkers(List<Depot> depots) async {
    depots.forEach((depot) async {
      if(depot.long == '0' || depot.lat == '0') {
        depot = await LocationHelper().addLatLongToDepot(depot);
      }
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(depot.name),
          position: LatLng(double.parse(depot.lat), double.parse(depot.long)),
          onTap: () {
            setState(() {
              currentlySelectedPin = depot;
              pinPillPosition = 0;
            });
          },));
      });
    });
  }

  /// Set the starting camera location to focus on the users current location
  void setStartingCameraLocation(bool locationEnabled) async {
    if(locationEnabled){
      _locationData = await location.getLocation();
      setState(() {
        _startingPosition = CameraPosition(
          zoom: 10,
          //zoom: 14.4746,
          target: LatLng(_locationData.latitude, _locationData.longitude),
        );
      });
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_startingPosition));
    }
  }

  /// Method used to calculate the distance between two (lat,long) points
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }


}
