import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:maxiaga/main.dart';

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

  @override
  void initState() {
    // TODO: implement initState
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

  Future _postOrderBan(int id, String token, Position location) async{
    final coordinates = Coordinates(location.latitude, location.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(address.first.addressLine);
    var res = await http.post('http://maxiaga.com/backend/api/post_order', body: {
      'token':token,
      'address':address.first.addressLine,
      'lng':location.longitude.toString(),
      'lat':location.latitude.toString(),
      'id_mx_ms_category_service': id.toString(),
    });
    var jsonRes;
    if (res.statusCode == 200 ) {
      jsonRes = json.decode(res.body);
      print(jsonRes);
      return jsonRes;
    } else {
      throw Exception('Cannot Post Data');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tambal Ban'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Container(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 2.6,
                  child: Center(
                      child: Text(
                    'Ganti Ban',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))),
              onPressed: () {
                _postOrderBan(4,widget.token, widget._currentLocation).then((value){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage(locationNow: widget._currentLocation,spbu: null,index: 2,)), (Route<dynamic> route)=>false);
                });
              },
            ),
            RaisedButton(
              color: Colors.red,
              child: Container(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 2.6,
                  child: Center(
                      child: Text(
                    'Tambal Ban',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))),
              onPressed: () {
                _postOrderBan(4,widget.token, widget._currentLocation).then((value){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage(locationNow: widget._currentLocation,spbu: null,index: 2,)), (Route<dynamic> route)=>false);
                });
              },
            ),
          ],
        ),
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
}
