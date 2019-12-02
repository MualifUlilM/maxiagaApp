import 'package:flutter/material.dart';
import 'package:maxiaga/service/get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BuildArticle {
  Get get = Get();

  SizedBox buildArticle(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 50),
          child: FutureBuilder(
            future: get.getArticle(),
            builder: (context, snapshot) {
              // print(snapshot.data[1]['title']);
              // print();
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return CarouselSlider(
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  items: List.generate(5, (i) {
                    return Container(
                        height: 300,
                        width: 600,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 2),
                                  color: Colors.grey[300],
                                  blurRadius: 10)
                            ]),
                        child: FlatButton(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${snapshot.data[i]['jetpack_featured_media_url']}'),
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Text(
                                      '${snapshot.data[i]['title']['rendered']}'),
                                )
                              ],
                            ),
                          ),
                          onPressed: () async {
//                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Article("${snapshot.data[i]['title']['rendered']}", "${snapshot.data[i]['jetpack_featured_media_url']}", "${snapshot.data[i]['content']['rendered']}")));
                            if (await canLaunch(
                                '${snapshot.data[i]['link']}')) {
                              await launch('${snapshot.data[i]['link']}');
                            }
                          },
                        ));
                  }),
                );
              } else {
                return Center(
                  child: Text('Loading...'),
                );
              }
            },
          ),
        ));
  }
}
