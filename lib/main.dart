
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import 'package:rflutter_alert/rflutter_alert.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: HomePage(),
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        //ToTMap.route: (context) => ToTMap(),
        SetPage.route: (context) => SetPage(),
        FindPage.route: (context) => FindPage(),
      },
    );
  }
}
class HomePage extends StatelessWidget {
  static const String route = '/';
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0e5361),//f3eac2
      body: Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("../assets/clouds.jpg"),
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
            alignment: Alignment(0, -0.4),
            child: Image.asset('../assets/pumpkinicon.png', height: 120, width: 120),
          ),
          Align(
            alignment: Alignment(0, -0.7),
            child:Text(
              'Trick-or-Treat Near Me!',
              style: GoogleFonts.underdog(
                textStyle:
                  TextStyle(
                    fontSize: 30,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.1),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FindPage.route);
              },
              child: Text(
                'Find Locations',
                style: GoogleFonts.underdog(
                textStyle:
                  TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    
                  )
              ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.3),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SetPage.route);
              },
              child: Text(
                'Set Location',
                style: GoogleFonts.underdog(
                textStyle:
                  TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    
                  )
              ),
              ),
            ),
          ),
          
        ]
          
      ),
    );
  }
}
class FindPage extends StatefulWidget {
  static const String route = '/find';
  @override
  _FindPage createState() => _FindPage();
}
class _FindPage extends State<FindPage>{
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Align(
            alignment: Alignment(-0.95, 0.95),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.95, 0.95),
            child: FlatButton(
              onPressed: () {
                _openPopup(context); //this runs pop-up
              },
              child: Text(
                'Pop-up',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
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
              print(myController.text);
            } ,
            child: Text(
              "SUBMIT",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }



class SetPage extends StatefulWidget {
  static const String route = '/set';
  @override
  _SetPage createState() => _SetPage();
}
class _SetPage extends State<SetPage>{
  
  final myController = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Align(
            alignment: Alignment(0, -0.7),
            child:Text(
              'Set an Address for Trick-or-Treating!',
              style: GoogleFonts.underdog(
                textStyle:
                  TextStyle(
                    fontSize: 30,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.3),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Address'
                ),
                controller: myController,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Message...any special instructions or types of candy?'
                ),
                controller: myController2,
              ),
            ),
          ),
          Align(
            alignment: Alignment(-0.95, 0.95),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                title: Text('Thanks for Submitting!'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('Address:'),
                      Text(myController.text),
                      Text('Message:'),
                      Text(myController2.text),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}


// class ToTMap extends StatefulWidget {
//   static const String route = '/find';
//   @override
  
//   State createState() => ToTMapState();
// }


// class ToTMapState extends State<ToTMap> {
  
//   GoogleMapController mapController;
//   final Set<Marker> _markers = {};

//   // Position _currentPosition;
//   // String _currentAddress;
//   // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
//   //
//   // _getCurrentLocation() {
//   //   geolocator
//   //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//   //       .then((Position position) {
//   //     setState(() {
//   //       _currentPosition = position;
//   //     });
//   //     _getAddressFromLatLng();
//   //   }).catchError((e) {
//   //     print(e);
//   //   });
//   // }
//   //
//   // _getAddressFromLatLng() async {
//   //   try {
//   //     List<Placemark> p = await geolocator.placemarkFromCoordinates(
//   //         _currentPosition.latitude, _currentPosition.longitude);
//   //     Placemark place = p[0];
//   //     setState(() {
//   //       _currentAddress =
//   //       "${place.locality}, ${place.postalCode}, ${place.country}";
//   //     });
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   Future<void> _animateToUser() async {
//     //_getCurrentLocation();

//     // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//     //   bearing: 192,
//     //   target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
//     //   tilt: 59.44,
//     //   zoom: 11.0,
//     // )));
//     mapController.animateCamera(CameraUpdate.newCameraPosition(_samplePos));
//   }



//   void _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }

//   void _updateCameraPosition(CameraPosition position) {
//     setState((){
//       _position = position;
//       _positionl = position.target;
//     });
//   }

//   _addMarker() {
//     var markerIdVal = _positionl.toString();
//     MarkerId markId = MarkerId(markerIdVal);
//     final Marker marker = Marker(
//         markerId: markId,
//         position: _positionl,
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: InfoWindow(
//         title: "This is a title",
//         snippet: "🍄🍄🍄",
//       ),
//     );
//     _markers.add(marker);
//   }

//   static final CameraPosition _initial = CameraPosition(target: LatLng(24.150, -110.32), zoom: 10);
//   static final CameraPosition _samplePos = CameraPosition(
//     bearing: 192,
//     target: LatLng(33.748997, -84.387985),
//     tilt: 59.44,
//     zoom: 11.0,
//   );


//   CameraPosition _position = _initial;
//   LatLng _positionl = _initial.target;
//   MapType _currentMT = MapType.hybrid;

//   _onMapTypebuttonPressed(){
//     setState(() {
//       _currentMT = _currentMT == MapType.hybrid
//           ? MapType.normal : MapType.hybrid;
//     });
//   }

//   Widget button(Function function, IconData icon) {
//     return FloatingActionButton(
//         onPressed: function,
//         materialTapTargetSize: MaterialTapTargetSize.padded,
//         backgroundColor: Colors.deepPurple,
//         child: Icon(icon, size: 36.0)
//     );
//   }

//   @override
//   build(context) {
//      print("to map");
    
//     return Stack(
      
//         children: [
//           GoogleMap(
//               initialCameraPosition: _initial,
//               onMapCreated: _onMapCreated,
//               myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
//               mapType: _currentMT,
//               markers: _markers,
//               onCameraMove: _updateCameraPosition,
//           ),

//           Align(
//               alignment: Alignment(1.0, 0.70),
//               child: button(_addMarker, Icons.pin_drop_outlined),
//           ),
//           Align(
//             alignment: Alignment(1.0, 0.5),
//             child: button(_onMapTypebuttonPressed, Icons.map),
//           ),
//           Align(
//             alignment: Alignment(1.0, 0.3),
//             child: button(_animateToUser, Icons.location_searching),
//           ),
//           Align(
//             alignment: Alignment(-0.95, 0.95),
//             child: FlatButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 20,
//                   // fontFamily: 'JosefinSans',
//                   // fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ),
//           ),
//         ]
//     );
    
//   }
// }