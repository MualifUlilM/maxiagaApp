class SPBU_API{
  int api_status;
  String api_message;
  String api_authorization;
  List<SPBU> data;

  SPBU_API.fromJson(Map<String, dynamic> json){
    api_status = json['api_status'];
    api_message = json['api_message'];
    api_authorization = json['api_authorization'];
    List<SPBU>temp = [];
    for(var i = 0; i < json['data'].length; i++){
      SPBU spbu = SPBU(json['data'][i]);
      temp.add(spbu);
    }
    data = temp;
  }
}

class SPBU{
  int id;
  String name;
  String address;
  double long;
  double lat;
  String id_province;
  String id_regency;
  String id_district;
  double distance;
  int is_service;
  int is_oil;
  int is_fuel;
  int is_tire;


  SPBU(data){
    id = data['id'];
    name = data['name'].toString();
    address = data['address'].toString();
    long = double.parse(data['lng']);
    lat = double.parse(data['lat']);
    id_province = data['id_province'].toString();
    id_regency = data['id_regency'].toString();
    id_district = data['id_district'].toString();
    distance = data['distance'];
    is_service = data['is_service'];
    is_oil = data['is_oil'];
    is_fuel = data['is_fuel'];
    is_tire = data['is_tire'];
  }

}