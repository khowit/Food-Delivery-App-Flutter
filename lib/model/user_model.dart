import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.id,
        this.chooseType,
        this.name,
        this.users,
        this.password,
        this.nameShop,
        this.address,
        this.phone,
        this.urlPicture,
        this.token,
    });

    String id;
    String chooseType;
    String name;
    String users;
    String password;
    String nameShop;
    String address;
    String phone;
    String urlPicture;
    String token;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        chooseType: json["ChooseType"],
        name: json["Name"],
        users: json["Users"],
        password: json["Password"],
        nameShop: json["NameShop"],
        address: json["Address"],
        phone: json["Phone"],
        urlPicture: json["UrlPicture"],
        token: json["Token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "ChooseType": chooseType,
        "Name": name,
        "Users": users,
        "Password": password,
        "NameShop": nameShop,
        "Address": address,
        "Phone": phone,
        "UrlPicture": urlPicture,
        "Token": token,
    };
}
