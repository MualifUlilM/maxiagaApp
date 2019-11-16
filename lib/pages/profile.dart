import 'package:expandable_card/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/pages/editprofile.dart';
import 'package:maxiaga/pages/tambahkendaraan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maxiaga/pages/login.dart';
import 'splashlogout.dart';

class Profile extends StatefulWidget {
  Position location;
  String name, email, photo, token;
  Profile(this.location, this.email, this.name, this.photo, @required this.token);
  @override
  _ProfileState createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {
  SharedPreferences preferences;
  
  void setPreference() async {
    // preferences = await SharedPreferences.getInstance();
    // name = preferences.getString('name');
    // email = preferences.getString('email');
  
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setPreference();
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
        backgroundColor: Colors.red,
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
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
        minHeight: 205,
        backgroundColor: Colors.red,
        // maxHeight: 500,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>TambahKendaraan()));
                  },
                ),
              ),
            ],
          ),
          ),
          Container(
            // padding: EdgeInsets.only(bottom: 50),
            child: Expanded(
            child: ListView.separated(
            separatorBuilder: (BuildContext context, int index)=>Divider(color: Colors.white,),
            itemCount: kendaraan.length,
            // shrinkWrap: true,
            itemBuilder: (context, int index){
              return Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 30),
                      width: 30,
                      child: iconKendaraan[index],
                    ),
                    Text(kendaraan[index],style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  // fontWeight: FontWeight.bold
                ),),
                  ],
                )
              );
            },
          ),
          ),
          )
        ],
      ),
      page: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    // backgroundImage: AssetImage('lib/assets/images/avatar.png'),
                    backgroundImage: NetworkImage(widget.photo),
                    radius: 50,
                    backgroundColor: Colors.transparent,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Text("${widget.name}", style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Container(
                    child: Text("${widget.email}", style: TextStyle(
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
                      child: Text("Alamat", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.only(top:5),
                      child: Text("Jl.Genuk Krajang II Kec.Candisari Semarang", style: TextStyle(
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
                      child: Text("082123456789", style: TextStyle(
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
