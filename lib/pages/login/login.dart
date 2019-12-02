import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maxiaga/assets/maxcolor.dart';
import 'package:maxiaga/pages/login/forgetAndCreate.dart';
import 'package:maxiaga/pages/login/loginForm.dart';
import 'package:maxiaga/pages/login/externalLogin.dart';

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
      theme: ThemeData(primaryColor: MaxColor.merah),
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
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loginGagal = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: null,
      key: scaffoldKey,
      backgroundColor: MaxColor.merah,
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
                  LoginForm(
                    location: widget.location,
                  ),
                  // _isLoading ? new CircularProgressIndicator()
                  loginGagal == true
                      ? Container(
                          child: Text(
                            'Email atau password salah',
                            style: TextStyle(color: MaxColor.merah),
                          ),
                          padding: EdgeInsets.only(top: 10),
                        )
                      : Text(''),

                  // buildLoginButton(),
                  ButtonCreateForget(
                    location: widget.location,
                  ),
                  Container(
                    child: Text("atau login dengan"),
                  ),
                  ExternalLogin(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
