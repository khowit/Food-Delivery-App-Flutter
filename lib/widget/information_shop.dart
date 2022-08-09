import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/add_info.dart';
import 'package:flutter_login/screens/edits_Inshop.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationShop extends StatefulWidget {
  @override
  _InformationShopState createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String url =
        '${ipConstant().domain}/gofood/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) {
      print("Value = $value");
      var result = json.decode(value.data);
      print("Result = $result");

      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print("nameShop = ${userModel.nameShop}");
        if (userModel.nameShop.isEmpty) {}
      }
    });
  }

  void routeToAddInfo() {
    Widget widget = userModel.nameShop.isEmpty ? AddInfoShop() : EditInformation();
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? my_style().showProgress()
            : userModel.nameShop.isEmpty
                ? showNoData(context)
                : showListinfo(),
        addEditdata(),
      ],
    );
  }

  Widget showListinfo() => Column(children: <Widget>[
        my_style().showTitle("รายละเอียดร้าน ${userModel.nameShop}"),
        my_style().mySizeBox(),
        showImageShop(),
        Row(
          children: [
            my_style().showTitle("ที่อยู่ของร้าน"),
          ],
        ),
        Row(
          children: [
            my_style().showTitle2("${userModel.address}"),
          ],
        ),
      ]);

  Container showImageShop() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network("${ipConstant().domain}${userModel.urlPicture}"),
      );
  }

  

  Widget showNoData(BuildContext context) {
    return my_style().titleCenter('ยังไม่มีการทำรายการ');
  }

  Row addEditdata() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    routeToAddInfo();
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
