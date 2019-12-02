import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/main.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:maxiaga/pages/login/login.dart';
import 'package:http/http.dart' as http;



class SplashLogin extends StatefulWidget {
  String token;
  SplashLogin(@required this.token);
  @override
  _SplashLogState createState() => _SplashLogState();
}

class _SplashLogState extends State<SplashLogin> {
  Future<SPBU> spbu;
  Position _currentPosition;
  SharedPreferences preferences;

  @override
  void initState() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position){
        setState(() {
          _currentPosition = position;
          print(_currentPosition);
        });
      }).catchError((e){
        print(e);
      });
      print(_currentPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MyHomePage(locationNow: _currentPosition,index: 0,),
      backgroundColor: MaxColor.merah,
      styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.white,
      // loadingText: Text("Aku Suka Maxiaga ...",style: TextStyle(
      //   color: Colors.white,
      //   fontSize: 20
      // ),),
    );
  }
}