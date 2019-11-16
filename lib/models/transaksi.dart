class Get_Transaksi{
  int api_status;
  String api_messages;
  List<Transaksi> data;

  Get_Transaksi.fromJson(Map<String, dynamic> json){
    api_status = json['api_status'];
    api_messages = json['api_messages'];
    List<Transaksi> tmp = [];
    for (var i = 0; i < json['data'].length; i++) {
      Transaksi transaksi = Transaksi(json['data'][i]);
      tmp.add(transaksi);
    }
    data = tmp;
  }
}

class Transaksi{
  int id;
  String invoice;
  int id_mx_ms_category_service;
  String mx_ms_category_service_name;
  int id_mx_tb_kendaraan;
  int mx_tb_kendaraan_type;
  String mx_tb_kendaraan_merk;
  String mx_tb_kendaraan_brand;
  int mx_tb_kendaraan_tahun;
  String complaint;
  String photo;
  int id_mx_ms_outlets;
  String mx_ms_outlets_name;
  String mx_ms_outlets_address;
  String mx_ms_outlets_lng;
  String mx_ms_outlets_lat;
  int urgent;
  int driver;
  String address;
  String detail_address;
  String lng;
  String lat;
  int total;
  int ship;
  String status;
  String jenis;

  Transaksi(data){
    id = data['id'];
    invoice = data['invoice'];
    id_mx_ms_category_service = data['id_mx_ms_category_service'];
    mx_ms_category_service_name = data['mx_ms_category_service_name'];
    id_mx_tb_kendaraan = data['id_mx_tb_kendaraan'];
    mx_tb_kendaraan_type = data['mx_tb_kendaraan_type'];
    mx_tb_kendaraan_merk = data['mx_tb_kendaraan_merk'];
    mx_tb_kendaraan_brand = data['mx_tb_kendaraan_brand'];
    mx_tb_kendaraan_tahun = data['mx_tb_kendaraan_tahun'];
    complaint = data['complaint'];
    photo = data['photo'];
    id_mx_ms_outlets = data['id_mx_ms_outlets'];
    mx_ms_outlets_name = data['mx_ms_outlets_name'];
    mx_ms_outlets_address = data['mx_ms_outlets_address'];
    mx_ms_outlets_lng = data['mx_ms_outlets_lng'];
    mx_ms_outlets_lat = data['mx_ms_outlets_lat'];
    urgent = data['urgent'];
    driver = data['driver'];
    address = data['address'];
    detail_address = data['detail_address'];
    lng = data['lng'];
    lat = data['lat'];
    total = data['total'];
    ship = data['ship'];
    status = data['status'];
    jenis = data['jenis'];
  }
}
