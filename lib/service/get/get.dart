import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:maxiaga/models/transaksi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:maxiaga/models/produk.dart';

class Get{
  String url = 'http://maxiaga.com/backend/api';
  Geolocator geolocator;

  Future<Get_Transaksi> getRiwayat(String token)async{
    var res = await http.get('$url/get_transaction?token=$token');
    var jsonData = json.decode(res.body);

    if (res.statusCode == 200) {
      print(jsonData);
      print('ini setelah data');
      return Get_Transaksi.fromJson(jsonData);
    } else {
      throw Exception('cannot load data');
    }
  }

  Future getDetailsTransaction(int id, String token) async{
    var res = await http.get('http://maxiaga.com/backend/api/get_transaction_detail?id=$id&token=$token');
    var jsonRes;

    if (res.statusCode == 200) {
      print(jsonRes = json.decode(res.body));
      return jsonRes = json.decode(res.body);
    } else {
      throw Exception('Cannot Load Data');
    }
  }

  Future<SPBU_API> getSpbu(Position location, String token) async {
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

  Future<Position> getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future getArticle()async{
    var res = await http.get('http://energibangsa.id/wp-json/wp/v2/posts?per_page=5');
    var jsonData = json.decode(res.body);

    if (res.statusCode == 200) {
      // print(jsonData);
      return jsonData;
    } else {
      throw Exception('Cannot load data');
    }
  }

  Future<SpbuProduct> getProduct(int id, String token) async {
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

}