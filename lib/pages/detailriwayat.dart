import 'package:flutter/material.dart';
import 'package:maxiaga/models/transaksi.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailRiwayat extends StatefulWidget {
  int id;
  String token;
  DetailRiwayat(this.token,this.id);
  @override
  _DetailRiwayatState createState() => _DetailRiwayatState();
}

class _DetailRiwayatState extends State<DetailRiwayat> {

  Future _getDetailsTransaction(int id, String token) async{
    var res = await http.get('http://maxiaga.com/backend/api/get_transaction_detail?id=$id&token=$token');
    var jsonRes;

    if (res.statusCode == 200) {
      print(jsonRes = json.decode(res.body));
      return jsonRes = json.decode(res.body);
    } else {
      throw Exception('Cannot Load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(
          'Pesanan',
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(),
      ),
      // floatingActionButton: Container(
      //   width: double.infinity,
      //   margin: EdgeInsets.symmetric(horizontal: 20),
      //   height: 60,
      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white, border: Border.all(color: Colors.red)),
      //   child: FlatButton(
      //     child: Text('Konfirmasi'),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
        future: _getDetailsTransaction(widget.id, widget.token),
        builder: (context, snapshot){
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'Pesananmu dari : ${snapshot.data['mx_ms_outlets_name']}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      maxLines: 1,
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    child: Text('Akan di antar ke : ${snapshot.data['address']}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 1),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    child: Text('Status : ${snapshot.data['status']}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 1),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    child: Text('jenis : ${snapshot.data['jenis']}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        maxLines: 1),
                    padding: EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(snapshot.data['detail'].length, (i){
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${snapshot.data['detail'][i]['qty']} x', 
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            '${snapshot.data['detail'][i]['name']}', 
                            style: TextStyle(fontSize: 18),
                          ),
                          
                          // Text(
                          //   '${snapshot.data['detail'][i]['price']}',
                          //   style: TextStyle(fontSize: 18),
                          // ),
                          Text(
                            '${snapshot.data['detail'][i]['subtotal']}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      
            Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                    )),
                    Container(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total :',style: TextStyle(fontSize: 18),),
                        Text('${snapshot.data['total']}',style: TextStyle(fontSize: 18),)
                      ],
                    ),padding: EdgeInsets.symmetric(vertical: 5),),
                      Container(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Biaya Pengiriman :',style: TextStyle(fontSize: 18),),
                        Text('${snapshot.data['ship']}',style: TextStyle(fontSize: 18),)
                      ],
                    ),padding: EdgeInsets.symmetric(vertical: 5),),  
                      ],
              ),
                    ],
                  ),
                );
              })
            ),
            
          ],
        ),
      );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        },
      )
    );
  }
}

// SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Container(
//               height: 120,
//               color: Colors.red,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     child: Text(
//                       'Pesananmu dari : ${snapshot.data.mx_ms_outlets_name}',
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                       maxLines: 1,
//                     ),
//                     padding: EdgeInsets.all(10),
//                   ),
//                   Container(
//                     child: Text('Akan di antar ke : ${snapshot.data.address}',
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                         maxLines: 1),
//                     padding: EdgeInsets.all(10),
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         snapshot.data.jenis,
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Text(
//                         '${snapshot.data.total}',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Divider(
//                       color: Colors.black,
//                       thickness: 1,
//                     )),
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal:20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                     Container(child: Text('Total : \t${snapshot.data.total}',style: TextStyle(fontSize: 18),),padding: EdgeInsets.symmetric(vertical: 5),),
//                         Container(child: Text('Biaya Pengiriman : \t${snapshot.data.ship}',style: TextStyle(fontSize: 18),), padding: EdgeInsets.symmetric(vertical: 5),),],
//               ),
//             )
//           ],
//         ),
//       );