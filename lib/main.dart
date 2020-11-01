import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
  //initialize markers from database
  Geoflutterfire geo = Geoflutterfire();

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      Firebase.initializeApp();
      print("init processed");
      setState(() {
        _initialized = true;
        print(_initialized);
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  Future<String> _getAddress() async {
    double lat = _positionl.latitude;
    double lon = _positionl.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    return placemarks[0].street;
  }

  Future<void> _animateToUser() async {

    mapController.animateCamera(CameraUpdate.newCameraPosition(_samplePos));
  }

  _animateToLocation(double lat, double lon) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192,
      target: LatLng(lat, lon),
      tilt: 59.44,
      zoom: 11.0,
    )
    ));
  }

  _animateToRandom() {
    var rando = new Random();
    double rlat = rando.nextDouble() * 90;
    double rlon = rando.nextDouble() * 90;
    int negNo = rando.nextInt(2);
    int negNo2 = rando.nextInt(2);
    if(negNo > 0) {
      rlat *= -1;
    }
    if(negNo2 > 0) {
      rlon *= -1;
    }

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192,
      target: LatLng(rlat, rlon),
      tilt: 59.44,
      zoom: 11.0,
    )
    ));
  }

  _initializeMarkers() {
    FirebaseFirestore.instance.collection("locations").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print("info reached");

        GeoPoint point = result.data()["location"]["geopoint"];
        double vlat = point.latitude;
        double vlon = point.longitude;

        var positionR = LatLng(vlat, vlon);
        var markIdVal = positionR.toString();
        MarkerId markId = MarkerId(markIdVal);
        String t = result.data()["title"];
        String sn = result.data()["snippet"];

        final Marker mar = Marker(
          markerId: markId,
          position: positionR,
          icon: BitmapDescriptor.defaultMarkerWithHue(29),
          infoWindow: InfoWindow(
            title: t,
            snippet: sn,
          ),
          onTap: () {
            print("A marker was tapped");
            if(editTime){
              seeCM = true;
            } else {
              pointToChange = geo.point(latitude: vlat, longitude: vlon);
              print(pointToChange.toString());
              print("you cannot edit at this time");
            }

          }
        );
        setState(() {
          _markers.add(mar);
        });
        print("marker has been added?");
      });
    });
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

  _addMarkerWithMessage(String message) async {
    String ad = await _getAddress();

    var markerIdVal = _positionl.toString();
    MarkerId markId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markId,
      position: _positionl,
      icon: BitmapDescriptor.defaultMarkerWithHue(29),
      infoWindow: InfoWindow(
        title: ad,
        snippet: message,
      ),
      onTap: () {
        if (editTime) {
          seeCM = true;
        } else {}
      },
    );
    setState(() {
      _markers.add(marker);
    });

    var lat = _positionl.latitude;
    var lon = _positionl.longitude;
    GeoFirePoint point = geo.point(latitude: lat, longitude: lon);
    final locations = FirebaseFirestore.instance.collection('locations');
    print("locations processed?");
    return locations.add({
      'location': point.data,
      'name': ad,
      'title': ad,
      'snippet': message,
    });
  }

  _addMarker() async {
    String ad = await _getAddress();
    Random rand = new Random();
    int pick = rand.nextInt(10);
    String mes = "";
    FirebaseFirestore.instance.collection("messages").get().then((querySnapshot) {
      print("collection reached");
      querySnapshot.docs.forEach((result) {
        print("info reached");
        if (result.data()["index"] == pick) {
          mes += result.data()["message"];
          print(mes);
          print("message has been found");
          var markerIdVal = _positionl.toString();
          MarkerId markId = MarkerId(markerIdVal);
          final Marker marker = Marker(
            markerId: markId,
            position: _positionl,
            icon: BitmapDescriptor.defaultMarkerWithHue(29),
            infoWindow: InfoWindow(
              title: ad,
              snippet: mes,
            ),
            onTap: () {
              if (editTime) {
                seeCM = true;
              } else {
              }
            },
          );
          setState(() {
            _markers.add(marker);
          });

          var lat = _positionl.latitude;
          var lon = _positionl.longitude;
          GeoFirePoint point = geo.point(latitude: lat, longitude: lon);
          final locations = FirebaseFirestore.instance.collection('locations');
          print("locations processed?");
          return locations.add({
            'location': point.data,
            'name': ad,
            'title' : ad,
            'snippet' : mes,
          });

        }
      });});
  }

  static final CameraPosition _initial = CameraPosition(
      target: LatLng(33.77505848304293, -84.39626522362234),
      zoom: 16,
  );
  static final CameraPosition _samplePos = CameraPosition(
    bearing: 192,
    target: LatLng(33.748997, -80),
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

  bool mapTime = true;

  _mapTime() {
    setState(() {
      mapTime = mapTime == true ? false : true;
    });
  }

  Widget homePage() {
    return Visibility(

      child: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/clouds.jpg"),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Image.asset("assets/pumpicon.png", height: 200, width: 200),
          ),
          Align(
            alignment: Alignment(0, -0.7),
            child:Text(
              'Trick-or-Treat',
              style: GoogleFonts.underdog(
                  textStyle:
                  TextStyle(
                    fontSize: 50,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,

                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.5),
            child:Text(
              'Near Me!',
              style: GoogleFonts.underdog(
                  textStyle:
                  TextStyle(
                    fontSize: 50,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,

                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: FlatButton(
              onPressed: () {
                _mapTime();
              },
              child: Text(
                'Find Locations',
                style: GoogleFonts.underdog(
                    textStyle:
                    TextStyle(
                      fontSize: 30,
                      color: Colors.orange,

                    )
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.7),
            child: FlatButton(
              onPressed: () {
                _allowEdits();
                _mapTime();
              },
              child: Text(
                'Set Location',
                style: GoogleFonts.underdog(
                    textStyle:
                    TextStyle(
                      fontSize: 30,
                      color: Colors.orange,

                    )
                ),
              ),
            ),
          ),
        ],

      ),
      visible: mapTime,
    );
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
        onPressed: function,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: Colors.deepPurple,
        child: Icon(icon, size: 36.0)
    );
  }

  void _yesButtonPressed() {
    //ideally, since the camera moves to the marker,
    //should be able to gather lon and lat data there
    pointToChange = geo.point(
        latitude: _positionl.latitude,
        longitude: _positionl.longitude);

    print("yes button did something");
  }

  void _noButtonPressed() {
    setState(() {
      seeCM = false;
    });

  }

  void _allowEdits() {
    setState(() {
      editTime = editTime == true ? false : true;
      mode = editTime == true ? "Edit Mode" : "View Mode";
      _currentMT = editTime == true ? MapType.normal : MapType.hybrid;
    });

  }

  //allows you to toggle change menu visibility
  bool seeCM = false;
  //allows you to see change menu
  bool editTime = false;

  bool seeCP = false;

  String mode = "View Mode";

  GeoFirePoint pointToChange;

  Widget changePage() {
    return Visibility(
      child: Stack(
        children: <Widget>[

        ],
      ),
    );
  }

  Widget changeM() {
    return Visibility(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0,0),
            child: Container(
              height: 300.0,
              width: 300.0,
              color: Colors.blue,
            ),
          ),
          Align (
            alignment: Alignment(0,-.1),
            child: Text(
              "Would you like to",
              style: TextStyle(
                fontSize: 12,
              )
            ),
          ),
          Align (
            alignment: Alignment(0,0),
            child: Text(
                "change this marker?",
                style: TextStyle(
                    fontSize: 12
                )
            ),
          ),

          Align (
              alignment: Alignment(-0.3, 0.3),
              child: RaisedButton(
                child: Text("Yes"),
                onPressed: () {
                  _yesButtonPressed();
                }
              )
          ),
          Align(
              alignment: Alignment(0.3, 0.3),
              child: RaisedButton(
                  child: Text("No"),
                  onPressed: _noButtonPressed,
              )
          )
        ],
      ),
      visible: seeCM,
    );
  }

  _openPopup(context) {
    final myController = TextEditingController();
    // @override
    // void dispose() {
    //   // Clean up the controller when the widget is disposed.
    //   myController.dispose();
    //   super.dispose();
    // }
    Alert(
        context: context,
        title: "Enter a Message!",
        content: Column(
          children: <Widget>[
            Text(
              'Offering allergy-friendly candy? Have any special instructions for picking up candy or socially distanced trick-or-treating?',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Message',
                //icon: Icon(Icons.message_outlined),
              ),
              controller: myController,
            ),

          ],
        ),
        buttons: [
          DialogButton(
            onPressed: (){
              Navigator.pop(context);
              final mess = FirebaseFirestore.instance.collection("messages");
              mess.add({
                'index': 12,
                'message': myController.text,
              });
              _addMarkerWithMessage(myController.text);
              print(myController.text);
            } ,
            child: Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
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
          //changeM(),
          Align(
            alignment: Alignment(.98, 0.7),
            child: button(_onMapTypebuttonPressed, Icons.map),
          ),
          Align(
            alignment: Alignment(.98, 0.5),
            child: button(_initializeMarkers, Icons.where_to_vote_rounded),
          ),
          Align(
            alignment: Alignment(-0.98, .7),
            child: button(_allowEdits, Icons.design_services),
          ),
          Align(
            alignment: Alignment(-0.98, .9),
            child: button(_mapTime, Icons.arrow_back),
          ),
          Align(
            alignment: Alignment(-0.98, 0.5),
            child: Visibility(
                visible: editTime,
                child: FloatingActionButton(
                    onPressed:() {
                      _openPopup(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.pin_drop_rounded, size: 36.0)

                )
            )
          ),
          // Align(
          //   alignment: Alignment(-.98, .5),
          //   child: button(_addMarker, Icons.account_balance_rounded),
          // ),
          Align(
            alignment: Alignment(0, -.0635),
              child: Visibility(
                visible: editTime,
                child: Opacity(
                  opacity: 0.7,
                  child: Icon(Icons.location_pin,
                    size: 50.0,
                    color: Colors.deepPurple),
                )
              ),
          ),
          Align(
            alignment: Alignment(0,-0.8),
            child: Opacity(
              opacity: 0.5,
              child: SizedBox(
                  height: 75.0,
                  width: double.infinity,
                  child: Container(
                      color: Colors.black,
                  )
              ),
            )
          ),
          Align(
            alignment: Alignment(0, -0.76),
            child: Text(
                mode,
                style: GoogleFonts.underdog(
                  textStyle:
                    TextStyle(
                      color: Colors.deepOrange[400],
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                ),)
            ),
          ),
          homePage(),

        ]
    );
  }
}





