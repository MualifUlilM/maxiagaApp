import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/models/spbu.dart';
import 'package:maxiaga/pages/Maps.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

class Servis extends StatefulWidget {
  Position location;
  Future<SPBU_API> spbu;
  String title, token;
  Servis({Key key, @required this.location, @required this.title, this.token, this.spbu}) : super(key: key);
  
  @override
  _ServisState createState() => _ServisState();
}

class _ServisState extends State<Servis> {
  String _valueSelected;
  List<DropdownMenuItem<SPBU>> spbuItems;
  SPBU selectedSpbu;
  File file;
  SharedPreferences preferences;

  List<DropdownMenuItem<SPBU>> buildDropdownMenuItems(List spbus) {
  List<DropdownMenuItem<SPBU>> items = List();
  for (SPBU spbus in spbus) {
    items.add(
      DropdownMenuItem(
        value: spbus,
        child: Text(spbus.name),
      ),
    );
  }
  return items;
}

@override
void initState() { 
  // spbuItems = buildDropdownMenuItems(widget.spbu);
  // selectedSpbu = spbuItems[0].value;
  super.initState();
    // SPBU x = widget.spbu[2];
    print(widget.spbu);
    print('asdasd');
    // print(widget.spbu[1].address);
}

void onChangeValue(SPBU spbuPilih){
  setState(() {
    selectedSpbu = spbuPilih;
  });
}

Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      file = image;
    });
  }

  // void _postImage() async {
  //   var res = http.po
  // }

  Future postImage() async {
    preferences = await SharedPreferences.getInstance();
    String base64Image = base64.encode(file.readAsBytesSync());
    String nameFile = file.path.split('/').last;
    print('ini file foto : $file');
    // Upload(file);
    var res = await http.post('http://maxiaga.com/backend/api/upload_photo_service', body: {
      'file':base64Image,
      'token': 'cefcfdae827e46e205b5774ec6c56da1',
    });
    var jsonRes = json.decode(res.body);
    if (res.statusCode == 200) {
      print(jsonRes['file']);
      return jsonRes;
    } else {
      throw Exception('cannot send Image');
    }
  }

  Upload(File imageFile) async {    
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();

      var uri = Uri.parse('http://maxiaga.com/backend/api/upload_photo_service');

     var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));
      request.fields['token'] = preferences.getString('key');
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }

    Future postService()async{

    }
    

  Widget buildImage(){
  if (file == null){
    return Center( child: Text('add image'),);
  }else{
    postImage();
    return Image.file(file);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                FlatButton(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(3)
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Lokasi"),
                        Icon(Icons.location_on)
                      ],
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Maps(location: widget.location,)));
                  },
                ),

//            FutureBuilder<SPBU_API>(
//              future: widget.spbu,
//              builder: (context, snapshot){
//                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
//                  var value = snapshot.data.data[0].name;
//                  return Container(
//                    height: 50,
//                    padding: EdgeInsets.all(10),
//                    margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
//                    color: Colors.grey[300],
//                    child: DropdownButton<String>(
//                      value: value,
//                      icon: Icon(Icons.arrow_drop_down),
//                      iconSize: 24,
//                      onChanged: (newValue){
//                        setState(() {
//                          value = newValue;
//                        });
//                      },
//                    ),
//                  );
//                }
//              },
//            ),
                Container(
                  height: 50,
//              padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                  color: Colors.grey[300],
                  child: ListTile(
                    trailing: Icon(Icons.arrow_drop_down),
                  ),

                ),
//            FutureBuilder<SPBU_API>(
//              future: widget.spbu,
//              builder: (context, snapshot){
//                print('ini snapshot');
//                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
//                  var value = snapshot.data.data[0].name;
//                  return Container(
//                    height: 50,
//                    padding: EdgeInsets.all(10),
//                    margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
//                    color: Colors.grey[300],
//                    child: DropdownButton<String>(
//                      value: value,
//                      icon: Icon(Icons.arrow_drop_down),
//                      iconSize: 24,
//                      onChanged: (newValue){
//                        setState(() {
//                          value = newValue;
//                        });
//                      },
//                    ),
//                  );
//                }
//              },
//            ),

                Container(
                  height: 50,
//              padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                  color: Colors.grey[300],
                  child: ListTile(
                    trailing: Icon(Icons.arrow_drop_down),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.grey[300],
                      hintText: 'Alamat Detail',
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
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
                        child: Center(child: buildImage() )
                    ),
                    FlatButton(
                      child: Container(
                          margin: EdgeInsets.all(20),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                          child: Center(child: Icon(Icons.add_a_photo, color: Colors.white,),)
                      ),
                      onPressed: (){
                        getImage();
                      },
                    ),

                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  height: 60,
                  // width: 120,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(3)),
                  child: Center(child: Text("Kirim", style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: Colors.white)),),
                ),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
            child: Center(
              child: Text('Coming Soon', style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),),
            ),
          )
        ],
      ),
      
    );
  }
}