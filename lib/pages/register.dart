import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:compressimage/compressimage.dart';
import 'package:maxiaga/pages/login.dart';
import 'package:path/path.dart';

class Register extends StatefulWidget {
  Position location;
  Register({this.location});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordlController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _kotaController = TextEditingController();
  final _phoneController = TextEditingController();
  String dropdownValue = 'Laki-Laki';
  
  Color obsecureColor = Colors.black;
  Dio dio = new Dio();
  File _image;

  bool _obsecure = true;
  void _setObsecure(){
    setState(() {
      _obsecure = !_obsecure;
      if(obsecureColor == Colors.red){
        obsecureColor = Colors.black;
      }else{obsecureColor = Colors.red;}
    });
  }

Color obsecureColor1 = Colors.black;
  bool _obsecure1 = true;
  void _setObsecure1(){
    setState(() {
      _obsecure1 = !_obsecure1;
      if(obsecureColor1 == Colors.red){
        obsecureColor1 = Colors.black;
      }else{obsecureColor1 = Colors.red;}
    });
  }

  Future _postRegister(String name, File photo, String email, String password, String confirm, String kota, String phone, String gender) async {

    FormData formData = FormData.fromMap({
      'name': name,
      'photo':await MultipartFile.fromFile(photo.path,
          filename: basename(photo.path)),
      'kota':kota,
      'gender':gender,
      'phone':phone,
      'email':email,
      'password':password,
      'password_confirmation':confirm,
    });
    print(formData.fields);
    var res = await dio.post('http://maxiaga.com/backend/api/post_signup', data:formData);

    var jsonRes;
    print('executed');
    print(res);
    return res;

  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    print("before compress " + image.lengthSync().toString());
    while (image.lengthSync() > 2097152) {
      await CompressImage.compress(imageSrc: image.path, desiredQuality: 80);
//      print("compressed " + image.lengthSync().toString());
    }

    setState(() {
      _image = image;
      print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  // color: Colors.red
                  ),
              child: Center(
                child: Text(
                  "MAXIAGA",
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Form(
                key: _formKey,

                child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.red,
                          backgroundImage: _image != null ? FileImage(_image):AssetImage('lib/assets/images/avatar.png'),
                          radius: 50,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(height: 50, width: 50, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border:Border.all(color: Colors.red)),child: Center(child: IconButton(icon: Icon(Icons.add_a_photo, color: Colors.red,),onPressed: (){
                            showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Image'),
        content: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(icon: Icon(Icons.camera_alt, size: 50,),onPressed: ()async{
                Navigator.of(context).pop();
                getImage();
              },),
              IconButton(icon: Icon(Icons.image, size: 50,),onPressed: ()async{
                Navigator.of(context).pop();
                var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
              },),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
                          },),)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Nama', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      controller: _nameController,
                      validator: (val){
                        return val.isEmpty ? 'Nama Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      validator: (val){
                        return val.isEmpty ? 'Email Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue == 'L'? 'Laki-Laki':'Perempuan',
                          items: <String>['Laki-Laki', 'Perempuan'].map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              if(value == 'Laki-Laki'){
                                dropdownValue = 'L';
                              }else{
                                dropdownValue = 'P';
                              }
                              print(dropdownValue);
                            });
                          },
                        ),),
                  ),
                  Divider(thickness: 1,color: Colors.grey,),
                  Container(
                    child: TextFormField(
                      controller: _kotaController,
                      decoration: InputDecoration(labelText: 'Kota', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      validator: (val){
                        return val.isEmpty ? 'Kota Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'No.HP', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      validator: (val){
                        return val.isEmpty ? 'Nomor Handphone Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _passwordlController,
                      obscureText: _obsecure,
                      decoration: InputDecoration(suffixIcon: FlatButton(child: Icon(Icons.remove_red_eye, color: obsecureColor,),onPressed: (){_setObsecure();},),labelText: 'Password', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      
                      validator: (val){
                        if (val.isEmpty) {
                          return 'Password Kosong';
                        } else {
                          if (val == _passwordConfirmationController.text) {
                            return null;
                          } else {
                            return 'Password Tidak Sama';
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _passwordConfirmationController,
                      obscureText: _obsecure1,
                      decoration: InputDecoration(suffixIcon: FlatButton(child: Icon(Icons.remove_red_eye, color: obsecureColor1,),onPressed: (){_setObsecure1();},),labelText: 'Konfirmasi Password ', labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      
                      validator: (val){
                        if (val.isEmpty) {
                          return 'Password Kosong';
                        } else {
                          if (val == _passwordlController.text) {
                            return null;
                          } else {
                            return 'Password Tidak Sama';
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: FlatButton(
                        child: Center(
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            print(_image);
                            _postRegister(_nameController.text, _image, _emailController.text, _passwordlController.text, _passwordConfirmationController.text, _kotaController.text, _phoneController.text, dropdownValue);
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login(widget.location)), (Route<dynamic> route)=>false);
                          }
                        },
                      )),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
