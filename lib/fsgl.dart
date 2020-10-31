import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: ToTMap()
        )
    );
  }
}

class ToTMap extends StatefulWidget {
  @override
  State createState() => ToTMapState();
}


class ToTMapState extends State<ToTMap> {
  GoogleMapController mapController;
  final Set<Marker> _markers = {};

  // Position _currentPosition;
  // String _currentAddress;
  // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //
  // _getCurrentLocation() {
  //   geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //     _getAddressFromLatLng();
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
  //
  // _getAddressFromLatLng() async {
  //   try {
  //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
  //         _currentPosition.latitude, _currentPosition.longitude);
  //     Placemark place = p[0];
  //     setState(() {
  //       _currentAddress =
  //       "${place.locality}, ${place.postalCode}, ${place.country}";
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> _animateToUser() async {
    //_getCurrentLocation();

    // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //   bearing: 192,
    //   target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
    //   tilt: 59.44,
    //   zoom: 11.0,
    // )));
    mapController.animateCamera(CameraUpdate.newCameraPosition(_samplePos));
  }



  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _updateCameraPosition(CameraPosition position) {
    setState((){
      _position = position;
      _positionl = position.target;
    });
  }

  _addMarker() {
    var markerIdVal = _positionl.toString();
    MarkerId markId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markId,
        position: _positionl,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
        title: "This is a title",
        snippet: "🍄🍄🍄",
      ),
    );
    _markers.add(marker);
  }

  static final CameraPosition _initial = CameraPosition(target: LatLng(24.150, -110.32), zoom: 10);
  static final CameraPosition _samplePos = CameraPosition(
    bearing: 192,
    target: LatLng(33.748997, -84.387985),
    tilt: 59.44,
    zoom: 11.0,
  );


  CameraPosition _position = _initial;
  LatLng _positionl = _initial.target;
  MapType _currentMT = MapType.hybrid;

  _onMapTypebuttonPressed(){
    setState(() {
      _currentMT = _currentMT == MapType.hybrid
          ? MapType.normal : MapType.hybrid;
    });
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.deepPurple,
        child: Icon(icon, size: 36.0)
    );
  }

  @override
  build(context) {
    return Stack(
        children: [
          GoogleMap(
              initialCameraPosition: _initial,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
              mapType: _currentMT,
              markers: _markers,
              onCameraMove: _updateCameraPosition,
          ),

          Align(
              alignment: Alignment(1.0, 0.70),
              child: button(_addMarker, Icons.pin_drop_outlined),
          ),
          Align(
            alignment: Alignment(1.0, 0.5),
            child: button(_onMapTypebuttonPressed, Icons.map),
          ),
          Align(
            alignment: Alignment(1.0, 0.3),
            child: button(_animateToUser, Icons.location_searching),
          )
        ]
    );
  }
}