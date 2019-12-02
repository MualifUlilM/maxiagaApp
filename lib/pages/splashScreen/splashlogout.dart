import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:maxiaga/pages/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:maxiaga/assets/maxcolor.dart';



class SplashLogout extends StatefulWidget {
  String token;
  SplashLogout(@required this.token);
  @override
  _SplashLogoutState createState() => _SplashLogoutState();
}

class _SplashLogoutState extends State<SplashLogout> {
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
    // spbu = widget.fetchPost();
          // checkLoginStatus();
    super.initState();
    // logoutPost(widget.token);
  }

  // logoutPost(String token)async{
  //   var res = await http.post('http://maxiaga.com/backend/api/post_logout',body :{
  //     'token':token,
  //   } );
  //   var jsonRes = json.decode(res.body);
  //   if (res.statusCode == 200 && jsonRes['api_status'] == true) {
  //     print(jsonRes['api_status']);
  //                     preferences = await SharedPreferences.getInstance() ;
  //               preferences.clear();
  //               preferences.commit();
  //   }else{
  //     throw Exception('cannot post logout');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: Login(_currentPosition),
      title: Text("MAXIAGA",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: MaxColor.merah,
      styleTextUnderTheLoader: new TextStyle(),
    );
  }
}