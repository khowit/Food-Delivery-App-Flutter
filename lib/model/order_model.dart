import 'dart:convert';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
    OrderModel({
        this.id,
        this.orderDateTime,
        this.idUser,
        this.nameUser,
        this.idShop,
        this.nameShop,
        this.distance,
        this.transport,
        this.idFood,
        this.nameFood,
        this.price,
        this.amount,
        this.sum,
        this.idRider,
        this.status,
    });

    dynamic id;
    String orderDateTime;
    String idUser;
    String nameUser;
    String idShop;
    String nameShop;
    String distance;
    String transport;
    String idFood;
    String nameFood;
    String price;
    String amount;
    String sum;
    String idRider;
    String status;

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderDateTime: json["OrderDateTime"],
        idUser: json["idUser"],
        nameUser: json["NameUser"],
        idShop: json["idShop"],
        nameShop: json["NameShop"],
        distance: json["Distance"],
        transport: json["Transport"],
        idFood: json["idFood"],
        nameFood: json["NameFood"],
        price: json["Price"],
        amount: json["Amount"],
        sum: json["Sum"],
        idRider: json["idRider"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "OrderDateTime": orderDateTime,
        "idUser": idUser,
        "NameUser": nameUser,
        "idShop": idShop,
        "NameShop": nameShop,
        "Distance": distance,
        "Transport": transport,
        "idFood": idFood,
        "NameFood": nameFood,
        "Price": price,
        "Amount": amount,
        "Sum": sum,
        "idRider": idRider,
        "Status": status,
    };
}
