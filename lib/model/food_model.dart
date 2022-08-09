import 'dart:convert';

FoodModel foodModelFromJson(String str) => FoodModel.fromJson(json.decode(str));

String foodModelToJson(FoodModel data) => json.encode(data.toJson());

class FoodModel {
    FoodModel({
        this.id,
        this.idShop,
        this.nameFood,
        this.pathImage,
        this.price,
        this.detail,
    });

    String id;
    String idShop;
    String nameFood;
    String pathImage;
    String price;
    String detail;

    factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["id"],
        idShop: json["idShop"],
        nameFood: json["NameFood"],
        pathImage: json["PathImage"],
        price: json["Price"],
        detail: json["Detail"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idShop": idShop,
        "NameFood": nameFood,
        "PathImage": pathImage,
        "Price": price,
        "Detail": detail,
    };
}
