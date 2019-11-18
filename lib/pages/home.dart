import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maxiaga/pages/article.dart';
import 'package:maxiaga/pages/orderbensin.dart';
import 'package:maxiaga/pages/profile.dart';
import 'package:maxiaga/pages/riwayat.dart';
import 'package:maxiaga/pages/servis.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:http/http.dart' as http;
import 'package:maxiaga/pages/tambalban.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:flutter_html_view/flutter_html_view.dart';


Future<SPBU_API> _getSpbu(Position location, String token) async {
  var data = await http.get(
      "http://maxiaga.com/backend/api/get_spbu?lng=${location.longitude}&lat=${location.latitude}&token=$token");
  var jsonData = json.decode(data.body);
  print('awal');
  print(jsonData['data']);
  if (data.statusCode == 200) {
    print(data.statusCode);
    print(jsonData);
    return SPBU_API.fromJson(jsonData);
  } else {
    throw Exception('Failed to load daata');
  }
}

class Home extends StatefulWidget {
  String token,name,email,photo, kendaraan, phone, gender, kota;
  Position location;
  Future<SPBU_API> x;
  Home({Key key, @required this.location, this.x, this.token, this.name, this.photo, this.email, this.kendaraan, this.gender, this.kota, this.phone}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var res;
  SharedPreferences preferences;
  String name, email, photo, token, phone, gender, kota;
  List<String> kendaraan;
  @override
  Position _currentPosition;
  Set<Marker> _markers = {};
  GoogleMapController mapController;
  LatLng spbuPoint;
  List<SPBU> spbu;

  Geolocator geolocator = Geolocator();
  Position userLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setPreference() async {
    preferences = await SharedPreferences.getInstance();
    name = preferences.getString('name');
    email = preferences.getString('email');
    photo = preferences.getString('photo');
    // kendaraan = preferences.getStringList('kendaraan');
    token = preferences.getString('token');
    phone = preferences.getString('phone');
    gender = preferences.getString('gender');
    kota = preferences.getString('kota');
  }

  @override
  void initState() {

    super.initState();
    // kendaraan = json.decode(widget.kendaraan['id']);
    _getLocation().then((position) {
      userLocation = position;
      setState(() {
        print(widget.token);
        res = _getSpbu(widget.location == null ? userLocation : widget.location, token);
        print(res);
      });
      print('ini user lokasi $userLocation');

    });
    print('token');
    setPreference();
    print('lokasi dari widget ${widget.location}');
    print('lokasi dari userlocation $userLocation');
    print('lokasi dari widget dari current position $_currentPosition');
//    setState(() {
//      res = _getSpbu(widget.location, widget.token);
//    });
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void _cameraUpdate(LatLng pointSpbu) {
    setState(() {
      spbuPoint = pointSpbu;
    });
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: pointSpbu,
      zoom: 16,
    )));
  }
  

  Widget makeMaps() {
    return FutureBuilder<SPBU_API>(
        future: res,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData == true) {
            if (snapshot.data.api_status == 1 && snapshot.data.data.length > 0) {
              for (var i = snapshot.data.data.length - 1; i >= 0; i--) {
              spbuPoint =
                  LatLng(snapshot.data.data[i].lat, snapshot.data.data[i].long);  
              // print(spbuPoint);
              SPBU spbuData = snapshot.data.data[i];
              print(spbuData.name);
              // spbu.add(spbuData)
              _markers.add(Marker(
                  markerId: MarkerId("${snapshot.data.data[i].name}"),
                  position: spbuPoint,
                  icon: BitmapDescriptor.defaultMarker));
            }
            return GoogleMap(
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    snapshot.data.data[0].lat, snapshot.data.data[0].long),
                zoom: 16.0,
              ),
              markers: _markers,
            );
            } else {
              return Center(
                child: Text('Maaf Kami Tidak Dapat Menemukan Spbu Disekitar anda'),
              );
            };
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrait) {
        return SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constrait.maxHeight),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    _getBackground(),
                    _getCard(),
                  ],
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 30),
                    child: Text(
                      "SPBU Terdekat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      makeMaps(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 80),
                        child: FutureBuilder<SPBU_API>(
                          future: res,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CarouselSlider(
                                onPageChanged: (index) {
                                  setState(() {
                                    spbuPoint = LatLng(
                                        snapshot.data.data[index].lat,
                                        snapshot.data.data[index].long);
                                  });
                                  _cameraUpdate(spbuPoint);
                                },
                                enableInfiniteScroll: false,
                                items: List.generate(
                                    snapshot.data.data.length,
                                    (i) => Container(
                                        height: 50,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 90, 10, 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(2, 3),
                                                    blurRadius: 6),
                                              ]),
                                          child: FlatButton(
                                            child: ListTile(
                                            title: Text(
                                                snapshot.data.data[i].name),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data.data[i].address,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                    "${snapshot.data.data[i].distance} KM"),
                                              ],
                                            ),
                                          ),
                                          onPressed: (){},
                                          ),
                                        ))),
                              );
                            } else {
                              return CarouselSlider(
                                enableInfiniteScroll: false,
                                items: List.generate(
                                    5,
                                    (i) => Container(
                                        height: 50,
                                        margin: EdgeInsets.fromLTRB(10, 70, 10, 20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        )),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Artikel Untuk Anda",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text('EnergiBangsa.id')
                    ],
                  ),
                ),
                buildArticle(context),
              ],
            ),
          ),
        ));
      },
    );
  }
  Future _getArticle()async{
    var res = await http.get('http://energibangsa.id/wp-json/wp/v2/posts?per_page=5');
    var jsonData = json.decode(res.body);

    if (res.statusCode == 200) {
      // print(jsonData);
      return jsonData;
    } else {
      throw Exception('Cannot load data');
    }
  }

  SizedBox buildArticle(BuildContext context) {
    return SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 50),
                    child: FutureBuilder(
                      future: _getArticle(),
                      builder: (context, snapshot){
                          // print(snapshot.data[1]['title']);
                        // print();
                        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                          return CarouselSlider(
                      autoPlay: true,
                      enableInfiniteScroll: true,
                      items: List.generate(5, (i) {
                        return Container(
                            height: 300,
                            width: 600,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(offset: Offset(1, 2), color: Colors.grey[300], blurRadius: 10)]),
                            child: FlatButton(
                              child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height / 6,
                                    width: double.infinity,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),color: Colors.white,image: DecorationImage(image: NetworkImage('${snapshot.data[i]['jetpack_featured_media_url']}'), alignment: Alignment.topCenter, fit: BoxFit.cover)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    height: MediaQuery.of(context).size.height / 10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                    child: Text('${snapshot.data[i]['title']['rendered']}'),
                                  )
                                ],
                              ),
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Article("${snapshot.data[i]['title']['rendered']}", "${snapshot.data[i]['jetpack_featured_media_url']}", "${snapshot.data[i]['content']['rendered']}")));
                            },
                            )
                          );
                      }),
                    );
                        } else {
                          return Center(child: Text('Loading...'),);
                        }
                      },
                    ),
                  ));
  }


  Container _getBackground() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width / 20,
        MediaQuery.of(context).size.height / 10,
        MediaQuery.of(context).size.width / 20,
        MediaQuery.of(context).size.height / 6,
      ),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(color: Colors.red),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "MAXIAGA",
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
          FlatButton(
            onPressed: () {
              print(widget.email);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(widget.location, widget.email, widget.name, widget.photo, widget.token, widget.gender, widget.kota, widget.phone)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hello...",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      "${widget.name}",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/avatar.png'),
                  // backgroundImage: widget.photo.isEmpty?AssetImage('lib/assets/images/avatar.png'):NetworkImage(widget.photo) ,
                  radius: MediaQuery.of(context).size.width / 10,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _getCard() {
    List<Image> _icon = [
      Image.asset('lib/assets/images/servis.png'),
      Image.asset('lib/assets/images/aki.png'),
      Image.asset('lib/assets/images/oli.png'),
      Image.asset('lib/assets/images/ban.png'),
    ];

    List<Widget> pages = [
      Servis(
        location: widget.location,
        title: 'Servis',
        token: widget.token,
        spbu: res,
      ),
      Servis(
        location: widget.location,
        title: 'Servis',
      ),
      OrderBensin(widget.location),
      OrderTambalban(widget.location, widget.token)

    ];

    List<String> menu = ["Servis", "Aki", "Bensin", "Ban"];

    return Container(
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width / 20,
            MediaQuery.of(context).size.height / 2.5,
            MediaQuery.of(context).size.width / 20,
            0),
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 2.0), blurRadius: 6)
            ]),
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                children: List.generate(4, (index) {
                  return Container(
                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: _icon[index],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => pages[index]));
                            },
                          ),
                          Container(
                              child: Text(menu[index])),
                        ]),
                  );
                }),
              ),
            )));
  }
}

