import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            // margin: EdgeInsets.all(50),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Image.asset('lib/assets/images/maxiaga_putih.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(20),
            child: Container(
              // height: MediaQuery.of(context).size.height / 2.8,
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(5),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey[600],
              //       offset: Offset(1, 1),
              //       blurRadius: 6
              //     )
              //   ]
              //   ),
              child: Center(
                child: Form(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.white
                            ),
                            
                          ),
                        ),
                         TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password'
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              // padding: EdgeInsets.all(6),
                              margin: EdgeInsets.only(top: 10),
                              child: FlatButton(
                                child: Text('Lupa Password ?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14
                                  ),
                                ),
                                onPressed: (){},
                              ),
                            ),
                            Container(
                          // padding: EdgeInsets.all(6),
                          margin: EdgeInsets.only(top: 10),
                          child: FlatButton(
                            child: Text('Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24
                              ),
                            ),
                            onPressed: (){},
                          ),
                        )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // FlatButton(
                //   child: Text('Lupa Password ?',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 16
                //     ),
                //   ),
                //   onPressed: (){},
                // ),
                FlatButton(
                  child: Text('Belum Punya Akun ?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),),
                  onPressed: (){},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Image.asset('lib/assets/images/google.png', scale: 15,),
                ),
                Container(
                  child: Image.asset('lib/assets/images/fb.png', scale: 15,),
                ),
                Container(
                  child: Image.asset('lib/assets/images/twitter.png', scale: 15,),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}