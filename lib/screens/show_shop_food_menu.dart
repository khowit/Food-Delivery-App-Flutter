import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:flutter_login/widget/about_shop.dart';
import 'package:flutter_login/widget/show_menu_food.dart';

class ShowShopFoodMenu extends StatefulWidget {
  final UserModel userModel;
  ShowShopFoodMenu({Key key, this.userModel}) : super(key: key);

  @override
  _ShowShopFoodMenuState createState() => _ShowShopFoodMenuState();
}

class _ShowShopFoodMenuState extends State<ShowShopFoodMenu> {
  UserModel userModel;
  List<Widget> listWidgets = List();
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(userModel: userModel,));
    listWidgets.add(ShowMenuFood(userModel: userModel,));
  }
  

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant), 
        label: "ลายละเอียดร้าน",
    );
  }

  BottomNavigationBarItem aboutMenuFoodNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu), 
        label: "เมนูอาหาร"
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[my_style().iconShowCart(context)],
        title: Text(userModel.nameShop),
      ),
      body: listWidgets.length == 0 ? my_style().showProgress() : listWidgets[indexPage],
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() => BottomNavigationBar(
    selectedItemColor: Colors.blue,
    currentIndex: indexPage,
    onTap: (value) {
    setState(() {
      indexPage = value;
    });
  },
        items: <BottomNavigationBarItem>[
          aboutShopNav(), 
          aboutMenuFoodNav()
    ],
  );
}
