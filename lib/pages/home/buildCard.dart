import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:maxiaga/pages/order/oli/oli.dart';
import 'package:maxiaga/pages/order/servis/servis.dart';
import 'package:maxiaga/pages/order/ban/tambalban.dart';
import 'package:maxiaga/service/post/post.dart';
import 'package:maxiaga/pages/order/bensin/orderbensin.dart';

class BuildCard extends StatelessWidget {
  Position location;
  String token;
  
  BuildCard ({this.location, this.token});

  Post post = Post();
    
  @override
  Widget build(BuildContext context) {
    List<Image> _icon = [
      Image.asset('lib/assets/images/servis.png'),
      Image.asset(
        'lib/assets/images/oli.png',
      ),
      Image.asset('lib/assets/images/bensin.png'),
      Image.asset('lib/assets/images/ban.png'),
    ];

    List<Widget> pages = [
      Servis(
        location: location,
        title: 'Servis',
        token: token,
        spbu: post.getSpbu(location, token),
      ),
      Oli(
        location: location,
        title: 'Ganti Oli',
        token: token,
        spbu: null,
      ),
      OrderBensin(location),
      OrderTambalban(location, token)
    ];
    List<String> menu = ["Servis", "Oli", "Bensin", "Ban"];
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
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                      Container(child: Text(menu[index])),
                    ]),
              );
            }),
          ),
        ));
  }
}