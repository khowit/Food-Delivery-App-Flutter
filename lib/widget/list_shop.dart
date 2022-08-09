import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/food_model.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/add_food_menu.dart';
import 'package:flutter_login/screens/edit_food_menu.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  @override
  _OrderListShopState createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  bool status = true;
  bool loadStatus = true;
  List<FoodModel> foodModels = List();

  @override
  void initState() {
    super.initState();
    readFoodMenu();
  }

  Future<Null> readFoodMenu() async {
    if (foodModels.length != 0) {
      foodModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString("id");

    String url =
        '${ipConstant().domain}/gofood/getFoodWhereShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != "null") {
        var result = json.decode(value.data);
        //print("result = $result");
        for (var map in result) {
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(() {
            foodModels.add(foodModel);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus ? my_style().showProgress() : showContent(),
        addMenuButton(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListFood()
        : Center(
            child: my_style().titleCenter("ยังไม่มีรายการอาหาร"),
          );
  }

  Widget showListFood() => ListView.builder(
        itemCount: foodModels.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.network(
                '${ipConstant().domain}${foodModels[index].pathImage}',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'ชื่อเมนู : ${foodModels[index].nameFood}',
                      style: my_style().mainStyle,
                    ),
                    Text(
                      'ราคา : ${foodModels[index].price} บาท',
                      style: my_style().mainStyle2,
                    ),
                    Text(
                      'รายละเอียด : ${foodModels[index].detail}',
                      style: my_style().mainStyle2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => EditFoodMenu(foodModel: foodModels[index],),
                              );Navigator.push(context, route).then((value) => readFoodMenu());
                            }),
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteFood(foodModels[index])),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: my_style().showTitle("คุณต้องการลบเมนู ${foodModel.nameFood} ใช่ไหม?"),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String url =
                              '${ipConstant().domain}/gofood/deleteFoodWhereId.php?isAdd=true&id=${foodModel.id}';
                          await Dio().get(url).then((value) => readFoodMenu());
                        },
                        child: Text("ยืนยัน")),
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("ยกเลิก"))
                  ],
                )
              ],
            )
          );
  }

  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => AddFoodMenu(),
                    );
                    Navigator.push(context, route)
                        .then((value) => readFoodMenu());
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      );
}
