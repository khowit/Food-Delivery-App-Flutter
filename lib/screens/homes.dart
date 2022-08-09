import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/screens/main_rider.dart';
import 'package:flutter_login/screens/main_shop.dart';
import 'package:flutter_login/screens/main_user.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/screens/sign_in.dart';
import 'package:flutter_login/screens/sign_up.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    checkPreference();    
  }

  Future<Null> checkPreference() async {
    try {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String token = await firebaseMessaging.getToken();
      print('Token ==> $token');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString('ChooseType');
      String idLogin = preferences.getString('id');
      print('loging = $idLogin');

      if(idLogin != null && idLogin.isNotEmpty){
          String url = '${ipConstant().domain}/gofood/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';

          await Dio().get(url).then((value) => print('Update Token Success'));
      }

      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == "User") {
          routeToService(MainUser());
        } else if (chooseType == "Shop") {
          routeToService(MainShop());
        } else if (chooseType == "Rider") {
          routeToService(MainRider());
        } else {
          normalDialog(context, "Error User");
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(children: <Widget>[
          showHeadDrawer(),
          signinMenu(),
          signUpMenu(),
        ]),
      );

  ListTile signinMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign In"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (vaule) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text("Sign Up"),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (vaule) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
        decoration: my_style().myBoxDecoration('Rider.jpg'),
        currentAccountPicture: my_style().showImage(),
        accountName: Text("ชื่อผู้ใช้งาน"),
        accountEmail: Text("Please Login"));
  }

}
