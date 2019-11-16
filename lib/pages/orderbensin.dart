import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxiaga/main.dart';
import 'package:maxiaga/pages/riwayat.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';


class OrderBensin extends StatefulWidget {
  Position _currentLocation;
  OrderBensin (this._currentLocation);
  @override
  _OrderBensinState createState() => _OrderBensinState();
}

class _OrderBensinState extends State<OrderBensin> {
  GoogleMapController mapController;
  Set<Marker> marker = {};
  bool isLoading;
  SharedPreferences preferences;
  LatLng spbuLocation;

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  Future postOrder() async{
    preferences = await SharedPreferences.getInstance();
    final coordinate = new Coordinates(widget._currentLocation.latitude, widget._currentLocation.longitude);
    var adresses = await Geocoder.local.findAddressesFromCoordinates(coordinate);
    var first = adresses.first;
    var res = await http.post('http://maxiaga.com/backend/api/post_order',body: {
      'token': preferences.getString('token'),
      'id_mx_ms_outlets':'1',
      'address':first.addressLine,
      'detail_address': 'Sint adipisicing esse ea minim excepteur.',
      'lng':widget._currentLocation.longitude.toString(),
      'lat':widget._currentLocation.latitude.toString(),
      'urgent': '1',
    });
    var jsonRes;
      print(first.addressLine); 
    if (res.statusCode == 200) {
      print(spbuLocation);
      return jsonRes = json.decode(res.body);
    } else {
      print(res.body);
      throw Exception('cannot post data');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker.add(
      Marker(
        markerId: MarkerId("User Loaction"),
        position: LatLng(widget._currentLocation.latitude, widget._currentLocation.longitude),
        icon: BitmapDescriptor.defaultMarker,
        // draggable: true,
      ),
    );
  }
  
  void _cameraUpdate() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: spbuLocation,
      zoom: 16,
    )));
  }
  @override
  Widget build(BuildContext context) {
  ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal);
  pr.style(
    progressWidget: CircularProgressIndicator(),
    borderRadius: 10,
    message: "Tunggu Sebentar...",
  );
  
    String teks = 'Order Sekarang';
    return Scaffold(
      appBar: AppBar(
        title: Text('OrderBensin'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          color: Colors.red,
          child: Container(
            height: 60,
            child: Center(
              child: Container(
                // height: 50,
                child: Text(teks, style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ),
          onPressed: (){
            // print('');
              pr.show();
            postOrder().then((value){
              print(value);
              // print(value);
             
               marker.add(
      Marker(
        markerId: MarkerId("User Loaction"),
        position: spbuLocation,
        icon: BitmapDescriptor.defaultMarker,
      )
    );
              print('===========');
              print(spbuLocation);
      setState(() {
    teks = value['api_message'];
                marker.add(
      Marker(
        markerId: MarkerId("User Loaction"),
        position: LatLng(widget._currentLocation.latitude, widget._currentLocation.longitude),
        icon: BitmapDescriptor.defaultMarker,
      )
    );
      });
    print(marker);
              // _cameraUpdate();
              pr.hide();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage(locationNow: widget._currentLocation,spbu: null,index: 2,)), (Route<dynamic> route)=>false);
            });
            print('setelah');
            // if (isLoading == true) {
            // } else {
            //   isLoading = true;
            // }
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget._currentLocation.latitude, widget._currentLocation.longitude),
          zoom: 16,
        ),
        markers: marker,
      ),
    );
  }
}