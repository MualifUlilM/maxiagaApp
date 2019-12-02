import 'dart:convert';
import 'dart:async';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
//import 'package:maxiaga/models/userdata.dart';
import 'package:maxiaga/models/kendaraan.dart';
import 'package:maxiaga/pages/home/home.dart';
import 'package:maxiaga/pages/login/login.dart';
import 'package:maxiaga/pages/history/riwayat.dart';
import 'package:maxiaga/pages/login/loginpage.dart' as prefix0;
import 'package:maxiaga/pages/produk/produk.dart';
import 'package:maxiaga/pages/konsultasi/konsultasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Map<int, Color> color ={
    50:Color.fromRGBO(210,34,34, .1),
    100:Color.fromRGBO(210,34,34, .2),
    200:Color.fromRGBO(210,34,34, .3),
    300:Color.fromRGBO(210,34,34, .4),
    400:Color.fromRGBO(210,34,34, .5),
    500:Color.fromRGBO(210,34,34, .6),
    600:Color.fromRGBO(210,34,34, .7),
    700:Color.fromRGBO(210,34,34, .8),
    800:Color.fromRGBO(210,34,34, .9),
    900:Color.fromRGBO(210,34,34, 1),};


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maxiaga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.red,
        primarySwatch: MaterialColor(0xFFD22222, color), 
        primaryColor: MaterialColor(0xFFD22222, color),
        
      ),
      home:Splash(),
      // routes: routes,
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<SPBU> spbu;
  Position _currentPosition;
  SharedPreferences preferences;
  Geolocator geolocator = Geolocator();

  Future<Position> _getLocation() async{
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  void initState() {
    _getLocation().then((value){
      _currentPosition = value;
    });
      print(_currentPosition);
    // spbu = widget.fetchPost();

    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async{
    preferences = await SharedPreferences.getInstance();
    if (preferences.getString("token") != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage(locationNow: _currentPosition,index: 0,)), (Route<dynamic> route)=>false);
    }else{
      Login(_currentPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: Login(_currentPosition),
//      title: Text("MAXIAGA",
//        style: TextStyle(
//          fontSize: 28,
//          fontWeight: FontWeight.bold,
//          color: Colors.white,
//        ),
//      ),
      image: Image.asset('lib/assets/images/maxiaga_putih.png',),
      photoSize: 120,
      backgroundColor: MaxColor.merah,
      styleTextUnderTheLoader: new TextStyle(),
      // loaderColor: Colors.white,
      // loadingText: Text("Aku Suka Maxiaga ...",style: TextStyle(
      //   color: Colors.white,
      //   fontSize: 20
      // ),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  int index = 0;
  MyHomePage({Key key, this.locationNow, this.spbu, this.index}) : super(key: key);
  Position locationNow;
  final Future<SPBU> spbu;

  Map<String, dynamic> fileContent;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences preferences;
  String _name, _email, _photo, _token,  _phone, _gender, _kota;
  var _kendaraan;
  Geolocator geolocator = Geolocator();
  Position _currentPosition;

  _decodeTodoData(List<String> todos) {
    print('Executed');
    var result = todos.map((v) => json.decode(v)).toList();
    //Transforming the Json into Array<Todo>
    print(result);
    var todObjects = result.map((v) => Kendaraan.fromJson(v)).toList();
    print(result.map);
    return result;
  }


  void _getPreferences()async{
    preferences = await SharedPreferences.getInstance();
    _name = preferences.getString('name');
    _photo = preferences.getString('photo');
    _email = preferences.getString('email');
    _token = preferences.getString('token');
    _kendaraan = _decodeTodoData(preferences.getStringList('kendaraan'));
    _phone = preferences.getString('phone');
    _gender = preferences.getString('gender');
    _kota = preferences.getString('kota');

  }

  @override
  void initState() {
    // TODO: implement initState
    _getPreferences();
    print(_token);
    _getLocation().then((value){
      setState(() {
        _currentPosition = value;
      });
    });
    print('kendaraan $_kendaraan');
    super.initState();
    
  }


Future<Position> _getLocation() async{
  var currentLocation;
  try {
    currentLocation = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  } catch (e) {
  currentLocation = null;
  }
  return currentLocation;
}
  

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
        initialIndex: widget.index,
      child: Scaffold(
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Home(location: _currentPosition,token: _token,name: _name,photo: _photo,email: _email,kendaraan: _kendaraan, kota: _kota, gender: _gender, phone: _phone,),
    Produk( location: _currentPosition,token: _token,),
    Riwayat(_token),
    Konsultasi(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey,
                offset: Offset(0,-0.5),
                blurRadius: 6
              )
            ]
          ),
          padding: EdgeInsets.all(5),
          child: new TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.apps),
              ),
              Tab(
                icon: Icon(Icons.list),
              ),
              Tab(
                icon: Icon(Icons.chat),
              ),
            ],
            unselectedLabelColor: Colors.black,
            labelColor: MaxColor.merah,
            indicatorColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
