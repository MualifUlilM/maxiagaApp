import 'package:flutter/material.dart';

class KonsultasiDetail extends StatefulWidget {
  @override
  _KonsultasiDetailState createState() => _KonsultasiDetailState();
}

class _KonsultasiDetailState extends State<KonsultasiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konsultasi Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              
            ],
          ),
        ),
      ),
    );
  }
}
