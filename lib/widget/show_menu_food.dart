import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/cart_model.dart';
import 'package:flutter_login/model/food_model.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/SQLite_helper.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  ShowMenuFood({Key key, this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel userModel;
  String idShop;
  List<FoodModel> foodModels = List();
  int amount = 1;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    idShop = userModel.id;
    String url =
        '${ipConstant().domain}/gofood/getFoodWhereShop.php?isAdd=true&idShop=$idShop';
    Response response = await Dio().get(url);
    //print("response = $response");

    var result = json.decode(response.data);
    print("response = $result");

    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? my_style().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    amount = 1;
                    confirmOrder(index);
                  },
                  child: Row(
                    children: <Widget>[
                      showFoodImage(context, index),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(foodModels[index].nameFood,
                                      style: my_style().mainStyle),
                                ],
                              ),
                              Text(
                                '${foodModels[index].price} บาท',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                              0.5 -
                                          8,
                                      child: Text(
                                          'รายละเอียด : ${foodModels[index].detail}')),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                ));
  }

  Container showFoodImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      width: MediaQuery.of(context).size.width * 0.5 - 16.0,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(
                '${ipConstant().domain}${foodModels[index].pathImage}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                foodModels[index].nameFood,
                style: my_style().mainStyle,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 150.0,
                height: 120.0,
                child: Image.network(
                  '${ipConstant().domain}${foodModels[index].pathImage}',
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 36,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          amount++;
                        });
                      }),
                  Text(
                    amount.toString(),
                    style: my_style().mainStyle,
                  ),
                  IconButton(
                      icon: Icon(Icons.remove_circle,
                          size: 36, color: Colors.red),
                      onPressed: () {
                        if (amount > 1) {
                          setState(() {
                            amount--;
                          });
                        }
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      width: 110.0,
                      child: RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            Navigator.pop(context);
                            addOrderToCart(index);
                          },
                          child: Text(
                            "Order",
                            style: TextStyle(color: Colors.white),
                          ))),
                  Container(
                    width: 110.0,
                    child: RaisedButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String nameShop = userModel.nameShop;
    String idFood = foodModels[index].id;
    String nameFood = foodModels[index].nameFood;
    String price = foodModels[index].price;

    int priceInt = int.parse(price);
    int sumInt = priceInt * amount;
    double distance = 2.3;
    int transport = 50;

    print(
        'idShop = $idShop, nameShop = $nameShop, idFood = $idFood, price = $priceInt, Amount = $amount, Sum = $sumInt, Distance = $distance, Transport = $transport');
    Map<String, dynamic> map = Map();

    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    map['distance'] = distance.toString();
    map['transport'] = transport.toString();

    print('Map ==> ${map}');
    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLlite().readAllDataFromSQLite();
    print('object = ${object.length}');

    if (object.length == 0) {
      await SQLlite().insertDataToSQLite(cartModel).then((value) {
        print('Insert Success');
        showToast();
      });
    } else {
      String idShopSQLite = object[0].idShop;
      print("idShopSQLite = $idShopSQLite");
      if (idShop == idShopSQLite) {
        await SQLlite().insertDataToSQLite(cartModel).then((value) {
          print("Insert Success");
          showToast();
        });
      } else {
        normalDialog(
            context, "ตะกร้ามีรายการอาหารของร้าน ${object[0].nameShop} ");
      }
    }
  }

  void showToast() {
    Fluttertoast.showToast(msg: "Order Success",  toastLength: Toast.LENGTH_LONG, gravity:  ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white);
  }
}
