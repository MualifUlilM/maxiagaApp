import 'package:flutter/material.dart';

class Pesanan extends StatefulWidget {
  @override
  _PesananState createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pesanan", style:TextStyle(color: Colors.red)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _top(),
          ],
        ),
      ),
    );
  }
  Container _top(){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.red),
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Pesananmu dari : SPBU...", style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),),
          Text("Akan diantar ke : Alamat Anda...", style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),),
          
        ],
      ),
      )
    );
  }
}