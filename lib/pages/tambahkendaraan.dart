import 'package:flutter/material.dart';

class TambahKendaraan extends StatefulWidget {
  @override
  _TambahKendaraanState createState() => _TambahKendaraanState();
}

class _TambahKendaraanState extends State<TambahKendaraan> {

  Color color1 = Colors.red;
  Color color2 = Colors.grey[300];
  String valueKendaraan;
  Image imageMotor = Image.asset('lib/assets/images/motorputih.png', scale: 2,);
  Image imageMobil = Image.asset('lib/assets/images/mobil.png', scale: 2,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah', style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Pilih Kendaraan", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: FlatButton(
                      child: imageMotor,
                      onPressed: (){
                        setState(() {
                          color2 = Colors.grey[300];
                          imageMobil = Image.asset('lib/assets/images/mobil.png', scale: 2,);
                          color1 = Colors.red;
                          imageMotor = Image.asset('lib/assets/images/motorputih.png', scale: 2,);
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: FlatButton(
                      child: imageMobil,
                      onPressed: (){
                        setState(() {
                          color2 = Colors.red;
                          imageMobil = Image.asset('lib/assets/images/mobilputih.png', scale: 2,);
                          color1 = Colors.grey[300];
                          imageMotor = Image.asset('lib/assets/images/motor.png', scale: 2,);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Text("Nama Kendaraan", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "ex: Honda Beat"
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text("Tahun Kendaraan", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "ex: 2019"
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9)
              ),
              child: Center(
                child: Text("TAMBAH", style:TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
        )
      ),
    );
  }
}