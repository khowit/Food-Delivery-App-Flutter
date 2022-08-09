import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/show_shop_food_menu.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  @override
  _ShowListShopAllState createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {
  List<UserModel> userModels = List();
  List<Widget> shopCards = List();

  @override
  void initState() {
    super.initState();
    readShop();
  }

  Future<Null> readShop() async {
    String url =
        '${ipConstant().domain}/gofood/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      int index = 0;

      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        String nameShop = model.nameShop;

        if (nameShop.isNotEmpty) {
          print("NameShop = ${model.nameShop}");
          setState(() {
            userModels.add(model);
            shopCards.add(createCards(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCards(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print("$index");
        MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ShowShopFoodMenu(
                  userModel: userModels[index],
                ));
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${ipConstant().domain}${userModel.urlPicture}'),
                ),
              ),
              my_style().mySizeBox(),
              my_style().showTitle3(userModel.nameShop),
          ]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
        ? my_style().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 300.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: shopCards,
          );
  }
}
