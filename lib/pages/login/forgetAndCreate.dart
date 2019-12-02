import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/pages/signup/register.dart';

class ButtonCreateForget extends StatelessWidget {
  Position location;
  ButtonCreateForget({this.location});
  @override
  Widget build(BuildContext context) {
    return Container(
                  // width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Lupa Password?"),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text("Buat Akun"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Register(location: location,)));
                        },
                      )
                    ],
                  ),
                );
  }
  }