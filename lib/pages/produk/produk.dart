import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/models/produk.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:http/http.dart' as http;


import 'package:maxiaga/pages/Maps.dart';
import 'package:maxiaga/pages/history/riwayat.dart';
import 'package:maxiaga/pages/produk/spbuproduk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Produk extends StatefulWidget {
  Position location;
  String token;
  
  Produk({Key key, @required this.location,this.token}) : super(key: key);

  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {  

  String base_url = 'http://maxiaga.com/backend/api/';
  SharedPreferences preferences;
  String _token;

  Future<SPBU_API> _getSpbu() async {
    var data = await http.get("${base_url}get_spbu?lng=${widget.location.longitude}&lat=${widget.location.latitude}&token=${widget.token}");
    var jsonData = json.decode(data.body);
    print(data.statusCode);
    if(data.statusCode == 200){
      print(jsonData);
      return SPBU_API.fromJson(jsonData);
    }else{
      throw Exception('Failed to load daata');
    }
  }

  Future<SpbuProduct> _getProduct(int id, String token) async {
    var data = await http.get('http://maxiaga.com/backend/api/get_product?id_mx_ms_outlets=$id&token=$token');

    var jsonData = json.decode(data.body);
    print(token);
      print(jsonData);
    if (data.statusCode == 200) {
      return SpbuProduct.fromJson(jsonData);
    } else {
      print(jsonData['api_status']);
      throw Exception('failed to load data');
    }
  }

  void _getPreference() async{
    preferences = await SharedPreferences.getInstance();
    _token = preferences.getString('token');
    
  }

  @override
  void initState() {
    _getPreference();
    // _getSpbu(_token);
    // print(w)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('lib/assets/images/maxiaga_putih.png', scale: 20,),

        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Colors.,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              child: Text("Produk",
                style: TextStyle(fontSize: 25,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10),
              child: Text("Tempat terdekat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),),
            ),
            ScrollConfiguration(behavior: MyBehavior(),
                  child: FutureBuilder<SPBU_API>(
                    future: _getSpbu(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Column(
                          children: List.generate(snapshot.data.data.length, (i)=>Card(
                            child: FlatButton(
                              child: ListTile(
                              title: Text(snapshot.data.data[i].name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(snapshot.data.data[i].address, maxLines: 1,),
                                  SizedBox(height: 5,),
                                  Text("${snapshot.data.data[i].distance}", maxLines: 1,),
                                ],
                              ),
                            ),
                            onPressed: (){
                              print(snapshot.data.data[i].id);
                              _getProduct(snapshot.data.data[i].id, _token).then((value){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SPBUproduk(nama: '${snapshot.data.data[i].name}',alamat: snapshot.data.data[i].address,data: value)));
                              });
                            },
                            )
                          ))
                        );
                      }else{
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
            )
          ],
        ),
      ),
      )
    );
  }
}
