import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maxiaga/assets/fonts/font/exicon.dart';

class ExternalLogin extends StatelessWidget {
  final String google = '/lib/assets/images/google-brands.svg';
  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Image.asset('lib/assets/images/googlered.png',)
                          // child: Icon(ExIcon.google, color: Colors.red,),
                        ),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Image.asset('lib/assets/images/fbred.png'),
                        ),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          // child: Icon(ExIcon.twitter, color: Colors.red,),
                          child: Image.asset('lib/assets/images/tweetred.png'),
                        ),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ],
                  ),
                );
  }
}