import 'dart:convert';
import 'package:maxiaga/pages/splashScreen/splashlogin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:maxiaga/assets/maxcolor.dart';

class LoginForm extends StatefulWidget {
  Position location;
  LoginForm({this.location});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Color obsecureColor = Colors.black;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool loginGagal = false;

  bool _obsecure = true;
  void _setObsecure() {
    setState(() {
      _obsecure = !_obsecure;
      if (obsecureColor == MaxColor.merah) {
        obsecureColor = Colors.black;
      } else {
        obsecureColor = MaxColor.merah;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                controller: emailController,
                // textInputAction: TextInputAction.next,
                onSaved: (val) {
                  _username = val;
                },
                validator: (val) {
                  return val.isEmpty ? "Email kosong" : null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
              ),

            TextFormField(
                controller: passwordController,
                onSaved: (val) {
                  _password = val;
                },
                obscureText: _obsecure,
                validator: (val) {
                  return val.length < 1 ? "Password kosong" : null;
                },
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: FlatButton(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: obsecureColor,
                      ),
                      onPressed: _setObsecure,
                    )),
              ),

            Container(
        margin: EdgeInsets.only(top: 30),
        height: 60,
        decoration: BoxDecoration(
            color: MaxColor.merah, borderRadius: BorderRadius.circular(5)),
        child: FlatButton(
          child: Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          onPressed: () {
            if (formKey.currentState.validate()) {
              signIn(emailController.text, passwordController.text, widget.location);
            }
          },
        ))
          ],
        ),
      ),
    );
  }

  Widget loginButton(
    Position location,
    String email,
    String password,
  ) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        height: 60,
        decoration: BoxDecoration(
            color: MaxColor.merah, borderRadius: BorderRadius.circular(5)),
        child: FlatButton(
          child: Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          onPressed: () {
            if (formKey.currentState.validate()) {
              signIn(email, password, location);
            }
          },
        ));
  }

  List<String> _mapKendaraanData(List<dynamic> kendaraan) {
    try {
      var res = kendaraan.map((v) => json.encode(v)).toList();
      return res;
    } catch (err) {
      return [];
    }
  }

  signIn(String email, pass, Position location) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Tunggu Sebentar...')
                    ],
                  )));
        });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass,
    };
    var jsonRes = null;
    var res = await http.post("http://maxiaga.com/backend/api/post_login",
        body: data);
    Navigator.of(context, rootNavigator: true).pop();
    if (res.statusCode == 200) {
      jsonRes = json.decode(res.body);
      if (jsonRes != null && jsonRes['api_status'] == 1) {
        setState(() {
          _isLoading = false;
        });
        preferences.setString("token", jsonRes['token']);
        preferences.setString("name", jsonRes['name']);
        preferences.setString("photo", jsonRes['photo']);
        preferences.setString("email", jsonRes['email']);
        preferences.setString("phone", jsonRes['phone']);
        preferences.setString("gender", jsonRes['gender']);
        preferences.setString("kota", jsonRes['kota']);
        preferences.setString("phone", jsonRes['phone']);

        preferences.setStringList(
            'kendaraan', _mapKendaraanData(jsonRes['kendaraan']));
        print(preferences.getStringList('kendaraan'));
        print(preferences.get("token"));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    SplashLogin(jsonRes['token'])),
            (Route<dynamic> route) => false);
      } else {
        loginGagal = true;
        print(loginGagal);
        print(jsonRes['api_message']);
        setState(() {});
      }
    } else {
      throw Exception('Cannot Login');
    }
  }
}
