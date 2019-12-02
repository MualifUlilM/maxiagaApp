import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maxiaga/pages/konsultasi/konsultasi_detail.dart';
import 'package:maxiaga/pages/history/riwayat.dart';
import 'package:maxiaga/pages/konsultasi/tambahKonsultasi.dart';

class Konsultasi extends StatefulWidget {
  @override
  _KonsultasiState createState() => _KonsultasiState();
}

class _KonsultasiState extends State<Konsultasi> {
  
  List<String> user = [
    "Pakar 1",
    "Pakar 2",
    "Pakar 3",
    "Pakar 4",
  ];
  List<String> chat = [
    "Konsultasi 1",
    "Konsultasi 2",
    "Konsultasi 3",
    "Konsultasi 4",
  ];

  int indexColor = 0;

  List<Color> warna = [
    Colors.blue,
    Colors.red,
    Colors.black,
  ];

  void changeColor(int index){
    setState(() {
      indexColor = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Image.asset('lib/assets/images/maxiaga_putih.png', scale: 20,),
            centerTitle: true,
            elevation: 0.0,
//            backgroundColor: Colors.white,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>TambahKonsultasi()));},
          ),
          body:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12),
                child: Text("Konsultasi",
                  style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
//          SizedBox(height: 20,),
              Container(
                  height: 50,
                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(9)),
                  margin: EdgeInsets.all(20),
                  child: Theme(
                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                    child: TextField(
                      autofocus: false,
                      style: TextStyle(fontSize: 22.0, color: Colors.grey[200]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Cari Pesan',
                        contentPadding:
                        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  )
              ),
              Flexible(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: user.length,
                    itemBuilder: (BuildContext context, int index){
                      return FlatButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>KonsultasiDetail()));
                      },
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(user[index]),
                              subtitle: Text(chat[index]),
                              trailing: Icon(Icons.check, color: Colors.blue[900],),
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                backgroundImage: AssetImage('lib/assets/images/avatar.png'),
                                radius: 30,
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Center(
          child: Container(
            height: double.infinity,
//            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), ),
            child: Center(child: Text('Coming Soon', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 28),),),
          ),
        )
      ],
    );
  }
}
