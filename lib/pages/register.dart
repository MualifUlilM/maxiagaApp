import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordlController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  
  Color obsecureColor = Colors.black;

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

  Future _postRegister(String name, File photo, String email, String password, String confirm) async {

    String baseImage64 = base64Encode(photo.readAsBytesSync());

    var res = await http.post('http://maxiaga.com/backend/api/post_signup',body: {
      'name': name,
      'photo':baseImage64,
      'email':email,
      'password':password,
      'password_confirmation':confirm,
    });
    var jsonRes;
  if (res.statusCode == 200) {
    jsonRes = json.decode(res.body);
    print(jsonRes);
  } else {
    throw Exception('Cannot Post Data');
  }

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
                var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
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
                      decoration: InputDecoration(labelText: 'Nama'),
                      controller: _nameController,
                      validator: (val){
                        return val.isEmpty ? 'Nama Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (val){
                        return val.isEmpty ? 'Email Kosong':null;
                      },
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _passwordlController,
                      obscureText: _obsecure,
                      decoration: InputDecoration(suffixIcon: FlatButton(child: Icon(Icons.remove_red_eye, color: obsecureColor,),onPressed: (){_setObsecure();},),labelText: 'Password'),
                      
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
                      decoration: InputDecoration(suffixIcon: FlatButton(child: Icon(Icons.remove_red_eye, color: obsecureColor1,),onPressed: (){_setObsecure1();},),labelText: 'Konfirmasi Password '),
                      
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
                            _postRegister(_nameController.text, _image, _emailController.text, _passwordlController.text, _passwordConfirmationController.text).then((value){
                              print(value);
                            });
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
