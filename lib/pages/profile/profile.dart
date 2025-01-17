import 'package:expandable_card/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/models/kendaraan.dart';
import 'package:maxiaga/pages/profile/editprofile.dart';
import 'package:maxiaga/pages/profile/tambahkendaraan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maxiaga/pages/login/login.dart';
import '../splashScreen/splashlogout.dart';
import 'dart:convert';



class Profile extends StatefulWidget {
  Position location;
  String name, email, photo, token, phone, gender, kota;
  var kendaraan;
  Profile(this.location, this.email, this.name, this.photo, @required this.token, this.gender, this.kota, this.phone, this.kendaraan);
  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
  SharedPreferences preferences;

  var _kendaraan;
  String _name, _email, _photo, _gender, _kota, _phone;

  void setPreference() async {
     preferences = await SharedPreferences.getInstance();
     setState(() {
       _kendaraan = _decodeTodoData(preferences.getStringList('kendaraan'));
       _name = preferences.getString('name');
       _email = preferences.getString('email');
       _gender = preferences.getString('gender');
       _kota = preferences.getString('kota');
       _phone = preferences.getString('phone');
       _photo = preferences.getString('photo');
     });
    // name = preferences.getString('name');
    // email = preferences.getString('email');
    print(_phone);
    print(_photo);

  }

  @override
  void initState(){
    // TODO: implement initState
    print('Executed');
    super.initState();
    setPreference();
    print('ini kendaraan $_kendaraan');
//    print(widget.kendaraan);
  }

  _decodeTodoData(List<String> todos) {
    print('Executed');
    var result = todos.map((v) => json.decode(v)).toList();
    //Transforming the Json into Array<Todo>
    print(result);
    var todObjects = result.map((v) => Kendaraan.fromJson(v));
    print(result);
    return result.asMap();
  }


  Widget _buildListKendaraan(){
   return Container();

  }

  
  @override
  Widget build(BuildContext context) {
    List kendaraan = [
      'Supra',
      'Brio',
      'Vario',
    ];

    List<Image> iconKendaraan = [
      Image.asset('lib/assets/images/motorputih.png',scale: 3,),
      Image.asset('lib/assets/images/mobilputih.png',scale: 3,),
      Image.asset('lib/assets/images/motorputih.png',scale: 3,),
      
    ];
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: MaxColor.merah,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            width: 60,
            // margin: EdgeInsets.only(right: 20),
            child: RaisedButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.transparent,
              elevation: 0,
              child: Center(child: Icon(Icons.edit, color: Colors.white,)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile(location: widget.location,)));
              },
            ),
          ),
          Container(
            width: 60,
            // margin: EdgeInsets.only(right: 40),
            child: RaisedButton(
              color: Colors.transparent,
              elevation: 0.0,
              // splashColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              child: Center(child: Icon(Icons.exit_to_app, color: Colors.white,),),
              onPressed: (){
                // preferences = await SharedPreferences.getInstance() ;
                // preferences.clear();
                // preferences.commit();
                // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login(widget.location)), (Route<dynamic> route) => false);
                return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Anda Yakin Ingin Keluar?'),
              // Text('You\’re like me. I’m never satisfied.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ya'),
            onPressed: () async{
              preferences = await SharedPreferences.getInstance() ;
                preferences.clear();
                preferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SplashLogout(widget.token)), (Route<dynamic> route) => false);
            },
          ),
          FlatButton(
            child: Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
              },
            ),
          ),
          // Icon(Icons.edit),
          // Icon(Icons.exit_to_app)
        ],
        ),
      body: ExpandableCardPage(
        expandableCard: ExpandableCard(
        hasRoundedCorners: true,
        minHeight: 185,
        backgroundColor: MaxColor.merah,
        maxHeight: MediaQuery.of(context).size.height,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Kendaraan",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24
              ),),
              Container(
                height: 40,
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: FlatButton(
                  child: Row(
                    children: <Widget>[
                      Text("Tambah",style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18
              )),
                      Icon(Icons.add, color: Colors.red,)
                    ],
                  ),
                  onPressed: (){
                    print(_kendaraan);
                    setPreference();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TambahKendaraan(token: widget.token,location: widget.location,)));
                  },
                ),
              ),
            ],
          ),
          ),
          Container(
            // margin : EdgeInsets.only(bottom: 50),
            child: Expanded(
              child: ListView.separated(
                  itemBuilder: (context, int index){
                    return FlatButton(onPressed:null,
                        child: ListTile(
                          leading: _kendaraan[index]['type'] == '1'? Image.asset('lib/assets/images/motorputih.png',scale: 3,) : Image.asset('lib/assets/images/mobilputih.png',scale: 3,),
                          title: Text('${_kendaraan[index]['brand']}', style: TextStyle(color: Colors.white, fontSize: 20),),
                        ));
                  },
                  separatorBuilder: (context, index)=>Divider(color: Colors.white,),
                  itemCount: _kendaraan.length),
          ),
          )
        ],
      ),
      page: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        // physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MaxColor.merah),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    // backgroundImage: AssetImage('lib/assets/images/avatar.png'),
                    backgroundImage: NetworkImage(_photo),
                    radius: 50,
                    backgroundColor: Colors.transparent,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Text("${_name}", style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Container(
                    child: Text("${_email}", style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),),
                  ),
                ],
              ),
            ),
            Container(
              height: 600,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Kota", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top:5),
                      child: Text("${_kota}", style: TextStyle(
                        fontSize: 16
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Telepon", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top:5),
                      child:_phone != null ? Text("${_phone}", style: TextStyle(
                        fontSize: 18
                      ),) : Text("-", style: TextStyle(
                fontSize: 18
            ),),
                    ),
                    // RaisedButton(
                    //   child: Text("Log Out"),
                    //   onPressed: (){
                    //     preferences.clear()
                    //   },
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      )
      ),
      );
  }
}
