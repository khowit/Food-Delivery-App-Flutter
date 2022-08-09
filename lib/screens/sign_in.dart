import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/main_rider.dart';
import 'package:flutter_login/screens/main_shop.dart';
import 'package:flutter_login/screens/main_user.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

String users, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: <Color>[Colors.white, my_style().darkColor],center: Alignment(0,-0.3),radius: 1.0,
                )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                my_style().showImage(),
                my_style().showTitle("GO FOOD"),
                my_style().mySizeBox(),
                my_style().mySizeBox(),
                userForm(),
                my_style().mySizeBox(),
                passwordForm(),
                my_style().mySizeBox(),
                login()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget login() => Container(
        width: 350.0,
        child: RaisedButton(
          color: my_style().darkColor,
          onPressed: () {
            if(users == null || users.isEmpty || password == null|| password.isEmpty){
                normalDialog(context, "มีช่องว่าง กรุณากรอกให้ครบค่ะ");
            }else{
                checkAuthen();
            }
          },
          child: Text(
            "login",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );


  Future<Null> checkAuthen() async{
      String url = '${ipConstant().domain}/gofood/getUserWhereUser.php?isAdd=true&Users=$users';

      try{
             Response response = await Dio().get(url);
             print("res = $response");

             var result = json.decode(response.data);
             print("result = $result");

             for (var map in result) {
                 UserModel userModel = UserModel.fromJson(map);
                 if(password == userModel.password){
                     String chooseType = userModel.chooseType;
                     
                     if(chooseType == 'User'){
                        routeToService(MainUser(), userModel);
                     }else if(chooseType == 'Shop'){
                        routeToService(MainShop(), userModel);
                     }else if(chooseType == 'Rider'){
                        routeToService(MainRider(), userModel);
                     }else{
                     normalDialog(context, "ลองใหม่อีกครั้ง");
                     }
                 }else{
                   normalDialog(context, "Password ไม่ถูกต้องกรุณากรอกใหม่");
                 }
             }

      }catch (e) {
          print(e);
      }
    }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(ipConstant().keyId, userModel.id);
    preferences.setString(ipConstant().keyType, userModel.chooseType);
    preferences.setString(ipConstant().keyName, userModel.name);

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget,);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => users = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: my_style().darkColor,
            ),
            labelStyle: TextStyle(color: my_style().darkColor),
            labelText: 'User ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().primayrColor))),
      ));

  Widget passwordForm() => Container(
      width: 350.0,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: my_style().darkColor,
            ),
            labelStyle: TextStyle(color: my_style().darkColor),
            labelText: 'Password ',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().darkColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: my_style().primayrColor))),
      ));
}
