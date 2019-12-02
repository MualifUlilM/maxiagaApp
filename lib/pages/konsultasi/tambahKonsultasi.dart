import 'package:flutter/material.dart';

class TambahKonsultasi extends StatefulWidget {
  @override
  _TambahKonsultasiState createState() => _TambahKonsultasiState();
}

class _TambahKonsultasiState extends State<TambahKonsultasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Konsultasi"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.grey[300]),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(15),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey[300],
                  hintText: 'Keterangan',
                ),
              ),
            ),
            Container(
              height: 130,
              decoration: BoxDecoration(color: Colors.grey[300]),
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(left:15, right: 15, bottom: 10),
              child: TextField(
                maxLines: 100,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.grey[300],
                  hintText: 'Keluhan',
                ),
              ),
            ),
            Text("Tambah Gambar"),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                  child: Center(child: Icon(Icons.add_a_photo, color: Colors.white,),)
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
                  child: Center(child: Icon(Icons.add_a_photo, color: Colors.white,),)
                ),
                
              ],
            ),
            Container(
                  margin: EdgeInsets.only(top: 120, bottom: 20),
                  height: 60,
                  // width: 120,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(3)),
                  child: Center(child: Text("Kirim", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white)),),
                ),
          ],
        ),
      ));
  }
}
