import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:maxiaga/models/spbu.dart';


class Post{
  String url = 'http://maxiaga.com/backend/api';
  SharedPreferences preferences;

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

  Future postOrder(Position currentLocation) async{
    preferences = await SharedPreferences.getInstance();
    final coordinate = new Coordinates(currentLocation.latitude, currentLocation.longitude);
    var adresses = await Geocoder.local.findAddressesFromCoordinates(coordinate);
    var first = adresses.first;
    var res = await http.post('http://maxiaga.com/backend/api/post_order',body: {
      'token': preferences.getString('token'),
      'id_mx_ms_outlets':'1',
      'address':first.addressLine,
      'detail_address': 'Sint adipisicing esse ea minim excepteur.',
      'lng':currentLocation.longitude.toString(),
      'lat':currentLocation.latitude.toString(),
      'urgent': '1',
    });
    var jsonRes;
    print(first.addressLine);
    if (res.statusCode == 200) {
      return jsonRes = json.decode(res.body);
    } else {
      print(res.body);
      throw Exception('cannot post data');
    }
  }

  Future postOrderBan(int id, String token, Position location) async{
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


}