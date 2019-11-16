import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maxiaga/models/spbu.dart';

class Maps extends StatefulWidget {
  Position location;
  Maps({Key key, @required this.location}) : super(key: key);
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  Position _currentPosition;
  Set<Marker>_markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() { 
    // print(_markers);
    super.initState();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    // print(_markers);
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position){
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e){
        print(e);
      });

      _markers.add(
        Marker(
          markerId: MarkerId("user location"),
          position: LatLng(widget.location.latitude, widget.location.longitude),
          icon: BitmapDescriptor.defaultMarker
        )
      );
  }

  void _getCurrentLocation(){
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position){
        setState(() {
          _currentPosition = position;
        });
      }).catchError((e){
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    // var userLocation = Provider.of<UserLocation>(context);
    LatLng _center = LatLng(widget.location.latitude, widget.location.longitude);
    
    return Scaffold(
        appBar: AppBar(
          title: Text('MAXIAGA', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.red,
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.my_location),
        //   onPressed: _getCurrentLocation,
        // ),
        body: GoogleMap(
          compassEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers,
      ));
  }
}
