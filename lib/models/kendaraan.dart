class Kendaraan{
  var id;
  var type;
  var merk;
  var brand;
  var tahun;

//  Kendaraan(this.id, this.type, this.merk, this.brand, this.tahun);
  Kendaraan.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    merk = json['merk'];
    brand = json['brand'];
    tahun = json['tahun'];
  }
}