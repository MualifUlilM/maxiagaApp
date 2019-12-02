import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'buttonBan.dart';

class OrderTambalban extends StatefulWidget {
  Position _currentLocation;
  String token;
  OrderTambalban(@required this._currentLocation, @required this.token);
  @override
  _OrderTambalbanState createState() => _OrderTambalbanState();
}

class _OrderTambalbanState extends State<OrderTambalban> {
  @override
  GoogleMapController mapcontroller;
  Set<Marker> _marker = {};
  ButtonBan button = ButtonBan();

  @override
  void initState() {
    super.initState();
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId('User Location'),
          position: LatLng(widget._currentLocation.latitude, widget._currentLocation.longitude),
          icon: BitmapDescriptor.defaultMarker
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapcontroller = controller;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tambal Ban'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: _buildButton(context),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget._currentLocation.latitude, widget._currentLocation.longitude),
          zoom: 16,
        ),
        markers: _marker,
      ),
    );
  }

  Row _buildButton(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          button.buildButtonBan(context, 4, widget._currentLocation, widget.token, 'Ganti Ban'),
          button.buildButtonBan(context, 4, widget._currentLocation, widget.token, 'Tambal Ban'),
        ],
      );
  }

  
}
