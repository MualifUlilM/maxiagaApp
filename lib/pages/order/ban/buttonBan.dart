import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/service/post/post.dart';
import 'package:maxiaga/main.dart';

class ButtonBan{
  Post post = Post();
  RaisedButton buildButtonBan(
    BuildContext context,
    int order,
    Position location,
    String token,
    String text,
    ) {
    return RaisedButton(
          color: MaxColor.merah,
          child: Container(
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 2.6,
              child: Center(
                  child: Text(
                '$text',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ))),
          onPressed: () {
            post.postOrderBan(order,token, location).then((value){
              Navigator.of(context)
              .pushAndRemoveUntil(MaterialPageRoute
              (builder: (BuildContext context)=>MyHomePage(locationNow: location,spbu: null,index: 2,)),
               (Route<dynamic> route)=>false);
            });
          },
        );
      }
}