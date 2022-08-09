import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/model/user_model.dart';
import 'package:flutter_login/screens/normal_dialog.dart';
import 'package:flutter_login/utility/ip_constant.dart';
import 'package:flutter_login/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInformation extends StatefulWidget {
  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  UserModel userModel;
  String nameShop, address, phone, urlPicture;

  @override
  void initState() {
    super.initState();
    readCurrent();
  }

  Future<Null> readCurrent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idShop = preferences.getString("id");

    String url =
        "${ipConstant().domain}/gofood/getUserWhereId.php?isAdd=true&id=$idShop";
    Response response = await Dio().get(url);
    print("response = $response");

    var result = json.decode(response.data);
    print("response = $response");

    for (var map in result) {
      print("map = $map");
      setState(() {
        userModel = UserModel.fromJson(map);
        nameShop = userModel.nameShop;
        address = userModel.address;
        phone = userModel.phone;
        urlPicture = userModel.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? my_style().showProgress() : showContent(),
      appBar: AppBar(title: Text("ปรับปรุงรายละเอียดร้าน")),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showImage(),
            nameShopForm(),
            addressForm(),
            phoneForm(),
            my_style().mySizeBox(),
            editButton(),
          ],
        ),
      );

  Widget editButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton.icon(
          color: my_style().primayrColor,
          onPressed: () => confirmDialog(),
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          label: Text("Save", style: TextStyle(color: Colors.white)),
        ),
      );

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("คุณแน่ใจไหม? ว่าต้องการแก้ไข"),
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
              editThread();
            },
            child: Text("แน่ใจ"),
          ),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ไม่แน่ใจ"),
            ),
          ],)
        ],
      ),
    );
  }
  
  Future<Null> editThread() async{
     String id = userModel.id;
     print("$id");
     String url = "${ipConstant().domain}/gofood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&Phone=$phone&UrlPicture=$urlPicture"; 
     Response response = await Dio().get(url);
     print("respone = $response");

     if(response.toString() == "true"){
        Navigator.pop(context);
     }else{
       normalDialog(context, "กรุณาลองใหม่อีกครั้ง");
     }
  }

  Widget showImage() => Container(
      margin: EdgeInsetsDirectional.only(top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(icon: Icon(Icons.add_a_photo), onPressed: null),
          Container(
              width: 250.0,
              height: 160.0,
              child: Image.network(
                  "${ipConstant().domain}${userModel.urlPicture}")),
          IconButton(icon: Icon(Icons.add_photo_alternate), onPressed: null),
        ],
      ));

  Widget nameShopForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => nameShop = value,
              initialValue: userModel.nameShop,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "ชื่อร้าน"),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => address = value,
              initialValue: userModel.address,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "ที่อยู่ร้าน"),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 320.0,
            child: TextFormField(
              onChanged: (value) => phone = value,
              initialValue: userModel.phone,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "เบอร์โทรร้าน"),
            ),
          ),
        ],
      );
}
