import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart' as prefix0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/main.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:maxiaga/pages/Maps.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxiaga/service/post/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:geocoder/geocoder.dart';
import 'package:maxiaga/models/kendaraan.dart';

class Servis extends StatefulWidget {
  Position location;
  var spbu;
  var kendaraan;
  String title, token;
  Servis({
    Key key,
    @required this.location,
    @required this.title,
    this.token,
    this.spbu,
    this.kendaraan,
  }) : super(key: key);

  @override
  _ServisState createState() => _ServisState();
}

class _ServisState extends State<Servis> {
  String _valueSelected = 'Pilih SPBU';
  List<DropdownMenuItem<SPBU>> spbuItems;
  SPBU selectedSpbu;
  File file;
  SharedPreferences preferences;
  Post post = Post();
  var kendaraan;
  Dio dio = new Dio();
  List _kendaraan;
  String type;

  List<DropdownMenuItem<SPBU>> buildDropdownMenuItems(List spbus) {
    List<DropdownMenuItem<SPBU>> items = List();
    for (SPBU spbus in spbus) {
      items.add(
        DropdownMenuItem(
          value: spbus,
          child: Text(spbus.name),
        ),
      );
    }
    return items;
  }

  String urlPhoto;
  postImage(File image, String token) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path,
          filename: basename(image.path)),
      'token': token,
    });
    var res = await dio.post(
        'http://maxiaga.com/backend/api/upload_photo_service',
        data: formData);

    if (res.statusCode == 200) {
      print(res.data);
      print(res.data['file']);
      setState(() {
        urlPhoto = res.data['file'];
        print(urlPhoto);
      });
    } else {
      throw Exception('cannot load data');
    }
  }

  _setPref() async {
    preferences = await SharedPreferences.getInstance();
    kendaraan = _decodeTodoData(preferences.getStringList('kendaraan'));
    print('ini brand ${kendaraan[0]['brand']}');
  }

  _decodeTodoData(List<String> todos) {
    print('Executed');
    var result = todos.map((v) => json.decode(v)).toList();
    //Transforming the Json into Array<Todo>
    print(result);
    var todObjects = result.map((v) => Kendaraan.fromJson(v));
    print('init result ${result[0]['brand']}');
    return result.asMap();
  }

  postService(
    Position posisi,
    String add_detail,
    String complaint,
    String photoUrl,
    String token,
    String type,
    int id,
    BuildContext context,
  ) async {
    print('executrd');
    // int type1 = int.parse(type);
    Coordinates coordinates = Coordinates(posisi.latitude, posisi.longitude);
    var adresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = adresses.first;
    print(token);
    print(photoUrl);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Tunggu Sebentar...')
                    ],
                  )));
        });
    FormData formData = FormData.fromMap({
      "id_mx_ms_category_service": 1,
      "id_mx_tb_kendaraan": int.parse(type),
      "id_mx_ms_outlets": id,
      "address": "$add_detail",
      "detail_address": "${first.addressLine}",
      "lng": "${posisi.longitude}",
      "lat": "${posisi.latitude}",
      "complaint": "$complaint",
      "photo": ["$photoUrl"],
      "token": "$token"
    });
    var res = await dio.post('http://maxiaga.com/backend/api/post_order',
        data: formData);
    print('executed');
    print(res.statusCode);
    print(res);
    if (res.statusCode == 200) {
      print(res);
      if (res.data['api_status'] == 1 || res.data['api_status'] == '1') {
        Navigator.of(context, rootNavigator: true).pop;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(
                      locationNow: posisi,
                      spbu: null,
                      index: 2,
                    )),
            (Route<dynamic> route) => false);
      }
    } else {
      throw Exception('cannot post data');
    }
  }

  @override
  void initState() {
    // spbuItems = buildDropdownMenuItems(widget.spbu);
    // selectedSpbu = spbuItems[0].value;
    super.initState();
    _setPref();
    print(widget.spbu);
    print('asdasd');
    // print(widget.spbu[1].address);
  }

  void onChangeValue(SPBU spbuPilih) {
    setState(() {
      selectedSpbu = spbuPilih;
    });
  }

  File _image;

  Future getImage() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 78);
    print("before compress " + image.lengthSync().toString());
    setState(() {
      _image = image;
      print(_image);
    });
    postImage(_image, widget.token);
  }

  // void _postImage() async {
  //   var res = http.po
  // }

  Widget buildImage(File file) {
    if (file == null) {
      return Center(
        child: Text('add image'),
      );
    } else {
      // postImage(_image, widget.token);
      return Image.file(file);
    }
  }

  String valueSelected = "Pilih SPBU";
  String kendaraaneSelected = "Pilih Kendaraan";
  TextEditingController _addController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  int idoutlets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              FlatButton(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3)),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[Text("Lokasi"), Icon(Icons.location_on)],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Maps(
                                location: widget.location,
                              )));
                },
              ),
              Container(
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                width: double.infinity,
                child: FutureBuilder<SPBU_API>(
                  future: post.getSpbu(widget.location, widget.token),
                  builder: (context, snapshot) {
//                     valueSelected = snapshot.data.data[0].name;
                    print(valueSelected);
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      List<String> spbu = [
                        'Pilih spbu',
                      ];
                      List<String> kendaraanlist = [];

                      // valueSelected = 'SPBU';
                      // print(_valueSelected);
                      for (var i = 0; i < kendaraan.length; i++) {
                        kendaraanlist.add(kendaraan[i]['brand']);
                      }
                      for (var i = 0; i < snapshot.data.data.length; i++) {
                        if (snapshot.data.data[i].is_service == 1) {
                          spbu.add(snapshot.data.data[i].name);
                        }
                        print(spbu.length);
                      }
                      return Column(
                        children: <Widget>[
                          DropdownButton<String>(
                            isExpanded: true,
                            // value: valueSelected,
                            hint: Text(valueSelected),
                            onChanged: (val) {
                              setState(() {
                                print('Executed');
                                valueSelected = val;
                                for (var i = 0;
                                    i < snapshot.data.data.length;
                                    i++) {
                                  if (valueSelected ==
                                      snapshot.data.data[i].name) {
                                    idoutlets = snapshot.data.data[i].id;
                                  }
                                }
                                print(valueSelected);
                              });
                            },
                            items: spbu.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            // value: valueSelected,
                            hint: Text(kendaraaneSelected),
                            onChanged: (val) {
                              setState(() {
                                print('Executed');
                                kendaraaneSelected = val;
                                for (var i = 0; i < kendaraan.length; i++) {
                                  if (kendaraaneSelected ==
                                      kendaraan[i]['brand']) {
                                    type = kendaraan[i]['type'];
                                    print('tipe kendaraan $type');
                                  }
                                }
                                print(kendaraaneSelected);
                              });
                            },
                            items: kendaraanlist
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    } else {
                      print('else executed');
                      print(snapshot.hasError);
                      print(snapshot.error);
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.grey[300]),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(15),
                child: TextField(
                  controller: _addController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.grey[300],
                    hintText: 'Alamat Detail',
                  ),
                ),
              ),
              Container(
                height: 130,
                decoration: BoxDecoration(color: Colors.grey[300]),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: TextField(
                  maxLines: 100,
                  controller: complaintController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.grey[300],
                    hintText: 'Keluhan',
                  ),
                ),
              ),
              Text("Tambah Gambar"),
              Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(3)),
                      child: Center(child: buildImage(_image))),
                  FlatButton(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        )),
                    onPressed: () {
                      getImage();
                      print(urlPhoto);
                    },
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                height: 60,
                // width: 120,
                decoration: BoxDecoration(
                    color: MaxColor.merah, borderRadius: BorderRadius.circular(3)),
                child: FlatButton(
                  child: Center(
                    child: Text("Kirim",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  onPressed: () => postService(
                      widget.location,
                      _addController.text,
                      complaintController.text,
                      urlPhoto,
                      widget.token,
                      type,
                      idoutlets,
                      context),
                ),
              ),
            ],
          )),
        ));
  }
}
