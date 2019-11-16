class UserData{
  String token;
  String name;
  String photo;
  String email;
  List<Kendaraan> kendaraan;

  UserData.fromJson(Map<String, dynamic>json){
    token = json['token'];
    name = json['name'];
    photo = json['photo'];
    email = json['email'];
    List<Kendaraan>temp = [];
    for (var i = 0; i < json['kendaraan'].length; i++) {
      Kendaraan kendaraan = Kendaraan(json['kendaraan'][i]);
      temp.add(kendaraan);
    }
    kendaraan = temp;
  }
}

class Kendaraan{
  int id;
  String type;
  String merk;
  String merkType;
  int tahun;

  Kendaraan(kendaraan){
    id = kendaraan['id'];
    type = kendaraan['type'];
    merk = kendaraan['merk'];
    merkType = kendaraan['merk_type'];
    tahun = kendaraan['tahun'];
  }
}