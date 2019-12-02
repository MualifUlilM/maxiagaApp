import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/pages/home/buildImage.dart';
import 'package:maxiaga/pages/profile/profile.dart';
class Background{
ImageBuild img = ImageBuild();


  Container getBackground(
    BuildContext context,
    Position location,
    String email,
    String name,
    String photo,
    String token,
    String gender,
    String kota,
    String phone,
    var kendaraan,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width / 20,
        MediaQuery.of(context).size.height / 10,
        MediaQuery.of(context).size.width / 20,
        MediaQuery.of(context).size.height / 6,
      ),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(color: Color(0xFFD22222)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
//          Text(
//            "MAXIAGA",
//            style: TextStyle(fontSize: 28, color: Colors.white),
//          ),
        Container(
          height: 50,

          child: Image.asset('lib/assets/images/maxiaga_putih.png',),
        ),
          FlatButton(
            onPressed: () {
              print(email);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(location, email, name, photo, token, gender, kota, phone, kendaraan)));
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
                    name == null ? Text('')
                    : Text(
                      "${name}",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: img.buildImg(photo),
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
}