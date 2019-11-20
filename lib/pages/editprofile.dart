import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/pages/login.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:compressimage/compressimage.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:maxiaga/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  Position location;
  EditProfile({this.location});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _name, _email, _photo, _token, _phone, _gender, _kota, genderPost;
  SharedPreferences preferences;
  final _formKey = GlobalKey<FormState>();
  List jk = [
    'Laki-Laki',
    'Perempuan'
  ];
  File _image;

  String _valueSelected;

  Dio dio = Dio();
//  String _photo;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _kotaController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _passwordConfirmController = new TextEditingController();

  Future _postEditProfile(String name, File photo, String gender,String email, String password, String token, String kota, String phone)async{
    FormData formData = FormData.fromMap({
      'name': name,
      'photo': photo != null ? await MultipartFile.fromFile(photo.path,
          filename: basename(photo.path)) : null,
      'email':email,
      'gender':gender,
      'kota':kota,
      'phone':phone,
      'password':password.isNotEmpty ? password : null,
      'token':token,
    });
    
    var res = await dio.post('http://maxiaga.com/backend/api/post_edit_profile',data: formData);
    print(res);
//    print(formData.fields);

    preferences = await SharedPreferences.getInstance();
    preferences.setString('name', res.data['name']);
    preferences.setString('photo', res.data['photo']);
    preferences.setString('email', res.data['email']);
    preferences.setString('gender', res.data['gender']);
    preferences.setString('phone', res.data['phone']);

  }

  void setPreference() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
//      _kendaraan = _decodeTodoData(preferences.getStringList('kendaraan'));
      _nameController.text = preferences.getString('name');
      _emailController.text = preferences.getString('email');
      _gender = preferences.getString('gender');
      _kotaController.text = preferences.getString('kota');
      _phoneController.text = preferences.getString('phone');
      _photo = preferences.getString('photo');
      _token = preferences.getString('token');

    });
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
//    print("before compress " + image.lengthSync().toString());
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
  void initState() {
    // TODO: implement initState
    setPreference();
    super.initState();
    setState(() {
      _gender != 'P' ? _valueSelected = 'Laki-Laki':_valueSelected = 'Perempuan';
    });
    print(_valueSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: FlatButton(
                child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: _photo == null ? AssetImage('lib/assets/images/avatar.png'): NetworkImage(_photo),
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text("Ganti Foto",style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400]
                    ),),
                  )
                ],
              ),
              onPressed: (){
                getImage();
              },
              )
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Nama"),
                        ),
                        Flexible(
                          child: TextFormField(
//                            initialValue: _nameController.text,
//                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            decoration: InputDecoration(
//                        hintText: _name,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Jenis Kelamin"),
                        ),
                        Flexible(
                            child: FormField<String>(
                              builder: (FormFieldState<String> state){
                                return InputDecorator(
                                  decoration: InputDecoration(
                                  ),
                                  isEmpty: _valueSelected == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _valueSelected,
                                      isDense: true,
                                      onChanged: (String newValue){
                                        setState(() {
                                          _valueSelected = newValue;
                                          if(_valueSelected == 'Laki-Laki'){
                                            _gender = 'L';
                                          }else{
                                            _gender = 'P';
                                          }
                                          print(_gender);
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: <String>['Laki-Laki','Perempuan'].map((String value){
                                        return new DropdownMenuItem(
                                          value: value  ,
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Email"),
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _emailController,
//                            initialValue:preferences.getString('email'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Telepon"),
                        ),
                        Flexible(
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
//                            initialValue: preferences.getString('phone'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Kota"),
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _kotaController,
//                            initialValue: 'ajfsnaksj',
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Password"),
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _passwordController,
//                            validator: (value){
//                              value != _passwordConfirmController.text ? 'Password tidak sama' : '';
//                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(right: 20),
                          child: Text("Password confirmation"),
                        ),
                        Flexible(
                          child: TextFormField(
//                            validator: (value){
//                              value != _passwordController.text ? 'Password tidak sama' : '';
//                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Container(
              margin: EdgeInsets.only(top:100),
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(2)
              ),
              child: Center(
                child: Text("SIMPAN",style:TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
              )),
              )
            ),
            onPressed: (){
                if(_formKey.currentState.validate()){
                  _postEditProfile(_nameController.text,_image, _gender,_emailController.text, _passwordController.text, _token, _kotaController.text,_phoneController.text);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage(locationNow: widget.location,index: 0,)), (Route<dynamic> route)=>false);
                }
            },
            )
          ],
        ),
        )
      ),
    );
  }
}