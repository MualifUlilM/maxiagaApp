import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/main.dart';
import 'package:maxiaga/models/kendaraan.dart';
import 'package:maxiaga/models/spbu.dart';
// import 'package:maxiaga/auth.dart';
import 'package:maxiaga/models/user.dart';
import 'package:maxiaga/pages/register.dart';
import 'package:maxiaga/pages/splashlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:maxiaga/pages/login_screen_presenter.dart';
// import 'package:maxiaga/data/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';

class Login extends StatefulWidget {
  Position location;
  Login(this.location);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Maxiaga Login",
      home: LoginPage(widget.location),
      theme: ThemeData(primaryColor: Colors.red),
    );
  }
}

class LoginPage extends StatefulWidget {
  Position location;
  LoginPage(this.location);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BuildContext _ctx;
  List kendaraan;
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
      if (obsecureColor == Colors.red) {
        obsecureColor = Colors.black;
      } else {
        obsecureColor = Colors.red;
      }
    });
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
    showDialog(context: context,
        builder: (BuildContext context){
          return
            AlertDialog(
                content: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    child:Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text('Tunggu Sebentar...')
                      ],
                    )
                )
            );
        }
    );

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
//      preferences.setStringList("kendaraan", kendaraan);
//      print(preferences.getLisString('kendaraan'));
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

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Scaffold(
      appBar: null,
      key: scaffoldKey,
      backgroundColor: Colors.red,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
//                child: Text("MAXIAGA",style: TextStyle(
//                  fontSize: 28,
//                  color: Colors.white,
//                  fontWeight: FontWeight.bold
//                ),),
                child: Container(
                  height: 120,
                  width: 230,
                  child: Image.asset('lib/assets/images/maxiaga_putih.png'),
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
              child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      "Selamat datang",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "LOGIN untuk Lanjut",
                      style: TextStyle(fontSize: 14, color: Colors.grey
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextFormField(
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
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextFormField(
                              controller: passwordController,
                              onSaved: (val) {
                                _password = val;
                              },
                              obscureText: _obsecure,
                              validator: (val) {
                                return val.length < 1
                                    ? "Password kosong"
                                    : null;
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  // _isLoading ? new CircularProgressIndicator()
                  loginGagal == true
                      ? Container(
                          child: Text(
                            'Email atau password salah',
                            style: TextStyle(color: Colors.red),
                          ),
                          padding: EdgeInsets.only(top: 10),
                        )
                      : Text(''),

                  Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(locationNow: widget.location,)));
                          // _submit();
                          // setState(() {
                          //   _isLoading = false;
                          //   formKey.currentState.save();
                          //   _presenter.doLogin(_username, _password);
                          // });
                          if (formKey.currentState.validate()) {
                            // Scaffold
                            // .of(context).showSnackBar(SnackBar(content: Text('Signing in'),));
                            signIn(emailController.text,
                                passwordController.text, widget.location);
                          }
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Lupa Password?"),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text("Belum Punya Akun?"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Register(location: widget.location)));
                        },
                      )
                    ],
                  ),
                  Container(
                    child: Text("atau login dengan"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Text("G"),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Text("F"),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: Text("T"),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // @override
  // void onLoginError(String errorTxt) async{
  //   _showSnackBar(errorTxt);
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  // @override
  // void onLoginSuccess(User user) async {
  //   _showSnackBar(user.toString());
  //   setState(() {
  //     _isLoading = false;
  //   });
  // var db = new DatabaseHelper();
  // await db.saveUser(user);
  // var authStateProvider = new AuthStateProvider();
  // authStateProvider.notify(AuthState.LOGGED_IN);
  // }
}
