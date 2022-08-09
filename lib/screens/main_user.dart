import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/show_cart.dart';
import 'package:flutter_login/screens/show_shop_food_menu.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/widget/show_list_shop_all.dart';
import 'package:flutter_login/utility/signout_process.dart';
import 'package:flutter_login/widget/status_food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login/utility/my_style.dart';


class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser;
  Widget currentWidget;

  @override
  void initState() {
    super.initState();
    currentWidget = ShowListShopAll();
    findUsers();
  }

  

  Future<Null> findUsers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString("Name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == null ? "Main User" : "$nameUser Login"),
        actions: <Widget>[
          my_style().iconShowCart(context),
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () => signOutProcess(context))
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              showHeadDrawer(),
              menuListShop(),
              menuStatusFood(),
              menuCart(),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  ListTile menuListShop() {
    return ListTile(onTap: () {
      Navigator.pop(context);
      setState(() {
        currentWidget = ShowListShopAll();
      });
    },
      leading: Icon(Icons.home),
      title: Text("แหล่งร้านค้า"),
      subtitle: Text("แสดงชื่อร้านค้าต่างๆ"),
    );
  }

  ListTile menuStatusFood() {
    return ListTile(onTap: () {
      Navigator.pop(context);
      setState(() {
        currentWidget = ShowStatusListOrder();
      });
    },
      leading: Icon(Icons.restaurant_menu),
      title: Text("แสดงรายการอาหารที่สั่ง"),
      subtitle: Text("สถานะการสั่งซื้ออาหาร"),
    );
  }

  Widget menuCart() {
    return ListTile(onTap: () {
      Navigator.pop(context);
      MaterialPageRoute route = MaterialPageRoute(builder: (context) => ShowCart(),);
      Navigator.push(context, route);
    },
      leading: Icon(Icons.add_shopping_cart),
      title: Text("ตะกร้า"),
      subtitle: Text("รายการการสั่งซื้ออาหารที่ถูกสั่ง"),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Colors.orange),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(Icons.exit_to_app),
        title: Text(
          "Log Out",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: my_style().myBoxDecoration('User.jpg'),
        currentAccountPicture: my_style().showImage(),
        accountName: Text(
          nameUser == null ? "ชื่อผู้ใช้งาน" : nameUser,
          style: my_style().mainStyle,
        ),
        accountEmail: Text(
          "Login",
          style: my_style().mainStyle,
        ));
  }
}
