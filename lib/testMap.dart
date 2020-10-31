import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MapTest());
}

class MapTest extends StatefulWidget {
  MapTest() : super();

  @override
  MapTestState createState() {
    return MapTestState();
  }
}

class MapTestState extends State<MapTest> {
Completer<GoogleMapController> _controller = Completer();
static const LatLng _center = const LatLng(45, -122);
final Set<Marker> _markers = {};
LatLng _lastMapPosition = _center;
MapType _currentMapType = MapType.normal;

static final CameraPosition _position1 = CameraPosition(
  bearing: 192,
  target: LatLng(46, -122),
  tilt: 59.44,
  zoom: 11.0,
);

Future<void> _goToPosition1() async{
  final GoogleMapController controller = await _controller.future;
  controller.animateCamera(CameraUpdate.newCameraPosition(_position1));

}

_onMapCreated(GoogleMapController controller) {
  _controller.complete(controller);

}

_onCameraMove(CameraPosition position) {
  _lastMapPosition = position.target;
}

_onMapTypebuttonPressed(){
  setState(() {
    _currentMapType = _currentMapType == MapType.normal
        ? MapType.satellite : MapType.normal;
  });
}

_onAddMarkerButtonPressed(){
  setState(() {
    _markers.add(Marker(
      markerId: MarkerId(_lastMapPosition.toString()),
      position: _lastMapPosition,
      infoWindow: InfoWindow(
        title: "This is a title",
        snippet: "This is a snippet",
      ),
      icon:BitmapDescriptor.defaultMarker,
    ));
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap (
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment(1.0, 0),
                child: Column (
                  children: <Widget>[

                    button(_onMapTypebuttonPressed, Icons.map),
                    SizedBox(height: 16.0),
                    button(_onAddMarkerButtonPressed, Icons.add_location),
                    SizedBox(height: 16.0),
                    button(_goToPosition1, Icons.location_searching)
                  ],
              )
              )


            )
          ],
        )
      )
    );
  }
}