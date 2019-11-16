class SpbuProduct{
  int api_status;
  String api_messages;
  String api_authorization;
  List<Product> data;

  SpbuProduct.fromJson(Map<String, dynamic> json){
    api_status = json['api_status'];
    api_messages = json['api_messages'];
    api_authorization = json['api_authorization'];
    List<Product> tmp = [];
    for (var i = 0; i < json['data'].length; i++) {
      Product spbu = Product(json['data'][i]);
      tmp.add(spbu);
    }
    data = tmp;
  }

}

class Product{
  int id;
  String name;
  String image;
  String description;
  int harga;
  int stock;

  Product(data){
    id = data['id'];
    name = data['name'];
    image = data['image'];
    description = data['description'];
    harga = data['price'];
    stock = data['stock'];
  }

}