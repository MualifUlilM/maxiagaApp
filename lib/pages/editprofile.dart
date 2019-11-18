import 'package:flutter/material.dart';
import 'package:maxiaga/pages/login.dart';

class EditProfile extends StatefulWidget {
  String name, email, photo, token, phone, gender, kota;
  EditProfile({this.name, this.email, this.gender, this.kota, this.phone, this.photo, this.token});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _valueSelected;
  List jk = [
    'Laki-Laki',
    'Perempuan'
  ];
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
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/images/avatar.png'),
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
            ),
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
                      initialValue: widget.name,
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
                    child: TextFormField(),
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
                    child: TextFormField(),
                  )
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
            },
            )
          ],
        ),
        )
      ),
    );
  }
}