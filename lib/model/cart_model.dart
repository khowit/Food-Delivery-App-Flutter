import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
    CartModel({
        this.id,
        this.idShop,
        this.nameShop,
        this.idFood,
        this.nameFood,
        this.price,
        this.amount,
        this.sum,
        this.distance,
        this.transport,
    });

    int id;
    String idShop;
    String nameShop;
    String idFood;
    String nameFood;
    String price;
    String amount;
    String sum;
    String distance;
    String transport;

    factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        idShop: json["idShop"],
        nameShop: json["nameShop"],
        idFood: json["idFood"],
        nameFood: json["nameFood"],
        price: json["price"],
        amount: json["amount"],
        sum: json["sum"],
        distance: json["distance"],
        transport: json["transport"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idShop": idShop,
        "nameShop": nameShop,
        "idFood": idFood,
        "nameFood": nameFood,
        "price": price,
        "amount": amount,
        "sum": sum,
        "distance": distance,
        "transport": transport,
    };
}
