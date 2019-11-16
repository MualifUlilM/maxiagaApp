import 'package:flutter/material.dart';
import 'package:maxiaga/models/produk.dart';
import 'package:maxiaga/pages/pesanan.dart';

class SPBUproduk extends StatefulWidget {
  String nama;
  String alamat;
  SpbuProduct data;
  SPBUproduk({Key key, @required this.nama, this.alamat, this.data}) : super(key: key);
  @override
  _SPBUprodukState createState() => _SPBUprodukState();
}

class _SPBUprodukState extends State<SPBUproduk> {
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ini data');
    print(widget.data);
  }
    int number = 0;

  Widget buildNumberIncrement(){
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(padding: EdgeInsets.only(top: 15),child: Text('$number')),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 20,
                child: FlatButton(
                  child: Icon(Icons.keyboard_arrow_up),
                  onPressed: (){
                    setState(() {
                      number++;
                      print(number);
                    });
                  },
                ),
              ),
              Container(
                height: 20,
                child: FlatButton(
                  child: Icon(Icons.keyboard_arrow_down),
                  onPressed: (){
                    setState(() {
                      number--;
                      print(number);
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String name, String description){
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            // Text('Occaecat incididunt ut aliqua reprehenderit dolor. Velit ea quis commodo consectetur sunt officia laboris esse occaecat. Eu eu excepteur amet sunt qui aliqua. Dolore ut veniam non adipisicing fugiat occaecat deserunt eu cupidatat amet magna cillum commodo.', maxLines: 50,),
          ],
        ),
        )
      ),

    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        child: FlatButton(
          // splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Pesanan()));
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Center(
            child: Text("Pesan", 
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              ),),
          ),
        ),
      ),
      padding: EdgeInsets.all(10),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return <Widget> [
            SliverAppBar(
              expandedHeight: 250,
              floating: true,
              // snap: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // centerTitle: true,
                title: Text('${widget.nama}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                // background: Image.asset('lib/assets/images/pic1.png', fit: BoxFit.cover,),
              ),
            )
          ];
        },
        body: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: (100/140),
          children: List.generate(widget.data.data.length, (i){
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(offset: Offset(1, 1), color: Colors.grey, blurRadius: 6)]),
              child: FlatButton(
                child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 70,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Image.network(widget.data.data[i].image, fit: BoxFit.cover,),
                      ),
                      Container(
                        padding: EdgeInsets.only(top:10),
                        child: Text("${widget.data.data[i].name}", maxLines: 1, textAlign: TextAlign.center,),
                      ),
                      // SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Rp.${widget.data.data[i].harga}"),
                      )
                    ],
                  ),
                  onPressed: (){
                    print("${widget.data.data[i].name} is clicked");
                    showAlertDialog(context, widget.data.data[i].name, widget.data.data[i].description);
                  },
              ),
            );
          }),
        ),
      ),
    );
  }
}