import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maxiaga/models/transaksi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:maxiaga/pages/history/detailriwayat.dart';

class Riwayat extends StatefulWidget {
  String token;
  Riwayat(this.token);
  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<String> user = [
    "User 1",
    "User 2",
    "User 3",
    "User 4",
    "User 1",
    "User 2",
    "User 3",
    "User 4",
    "User 1",
    "User 2",
    "User 3",
    "User 4",
  ];
  List<String> tipe = [
    "Motor",
    "Mobil",
    "Mobil",
    "Motor",
    "Motor",
    "Mobil",
    "Mobil",
    "Motor",
    "Motor",
    "Mobil",
    "Mobil",
    "Motor",
  ];
  List<String> harga = [
    "20000",
    "250000",
    "10000",
    "7000",
    "20000",
    "250000",
    "10000",
    "7000",
    "20000",
    "250000",
    "10000",
    "7000",
  ];
  List<String> tanggal = [
    "10 sep",
    "22 sep",
    "1 okt",
    "6 okt",
    "10 sep",
    "22 sep",
    "1 okt",
    "6 okt",
    "10 sep",
    "22 sep",
    "1 okt",
    "6 okt",
  ];
  List<Icon> icon = [];

  Color warna(int index) {
    if (tipe[index] == 'motor' || tipe[index] == 'Motor') {
      return Colors.red;
    } else {
      return Colors.blue[600];
    }
  }

  Image setKendaraan(int index) {
    if (tipe[index] == 'motor' || tipe[index] == 'Motor') {
      return Image.asset(
        'lib/assets/images/motor.png',
      );
    } else {
      return Image.asset(
        'lib/assets/images/mobil.png',
      );
    }
  }

  _getRiwayat(String token) async {
    var res = await http
        .get('http://maxiaga.com/backend/api/get_transaction?token=$token');
    var jsonData = json.decode(res.body);

    if (res.statusCode == 200) {
      print(jsonData);
      // print(jsonData['data'][0]);
      // print(jsonData['data'][1]);
      // print(jsonData['data'][2]);
      print('ini setelah data');
      return jsonData;
    } else {
      throw Exception('cannot load data');
    }
  }

  _buildTransaction(int id) {
    if (id == 1) {
      return Image.asset(
        'lib/assets/images/servis.png',
        scale: 4,
      );
    } else if (id == 2) {
      return Container(
        padding: EdgeInsets.only(left: 5),
        child: Image.asset(
          'lib/assets/images/oli.png',
          scale: 3,
        ),
      );
    } else if (id == 3) {
      return Image.asset(
        'lib/assets/images/bensin.png',
        scale: 3,
      );
    } else if (id == 4) {
      return Image.asset(
        'lib/assets/images/ban.png',
        scale: 3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'lib/assets/images/maxiaga_putih.png',
            scale: 20,
          ),
          centerTitle: true,
          elevation: 0.0,
//          backgroundColor: Colors.white,
        ),
        body: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Riwayat",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: FutureBuilder(
                future: _getRiwayat(widget.token),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    if (snapshot.data['data'].length > 0) {
                      return SingleChildScrollView(
                    child: Column(
                      children:
                          List.generate(snapshot.data['data'].length, (i) {
                        return FlatButton(
                          child: Card(
                            // color: Colors.red,
                            child: ListTile(
                              leading: _buildTransaction(snapshot.data['data']
                                  [i]['id_mx_ms_category_service']),
                              title: snapshot.data['data'][i]
                                          ['mx_ms_outlets_name'] !=
                                      null
                                  ? Text(
                                      snapshot.data['data'][i]
                                              ['mx_ms_outlets_name']
                                          .toString(),
                                      maxLines: 1,
                                    )
                                  : Text('Menunggu'),
                              subtitle:
                                  Text(snapshot.data['data'][i]['status']),
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailRiwayat(widget.token, snapshot.data['data'][i]['id'])));
                          },
                        );
                      }),
                    ),
                  );
                    } else {
                      return Center(
                        child: Text('Maaf Anda Belum Memiliki Transaksi Apapun',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

// Card(
//                             child: FlatButton(
//                               child: ListTile(
//                             title: snapshot.data['data'][i].mx_ms_outlets_name != null ? Text(snapshot.data['data'][i].mx_ms_outlets_name.toString(), maxLines: 1,):Text('Menunggu'),
//                             subtitle: Text(snapshot.data['data'][i].status, maxLines: 1,),
//                             leading: Container(
//                               // color: Colors.red,
//                               width: 50,
//                               height: 50,
//                               padding: EdgeInsets.all(10),
//                               child: Image.asset('lib/assets/images/servis.png', fit: BoxFit.cover,),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 // color: Colors.red,
//                                 border: Border.all(color: Colors.red)
//                               ),
//                             )
//                           ),
//                           onPressed: (){
//                             // print(snapshot.data.data[i].address);
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailRiwayat(widget.token,snapshot.data['data'][i].id)));
//                           },
//                             ),
//                           );
